class InboundRequestsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:aws], raise: false
  skip_before_action :verify_authenticity_token, only: %i[aws azure dropbox s3_event]

  def aws
    notification = JSON.parse(request.raw_post).with_indifferent_access

    case notification[:Type]
    when 'SubscriptionConfirmation'
      AwsSnsService.confirm(notification[:TopicArn], notification[:Token])
    else
      payload = notification[:Records][0]
      event_name = payload.dig(:eventName)
      aws_bucket_name = payload.dig(:s3, :bucket, :name)

      if (AwsEventTypes.created.include?(event_name) || AwsEventTypes.restore.include?(event_name)) && AwsBucketNames.documents.include?(aws_bucket_name)
        Document.track_s3_object(payload)
      elsif (AwsEventTypes.created.include?(event_name) || AwsEventTypes.restore.include?(event_name)) && AwsBucketNames.assets.include?(aws_bucket_name)
        Asset.track_s3_object(payload)
      elsif AwsEventTypes.removed.include?(event_name) && AwsBucketNames.documents.include?(aws_bucket_name)
        Document.untrack_s3_object(payload)
      elsif AwsEventTypes.removed.include?(event_name) && AwsBucketNames.assets.include?(aws_bucket_name)
        Asset.untrack_s3_object(payload)
      else
        Rails.logger.error "AWS: Unknown notification type #{notification[:Type]}"
      end
    end

    head :ok
  end

  def azure
    notification = JSON.parse(request.raw_post).first

    case notification['eventType']
    when 'Microsoft.EventGrid.SubscriptionValidationEvent'
      render json: { 'validationResponse' => notification['data']['validationCode'] }
      return
    when 'Microsoft.Storage.BlobCreated'
      StorageAssetService::Azure::HandleBlobCreatedEvent.new(notification).call
    when 'Microsoft.Storage.BlobDeleted'
      StorageAssetService::Azure::HandleBlobDeletedEvent.new(notification).call
    when 'Microsoft.Storage.BlobTierChanged'
      StorageAssetService::Azure::HandleBlobTierChangedEvent.new(notification).call
    end

    head :ok
  end

  def dropbox
    if request.get?
      render plain: params[:challenge]
    else
      request_body = request.raw_post
      dropbox_signature = request.headers['X-Dropbox-Signature'].to_s
      client_secret = Rails.application.credentials.dig(:storage_assets, :dropbox, :client_secret)

      signature = OpenSSL::HMAC.hexdigest('SHA256', client_secret, request_body)

      if dropbox_signature.present? && ActiveSupport::SecurityUtils.secure_compare(signature, dropbox_signature)
        StorageAssetService::Dropbox::HandleWebhookEvent.new.call
        head :ok
      else
        render json: { error: 'Invalid signature' }, status: :unauthorized
      end
    end
  end

  def s3_event
    notification = JSON.parse(request.raw_post)

    if notification['Type'] == 'SubscriptionConfirmation'
      AwsSnsService.confirm(notification['TopicArn'], notification['Token'])
    else
      message = JSON.parse(notification['Message'])

      case message['detail-type']
      when 'Object Created'
        StorageAssetService::S3::HandleCreatedEvent.new(message).call
      when 'Object Deleted'
        StorageAssetService::S3::HandleDeletedEvent.new(message).call
      when 'Object Restore Initiated'
        StorageAssetService::S3::HandleRestoreInitiatedEvent.new(message).call
      when 'Object Restore Completed'
        StorageAssetService::S3::HandleRestoreCompletedEvent.new(message).call
      when 'Object Restore Expired'
        StorageAssetService::S3::HandleRestoreExpiredEvent.new(message).call
      when 'Object Storage Class Changed'
        StorageAssetService::S3::HandleTierChangedEvent.new(message).call
      end
    end

    head :ok
  end
end
