# Storage Assets - Amazon S3

## Files tracked

Avails currently tracks all objects under the following buckets:

- `avails-assets-production`
- `avails-documents-production`

## Credentials used in Rails

The following credentials for accessing Amazon S3 are set as Rails credentials under `:storage_assets` -> `:s3`:

### `:access_key_id`

Access key for `avails_storage_assets` IAM user.

### `:secret_access_key`

Secret access key for `avails_storage_assets` IAM user.

### `:region`

Region where tracked S3 buckets are located.

## Initial import / Refresh

The initial import for Dropbox storage assets is done with [`Maintenance::ImportS3StorageAssetsTask`](https://avails.mpimediagroup.com/admin/maintenance_tasks/tasks/Maintenance::ImportS3StorageAssetsTask). This maintenance task can also be used to refresh the storage asset data if needed.

## Webhook events

### API endpoint in Avails

`POST /inbound_requests/s3_event`

### Setting up webhook notifications

Event notifications for the tracked S3 buckets are sent to Avails through Amazon EventBridge with an Amazon SNS topic as the target.

#### Create a new Amazon SNS topic

- Type: Standard

#### Create a new Amazon SNS subscription

- Protocol: HTTPS
- Endpoint: `https://avails.mpimediagroup.com/inbound_requests/s3_event`

#### Webhook subscription validation

AWS sends a `SubscriptionConfirmation` event to the SNS topic. Avails confirms the subscription by calling `AwsSnsService.confirm` with the `"TopicArn"` and `"Token"` values.

#### Create a new Amazon EventBridge rule

- Event bus: default
- Rule type: Rule with an event pattern
- Event source: AWS events or EventBridge partner events
- Method: Use pattern form
- Event pattern → Event source: AWS services
- Event pattern → AWS service: Simple Storage Service (S3)
- Event pattern → Event type: Amazon S3 Event Notification
- Event pattern → Event types: Specific events
  - Object Created
  - Object Deleted
  - Object Restore Initiated
  - Object Restore Completed
  - Object Restore Expired
  - Object Storage Class Changed
- Target types: AWS service
- Select a target: SNS topic
- Topic: ARN of created SNS topic

#### Update settings for buckets to track

- Go to the bucket to track on the Amazon S3 console.
- Under "Properties”, to go Amazon EventBridge and click Edit.
- Set "Send notifications to Amazon EventBridge for all events in this bucket” to "On”.

## Notes

- S3 objects cannot be renamed, and when using an interface or API that allows you to change the name of an object, it deletes the object first and creates the same object with the new name. EventBridge will trigger the `Object Deleted` event followed by the `Object Created` event, similar to how Avails does when renaming a blob.
- Objects that are archived (in the Glacier Flexible Retrieval or Glacier Deep Archive storage classes) can be unarchived through Avails to allow for downloading. The unarchiving process can take more than 12 hours to complete, and the storage asset will receive the `Object Restore Initiated` event to place the object in the “Unarchiving in Progress” state. When the retrieval process ends, S3 sends the `Object Restore Completed` to mark the storage asset as available for download
- Unlike Azure, unarchiving an object will keep the it in its original storage class but will temporarily allow the object to be downloaded. Unarchiving through Avails will set the object available to download for seven days from restoration. When Avails receives the `Object Restore Completed` event it will set a “Temporarily Restored” state to the object. Later, when the object's download time expires, Avails receives the `Object Restore Expired` event to restrore the original state and storage class of the storage asset.
- Presigned URLs to allow for direct downloads of an object will be generated when going to the storage asset details page in Avails if there's no existing URL or an existing has expired. Presigned URLs for S3 are valid for 1 hour before they expire and are no longer available to use.
