class Admin::StatsController < AdminController
  include Pagy::Backend

  before_action :authenticate_user!

  def index
    authorize(policy_class)
    @q = controller_class.ransack(params[:q])
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
        stats
      WHERE
        stats.archived_at IS NULL
      ORDER BY
        stats.created_at ASC
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
        stats
      WHERE
        stats.id = #{instance.id}
      ORDER BY
        stats.created_at ASC
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

  private

  def create_params
    params.require(:stat).permit(
      :_2b,
      :_3b,
      :ab,
      :archived_at,
      :avg,
      :ba_rank,
      :bb,
      :cbs_rank,
      :cs,
      :fg_bat_ctrl,
      :fg_fld_pres,
      :fg_fld_proj,
      :fg_fv,
      :fg_hard_hit,
      :fg_hit_pres,
      :fg_hit_proj,
      :fg_org_rank,
      :fg_pit_sel,
      :fg_pwr_pres,
      :fg_pwr_proj,
      :fg_spd_pres,
      :fg_spd_proj,
      :fg_top_rank,
      :hits,
      :hr,
      :k,
      :kl_rank,
      :mcd_fv,
      :mcd_rank,
      :mlb_rank,
      :obp,
      :pa,
      :player_id,
      :rbi,
      :runs,
      :sb,
      :slg,
      :timeline,
    )
  end

  def update_params
    params.require(:stat).permit(
      :_2b,
      :_3b,
      :ab,
      :archived_at,
      :avg,
      :ba_rank,
      :bb,
      :cbs_rank,
      :cs,
      :fg_bat_ctrl,
      :fg_fld_pres,
      :fg_fld_proj,
      :fg_fv,
      :fg_hard_hit,
      :fg_hit_pres,
      :fg_hit_proj,
      :fg_org_rank,
      :fg_pit_sel,
      :fg_pwr_pres,
      :fg_pwr_proj,
      :fg_spd_pres,
      :fg_spd_proj,
      :fg_top_rank,
      :hits,
      :hr,
      :k,
      :kl_rank,
      :mcd_fv,
      :mcd_rank,
      :mlb_rank,
      :obp,
      :pa,
      :player_id,
      :rbi,
      :runs,
      :sb,
      :slg,
      :timeline,
    )
  end
end
