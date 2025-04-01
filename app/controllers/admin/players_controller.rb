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

    # Set player_type from params or default to 'batter'
    @player_type = params[:player_type] || 'batter'

    # Apply player_type filter to the base query
    base_query = controller_class
    if @player_type.present?
      # If player_type parameter exists, add it to the query
      base_query = base_query.where(player_type: @player_type)
    end

    @q = base_query
         .select([
           'players.id AS player_id',
           'players.player_type',
           'players.first_name',
           'players.last_name',
           'players.position',
           'players.eligible_positions',
           'players.team_id',
           'players.roster_id',
           'players.level_id',
           'players.status_id',
           'players.age',

           'scouting_profiles.risk',
           'scouting_profiles.eta',
           'scouting_profiles.espn_overall_rank',
           'scouting_profiles.ath_overall_rank',
           'scouting_profiles.ba_overall_rank',
           'scouting_profiles.pl_overall_rank',
           'scouting_profiles.cbs_overall_rank',
           'scouting_profiles.fg_overall_rank',
           'scouting_profiles.self_overall_rank',
           'scouting_profiles.espn_team_rank',
           'scouting_profiles.ath_team_rank',
           'scouting_profiles.ba_team_rank',
           'scouting_profiles.pl_team_rank',
           'scouting_profiles.cbs_team_rank',
           'scouting_profiles.fg_team_rank',
           'scouting_profiles.self_team_rank',
           'scouting_profiles.espn_future_value',
           'scouting_profiles.ath_future_value',
           'scouting_profiles.ba_future_value',
           'scouting_profiles.pl_future_value',
           'scouting_profiles.cbs_future_value',
           'scouting_profiles.fg_future_value',
           'scouting_profiles.self_future_value',

           'stats.bat_ops',
           'stats.bat_hr',
           'stats.bat_rbi',
           'stats.bat_runs',
           'stats.bat_nsb',
           'stats.bat_errors',
           'stats.bat_wrc_plus',

           'stats.bat_pa',
           'stats.bat_ab',
           'stats.bat_avg',
           'stats.bat_babip',
           'stats.bat_bb',
           'stats.bat_cs',
           'stats.bat_doubles',
           'stats.bat_errors',
           'stats.bat_gdp',
           'stats.bat_hbp',
           'stats.bat_hits',
           'stats.bat_hr',
           'stats.bat_iso',
           'stats.bat_k',
           'stats.bat_ops',
           'stats.bat_obp',
           'stats.bat_rbi',
           'stats.bat_runs',
           'stats.bat_sb',
           'stats.bat_sf',
           'stats.bat_slg',
           'stats.bat_triples',
           'stats.bat_war',
           'stats.bat_woba',
           'stats.bat_wraa',
           'stats.bat_wrc',
           'stats.bat_wsb',
           'stats.bat_xbh',

           'scouting_profiles.bat_hit_pres',
           'scouting_profiles.bat_hit_proj',
           'scouting_profiles.bat_game_pwr_pres',
           'scouting_profiles.bat_game_pwr_proj',
           'scouting_profiles.bat_raw_pwr_pres',
           'scouting_profiles.bat_raw_pwr_proj',
           'scouting_profiles.bat_pit_sel',
           'scouting_profiles.bat_bat_ctrl',
           'scouting_profiles.bat_hard_hit',
           'scouting_profiles.bat_spd_pres',
           'scouting_profiles.bat_spd_proj',
           'scouting_profiles.bat_fld_pres',
           'scouting_profiles.bat_fld_proj',

           'stats.pit_qs',
           'stats.pit_k_9',
           'stats.pit_era',
           'stats.pit_whip',
           'stats.pit_nr',

           'stats.pit_gs',
           'stats.pit_inn',
           'stats.pit_cg',
           'stats.pit_tbf',
           'stats.pit_qs',
           'stats.pit_wins',
           'stats.pit_losses',
           'stats.pit_ha',
           'stats.pit_whip',
           'stats.pit_era',
           'stats.pit_xera',
           'stats.pit_baa',
           'stats.pit_babip',
           'stats.pit_ks',
           'stats.pit_k_9',
           'stats.pit_k_pct',
           'stats.pit_k_bb_ratio',
           'stats.pit_k_bb_pct_diff',
           'stats.pit_bb_9',
           'stats.pit_bb_k',
           'stats.pit_bb_pct',
           'stats.pit_bb',
           'stats.pit_ibb',
           'stats.pit_fip',
           'stats.pit_xfip',
           'stats.pit_gb_pct',
           'stats.pit_hra',
           'stats.pit_hr_9',
           'stats.pit_lob_pct',
           'stats.pit_saves',
           'stats.pit_holds',
           'stats.pit_rw',
           'stats.pit_bs',
           'stats.pit_nr',
           'stats.pit_hit_bats',
           'stats.pit_balks',
           'stats.pit_wilds',

           'scouting_profiles.pit_control_pres',
           'scouting_profiles.pit_control_proj',
           'scouting_profiles.pit_command_pres',
           'scouting_profiles.pit_command_proj',
           'scouting_profiles.pit_fastball_pres',
           'scouting_profiles.pit_fastball_proj',
           'scouting_profiles.pit_fastball_type',
           'scouting_profiles.pit_curve_pres',
           'scouting_profiles.pit_curve_proj',
           'scouting_profiles.pit_slider_pres',
           'scouting_profiles.pit_slider_proj',
           'scouting_profiles.pit_sweeper_pres',
           'scouting_profiles.pit_sweeper_proj',
           'scouting_profiles.pit_changeup_pres',
           'scouting_profiles.pit_changeup_proj',
           'scouting_profiles.pit_cutter_pres',
           'scouting_profiles.pit_cutter_proj',
           'scouting_profiles.pit_arm_pres',
           'scouting_profiles.pit_arm_proj',

           'rosters.name AS roster_name',
           'rosters.abbreviation AS roster_abbreviation',
           'teams.name AS team_name',
           'teams.abbreviation AS team_abbreviation',
           'levels.abbreviation AS level_abbreviation',
           'levels.weight AS player_level_weight',
           'statuses.abbreviation AS status_abbreviation',
           'statuses.weight AS player_status_weight',
           'COALESCE(array_agg(tracking_list_players.tracking_list_id) FILTER (WHERE tracking_list_players.tracking_list_id IS NOT NULL), ARRAY[]::integer[]) AS aggregated_tracking_list_ids'
         ].join(', '))
         .includes(
           :team, :level, :status, :roster, :team
         )
         .joins('LEFT JOIN rosters ON rosters.id = players.roster_id')
         .joins('LEFT JOIN teams ON teams.id = players.team_id')
         .joins('LEFT JOIN levels ON levels.id = players.level_id')
         .joins('LEFT JOIN statuses ON statuses.id = players.status_id')
         .joins('LEFT JOIN stats ON stats.player_id = players.id AND stats.timeline_id = 1')
         .joins('LEFT JOIN scouting_profiles ON scouting_profiles.player_id = players.id AND scouting_profiles.timeline_id = 1')
         .joins('LEFT JOIN tracking_list_players ON tracking_list_players.player_id = players.id')
         .group([
           'players.id',
           'stats.id',
           'scouting_profiles.id',
           'rosters.id', 'rosters.name', 'rosters.abbreviation',
           'teams.id', 'teams.name', 'teams.abbreviation',
           'levels.id', 'levels.abbreviation', 'levels.weight',
           'statuses.id', 'statuses.abbreviation', 'statuses.weight'
         ].join(', '))
         .ransack(params[:q])

    @q.sorts = controller_class.default_sort if @q.sorts.empty?
    total = @q.result.unscope(:order, :group).count('distinct players.id')
    @pagy, @instances = pagy(@q.result, count: total)

    @levels = Level.all.select_order
    @statuses = Status.all.select_order
    @positions = Position.all.select_order
    @timelines = Timeline.all.select_order
    @tracking_lists = current_user.tracking_lists
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
    authorize(policy_class)

    @instance = controller_class.includes(:scouting_reports).find(params[:id])
    @scouting_reports = @instance.scouting_reports
  end

  def search
    authorize(Admin::PlayerPolicy)

    return render json: [] if params[:q].blank? || params[:q].length < 2

    @players = Player.includes(:team, :roster)
                     .where('first_name ILIKE ? OR last_name ILIKE ?',
                            "%#{params[:q]}%", "%#{params[:q]}%")
                     .order(last_name: :asc)
                     .limit(15)

    # Add this line for debugging
    Rails.logger.debug "Search query: #{params[:q]}, Found: #{@players.count} players"

    result = @players.map do |player|
      roster_name = player.roster&.abbreviation || 'FA'
      team_name = player.team&.abbreviation || ''
      positions = player.eligible_positions.present? ? player.eligible_positions.first : 'U'

      formatted_name = "#{player.last_name}, #{player.first_name} (#{positions}) #{team_name} / #{roster_name}"

      {
        id: player.id,
        formatted_name: formatted_name,
        profile_url: profile_admin_player_path(player)
      }
    end

    render json: result
  end

  private

  def create_params
    params.require(:player).permit(
      :age,
      :archived_at,
      :first__name,
      :last_name,
      :level_id,
      :middle_name,
      :name_suffix,
      :notes,
      :player_type,
      :position,
      :roster_id,
      :status_id,
      :team_id,
    )
  end

  def update_params
    params.require(:player).permit(
      :age,
      :archived_at,
      :first__name,
      :last_name,
      :level_id,
      :middle_name,
      :name_suffix,
      :notes,
      :player_type,
      :position,
      :roster_id,
      :status_id,
      :team_id,
    )
  end
end
