class ScreeningRequestsController < ApplicationController
  include Pagy::Backend

  before_action :authenticate_user!

  def index
    authorize(controller_class)
    @q = controller_class.includes(:title, :label, :user).ransack(index_archivable_params)
    @q.sorts = ['created_at desc'] if @q.sorts.empty?
    @pagy, @instances = pagy(@q.result)
    @instance = controller_class.new
  end

  def show
    authorize(controller_class)
    @instance = controller_class.includes(:title, :label, :user).find(params[:id])
  end

  def new
    authorize(controller_class)
    @instance = controller_class.new
  end

  def create
    authorize(controller_class)

    params[:slug] = SecureRandom.hex(12)

    instance = controller_class.create(create_params)

    instance.log(user: current_user, action_type: DataLogActionTypes::CREATED, meta: params.to_json)
    flash[:success] = "New #{controller_class_instance.titleize} successfully created"
    redirect_to send("#{controller_class_instance}_path", instance)
  end

  def edit
    authorize(controller_class)
    @instance = controller_class.find(params[:id])
  end

  def update
    authorize(controller_class)
    instance = controller_class.find(params[:id])
    original_instance = instance.dup

    params[:active] = params[:active].present? ? true : false
    instance.update(update_params)

    instance.log(user: current_user, action_type: DataLogActionTypes::UPDATED, meta: params.to_json, original_data: original_instance.attributes.to_json)
    flash[:success] = "#{controller_class_instance.humanize.capitalize} successfully updated"
    redirect_to send("#{controller_class_instance}_path", instance)
  end

  def destroy
    authorize(controller_class)
    instance = controller_class.find(params[:id])
    instance.archive

    instance.log(user: current_user, action_type: DataLogActionTypes::ARCHIVED)
    flash[:danger] = "#{controller_class_instance.humanize.capitalize} successfully deleted"
    redirect_to send("#{controller_class_instances}_path")
  end

  def export_xlsx
    authorize(controller_class)

    sql = %(
      SELECT
        screening_requests.id AS id,
        screening_requests.requestor_title_name AS requestor_title_name,
        screening_requests.status AS status,
        screening_requests.requestor_name AS requestor_name,
        screening_requests.phone_number AS requestor_phone_number,
        screening_requests.email AS requestor_email,
        screening_requests.organization_name AS org_name,
        screening_requests.organization_social_media AS org_social_media,
        screening_requests.business_type AS business_type,
        screening_requests.organization_type AS org_type,
        screening_requests.organization_url AS org_url,
        screening_requests.organization_notes AS org_notes,
        screening_requests.venue_name AS venue_name,
        screening_requests.venue_location AS venue_location,
        screening_requests.venue_country AS venue_country,
        screening_requests.venue_capacity AS venue_capacity,
        screening_requests.file_format AS file_format,
        screening_requests.equipment_notes AS equipment_notes,
        screening_requests.marketing_notes AS marketing_notes,
        screening_requests.screening_number AS screening_number,
        screening_requests.screening_date AS screening_date,
        screening_requests.screening_time AS screening_time,
        screening_requests.screening_date_notes AS screening_date_notes,
        screening_requests.is_ticketed AS is_ticketed,
        screening_requests.ticket_price AS ticket_price,
        screening_requests.expected_attendance AS expected_attendance,
        screening_requests.requestor_notes AS requestor_notes,
        screening_requests.pricing_notes AS pricing_notes,
        screening_requests.staff_notes AS staff_notes,
        screening_requests.mailing_list_opt_in AS opt_in,
        screening_requests.billing_address AS billing_address,
        screening_requests.billing_phone AS billing_phone,
        screening_requests.billing_email AS billing_email,
        screening_requests.archived_at AS archived_at,
        screening_requests.created_at AS created_at,
        screening_requests.updated_at AS updated_at
      FROM
        screening_requests
      LEFT JOIN
        titles ON screening_requests.title_id = titles.id
      LEFT JOIN
        labels ON titles.label_id = labels.id
      LEFT JOIN
        users ON screening_requests.user_id = users.id
      WHERE
        screening_requests.archived_at IS NULL
      ORDER BY
        screening_requests.created_at ASC
    )

    @results = ActiveRecord::Base.connection.select_all(sql)
    file_name = controller_class_instances
    filepath = "#{Rails.root}/tmp/#{file_name}.xlsx"

    File.open(filepath, 'wb') do |f|
      f.write render_to_string(handlers: [:axlsx], formats: [:xlsx], template: 'xlsx/reports')
    end

    render xlsx: 'reports', handlers: [:axlsx], formats: [:xlsx], template: 'xlsx/reports', filename: helpers.file_name_with_timestamp(file_name:, file_extension: 'xlsx')
  end

  def public_new
    authorize(controller_class)
    @instance = controller_class.new
    render layout: 'screening_request_public'
  end

  def public_create
    authorize(controller_class)

    params[:slug] = SecureRandom.hex(12)
    params[:request_host] = request.host

    instance = controller_class.create(public_create_params)

    send_screening_request_created_notification(instance)
    redirect_to screening_request_public_show_path(slug: instance.slug)
  end

  def public_edit
    authorize(controller_class)
    @instance = controller_class.find_by(slug: params[:slug])
    render layout: 'screening_request_public'
  end

  def public_update
    instance = controller_class.find_by(slug: params[:slug])
    instance.update(public_update_params)
    redirect_to screening_request_public_show_path(slug: instance.slug)
  end

  def public_show
    authorize(controller_class)
    @instance = controller_class.find_by(slug: params[:slug])
    render layout: 'screening_request_public'
  end

  private

  def send_screening_request_created_notification(instance)
    notification = ScreeningRequestCreatedNotification.with(record: instance)
    NotificationSetting.subscribers(topic: NotificationTopics::SCREENING_REQUEST_CREATED).each do |subscriber|
      notification.deliver_later(subscriber)
    end
  end

  def create_params
    params.permit(
      :archived_at,
      :billing_address,
      :billing_email,
      :billing_phone,
      :business_type,
      :email,
      :equipment_notes,
      :expected_attendance,
      :fedex_shipping_code,
      :file_format,
      :is_ticketed,
      :mailing_list_opt_in,
      :marketing_notes,
      :organization_name,
      :organization_notes,
      :organization_social_media,
      :organization_type,
      :organization_url,
      :phone_number,
      :pricing_notes,
      :request_host,
      :requestor_name,
      :requestor_title_name,
      :screening_date,
      :screening_date_notes,
      :screening_number,
      :screening_time,
      :slug,
      :staff_notes,
      :status,
      :ticket_price,
      :title_id,
      :user_id,
      :venue_capacity,
      :venue_country,
      :venue_location,
      :venue_name,
    )
  end

  def update_params
    params.permit(
      :archived_at,
      :billing_address,
      :billing_email,
      :billing_phone,
      :business_type,
      :email,
      :equipment_notes,
      :expected_attendance,
      :fedex_shipping_code,
      :file_format,
      :is_ticketed,
      :mailing_list_opt_in,
      :marketing_notes,
      :organization_name,
      :organization_notes,
      :organization_social_media,
      :organization_type,
      :organization_url,
      :phone_number,
      :pricing_notes,
      :requestor_name,
      :requestor_title_name,
      :screening_date,
      :screening_date_notes,
      :screening_number,
      :screening_time,
      :slug,
      :staff_notes,
      :status,
      :ticket_price,
      :title_id,
      :user_id,
      :venue_capacity,
      :venue_country,
      :venue_location,
      :venue_name,
    )
  end

  def public_create_params
    params.permit(
      :billing_address,
      :billing_email,
      :billing_phone,
      :business_type,
      :email,
      :equipment_notes,
      :expected_attendance,
      :fedex_shipping_code,
      :file_format,
      :is_ticketed,
      :mailing_list_opt_in,
      :marketing_notes,
      :organization_name,
      :organization_notes,
      :organization_social_media,
      :organization_type,
      :organization_url,
      :phone_number,
      :request_host,
      :requestor_name,
      :requestor_notes,
      :requestor_title_name,
      :screening_date,
      :screening_date_notes,
      :screening_number,
      :screening_time,
      :slug,
      :ticket_price,
      :venue_capacity,
      :venue_country,
      :venue_location,
      :venue_name,
    )
  end

  def public_update_params
    params.permit(
      :billing_address,
      :billing_email,
      :billing_phone,
      :business_type,
      :email,
      :equipment_notes,
      :expected_attendance,
      :fedex_shipping_code,
      :file_format,
      :is_ticketed,
      :mailing_list_opt_in,
      :marketing_notes,
      :organization_name,
      :organization_notes,
      :organization_social_media,
      :organization_type,
      :organization_url,
      :phone_number,
      :requestor_name,
      :requestor_notes,
      :requestor_title_name,
      :screening_date,
      :screening_date_notes,
      :screening_number,
      :screening_time,
      :ticket_price,
      :venue_capacity,
      :venue_country,
      :venue_location,
      :venue_name,
    )
  end
end
