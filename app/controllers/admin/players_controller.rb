class Admin::PlayersController < AdminController
  include Pagy::Backend

  before_action :authenticate_user!

  def index
    authorize(policy_class)
    @q = controller_class.ransack(params[:q])
    @q.sorts = controller_class.default_sort if @q.sorts.empty?
    @pagy, @instances = pagy(@q.result)
    @instance = controller_class.new
  end

  def dashboard
    authorize(policy_class)

    @q = controller_class
         .includes(:team, :roster, :level, :status, :tracking_lists)
         .joins("LEFT JOIN stats ON stats.player_id = players.id AND stats.timeline = '2025' AND stats.timeline_type = 'ytd'")
         .joins("LEFT JOIN scouting_profiles ON scouting_profiles.player_id = players.id AND scouting_profiles.timeline = '2025' AND scouting_profiles.timeline_type = 'ytd'")
         .joins('LEFT JOIN tracking_list_players ON tracking_list_players.player_id = players.id')
         .select(
           "players.id AS player_id, players.*, stats.*, scouting_profiles.*,
            COALESCE(array_agg(tracking_list_players.tracking_list_id) FILTER (WHERE tracking_list_players.tracking_list_id IS NOT NULL), ARRAY[]::integer[]) AS aggregated_tracking_list_ids"
         )
         .group('players.id, stats.id, scouting_profiles.id')
         .ransack(params[:q])
    @q.sorts = controller_class.default_sort if @q.sorts.empty?
    @pagy, @instances = pagy(@q.result)

    @instance = controller_class.new
  end

  def show
    authorize(policy_class)
    @instance = controller_class.find(params[:id])
  end

  def new
    authorize(policy_class)
    @instance = controller_class.new
  end

  def create
    authorize(policy_class)
    instance = controller_class.create(create_params)

    instance.log(user: current_user, operation: action_name, meta: params.to_json)
    flash[:success] = "New #{instance.class_name_title} successfully created"
    redirect_to polymorphic_path([:admin, instance])
  end

  def edit
    authorize(policy_class)
    @instance = controller_class.find(params[:id])
  end

  def update
    authorize(policy_class)
    instance = controller_class.find(params[:id])
    original_instance = instance.dup

    instance.update(update_params)

    instance.log(user: current_user, operation: action_name, meta: params.to_json, original_data: original_instance.attributes.to_json)
    flash[:success] = "#{instance.class_name_title} successfully updated"
    redirect_to polymorphic_path([:admin, instance])
  end

  def destroy
    authorize(policy_class)
    instance = controller_class.find(params[:id])

    instance.log(user: current_user, operation: action_name)
    flash[:danger] = "#{instance.class_name_title} successfully deleted"

    instance.destroy

    redirect_to polymorphic_path([:admin, controller_class])
  end

  def archive
    instance = controller_class.find(params[:id])
    authorize(policy_class)
    instance.archive

    instance.log(user: current_user, operation: action_name)
    flash[:danger] = "#{instance.class_name_title} successfully archived"
    redirect_to polymorphic_path([:admin, controller_class])
  end

  def unarchive
    authorize(policy_class)
    instance = controller_class.find(params[:id])
    instance.unarchive

    instance.log(user: current_user, operation: action_name)
    flash[:success] = "#{instance.class_name_title} successfully unarchived"
    redirect_to polymorphic_path([:admin, instance])
  end

  def collection_export_xlsx
    authorize(policy_class)

    sql = %(
      SELECT
        *
      FROM
        players
      WHERE
        players.archived_at IS NULL
      ORDER BY
        players.created_at ASC
    )

    @results = ActiveRecord::Base.connection.select_all(sql)
    file_name = controller_class_plural

    send_data(
      render_to_string(
        template: 'admin/xlsx/reports',
        formats: [:xlsx],
        handlers: [:axlsx],
        layout: false
      ),
      filename: helpers.file_name_with_timestamp(file_name: file_name, file_extension: 'xlsx'),
      type: Mime[:xlsx]
    )
  end

  def member_export_xlsx
    authorize(policy_class)
    instance = controller_class.find(params[:id])

    sql = %(
      SELECT
        *
      FROM
        players
      WHERE
        players.id = #{instance.id}
      ORDER BY
        players.created_at ASC
    )

    @results = ActiveRecord::Base.connection.select_all(sql)
    file_name = controller_class_singular

    send_data(
      render_to_string(
        template: 'admin/xlsx/reports',
        formats: [:xlsx],
        handlers: [:axlsx],
        layout: false
      ),
      filename: helpers.file_name_with_timestamp(file_name: file_name, file_extension: 'xlsx'),
      type: Mime[:xlsx]
    )
  end

  def profile
    @instance = controller_class.includes(:scouting_reports).find(params[:id])
    @scouting_reports = @instance.scouting_reports
  end

  private

  def create_params
    params.require(:player).permit(
      :level,
      :name,
      :notes,
      :position,
      :roster_id,
      :status,
      :team_id,
    )
  end

  def update_params
    params.require(:player).permit(
      :archived_at,
      :level,
      :name,
      :notes,
      :position,
      :roster_id,
      :status,
      :team_id,
    )
  end
end
