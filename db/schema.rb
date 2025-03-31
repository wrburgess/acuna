# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_03_31_013911) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_stat_statements"

  create_table "blazer_audits", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "query_id"
    t.text "statement"
    t.string "data_source"
    t.datetime "created_at"
    t.index ["query_id"], name: "index_blazer_audits_on_query_id"
    t.index ["user_id"], name: "index_blazer_audits_on_user_id"
  end

  create_table "blazer_checks", force: :cascade do |t|
    t.bigint "creator_id"
    t.bigint "query_id"
    t.string "state"
    t.string "schedule"
    t.text "emails"
    t.text "slack_channels"
    t.string "check_type"
    t.text "message"
    t.datetime "last_run_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_checks_on_creator_id"
    t.index ["query_id"], name: "index_blazer_checks_on_query_id"
  end

  create_table "blazer_dashboard_queries", force: :cascade do |t|
    t.bigint "dashboard_id"
    t.bigint "query_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dashboard_id"], name: "index_blazer_dashboard_queries_on_dashboard_id"
    t.index ["query_id"], name: "index_blazer_dashboard_queries_on_query_id"
  end

  create_table "blazer_dashboards", force: :cascade do |t|
    t.bigint "creator_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_dashboards_on_creator_id"
  end

  create_table "blazer_queries", force: :cascade do |t|
    t.bigint "creator_id"
    t.string "name"
    t.text "description"
    t.text "statement"
    t.string "data_source"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_queries_on_creator_id"
  end

  create_table "data_logs", force: :cascade do |t|
    t.string "loggable_type", null: false
    t.bigint "loggable_id", null: false
    t.bigint "user_id"
    t.string "operation"
    t.text "note"
    t.jsonb "meta"
    t.jsonb "original_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["loggable_type", "loggable_id"], name: "index_data_logs_on_loggable"
    t.index ["user_id"], name: "index_data_logs_on_user_id"
  end

  create_table "good_job_batches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.jsonb "serialized_properties"
    t.text "on_finish"
    t.text "on_success"
    t.text "on_discard"
    t.text "callback_queue_name"
    t.integer "callback_priority"
    t.datetime "enqueued_at"
    t.datetime "discarded_at"
    t.datetime "finished_at"
    t.datetime "jobs_finished_at"
  end

  create_table "good_job_executions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id", null: false
    t.text "job_class"
    t.text "queue_name"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "finished_at"
    t.text "error"
    t.integer "error_event", limit: 2
    t.text "error_backtrace", array: true
    t.uuid "process_id"
    t.interval "duration"
    t.index ["active_job_id", "created_at"], name: "index_good_job_executions_on_active_job_id_and_created_at"
    t.index ["process_id", "created_at"], name: "index_good_job_executions_on_process_id_and_created_at"
  end

  create_table "good_job_processes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "state"
    t.integer "lock_type", limit: 2
  end

  create_table "good_job_settings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "key"
    t.jsonb "value"
    t.index ["key"], name: "index_good_job_settings_on_key", unique: true
  end

  create_table "good_jobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "queue_name"
    t.integer "priority"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "performed_at"
    t.datetime "finished_at"
    t.text "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id"
    t.text "concurrency_key"
    t.text "cron_key"
    t.uuid "retried_good_job_id"
    t.datetime "cron_at"
    t.uuid "batch_id"
    t.uuid "batch_callback_id"
    t.boolean "is_discrete"
    t.integer "executions_count"
    t.text "job_class"
    t.integer "error_event", limit: 2
    t.text "labels", array: true
    t.uuid "locked_by_id"
    t.datetime "locked_at"
    t.index ["active_job_id", "created_at"], name: "index_good_jobs_on_active_job_id_and_created_at"
    t.index ["batch_callback_id"], name: "index_good_jobs_on_batch_callback_id", where: "(batch_callback_id IS NOT NULL)"
    t.index ["batch_id"], name: "index_good_jobs_on_batch_id", where: "(batch_id IS NOT NULL)"
    t.index ["concurrency_key", "created_at"], name: "index_good_jobs_on_concurrency_key_and_created_at"
    t.index ["concurrency_key"], name: "index_good_jobs_on_concurrency_key_when_unfinished", where: "(finished_at IS NULL)"
    t.index ["cron_key", "created_at"], name: "index_good_jobs_on_cron_key_and_created_at_cond", where: "(cron_key IS NOT NULL)"
    t.index ["cron_key", "cron_at"], name: "index_good_jobs_on_cron_key_and_cron_at_cond", unique: true, where: "(cron_key IS NOT NULL)"
    t.index ["finished_at"], name: "index_good_jobs_jobs_on_finished_at", where: "((retried_good_job_id IS NULL) AND (finished_at IS NOT NULL))"
    t.index ["labels"], name: "index_good_jobs_on_labels", where: "(labels IS NOT NULL)", using: :gin
    t.index ["locked_by_id"], name: "index_good_jobs_on_locked_by_id", where: "(locked_by_id IS NOT NULL)"
    t.index ["priority", "created_at"], name: "index_good_job_jobs_for_candidate_lookup", where: "(finished_at IS NULL)"
    t.index ["priority", "created_at"], name: "index_good_jobs_jobs_on_priority_created_at_when_unfinished", order: { priority: "DESC NULLS LAST" }, where: "(finished_at IS NULL)"
    t.index ["priority", "scheduled_at"], name: "index_good_jobs_on_priority_scheduled_at_unfinished_unlocked", where: "((finished_at IS NULL) AND (locked_by_id IS NULL))"
    t.index ["queue_name", "scheduled_at"], name: "index_good_jobs_on_queue_name_and_scheduled_at", where: "(finished_at IS NULL)"
    t.index ["scheduled_at"], name: "index_good_jobs_on_scheduled_at", where: "(finished_at IS NULL)"
  end

  create_table "levels", force: :cascade do |t|
    t.string "name", null: false
    t.string "abbreviation"
    t.integer "weight"
    t.text "notes"
    t.date "archived_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "links", force: :cascade do |t|
    t.string "url_type"
    t.string "url"
    t.string "secure_code"
    t.string "video_type"
    t.text "notes"
    t.datetime "archived_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "maintenance_tasks_runs", force: :cascade do |t|
    t.string "task_name", null: false
    t.datetime "started_at", precision: nil
    t.datetime "ended_at", precision: nil
    t.float "time_running", default: 0.0, null: false
    t.bigint "tick_count", default: 0, null: false
    t.bigint "tick_total"
    t.string "job_id"
    t.string "cursor"
    t.string "status", default: "enqueued", null: false
    t.string "error_class"
    t.string "error_message"
    t.text "backtrace"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "arguments"
    t.integer "lock_version", default: 0, null: false
    t.text "metadata"
    t.index ["task_name", "status", "created_at"], name: "index_maintenance_tasks_runs", order: { created_at: :desc }
  end

  create_table "pghero_query_stats", force: :cascade do |t|
    t.text "database"
    t.text "user"
    t.text "query"
    t.bigint "query_hash"
    t.float "total_time"
    t.bigint "calls"
    t.datetime "captured_at", precision: nil
    t.index ["database", "captured_at"], name: "index_pghero_query_stats_on_database_and_captured_at"
  end

  create_table "players", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "position"
    t.date "birthdate"
    t.bigint "roster_id"
    t.bigint "team_id"
    t.text "notes"
    t.datetime "archived_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "fg_id"
    t.decimal "age", precision: 10, scale: 3
    t.string "height"
    t.string "weight"
    t.string "bats"
    t.string "throws"
    t.string "eligible_positions", default: [], array: true
    t.bigint "level_id"
    t.bigint "status_id"
    t.string "middle_name"
    t.text "name_suffix"
    t.string "player_type"
    t.index ["level_id"], name: "index_players_on_level_id"
    t.index ["roster_id"], name: "index_players_on_roster_id"
    t.index ["status_id"], name: "index_players_on_status_id"
    t.index ["team_id"], name: "index_players_on_team_id"
  end

  create_table "positions", force: :cascade do |t|
    t.string "name", null: false
    t.string "abbreviation"
    t.string "position_type"
    t.string "alternate_names", default: [], array: true
    t.string "collective_values", default: [], array: true
    t.integer "weight"
    t.text "notes"
    t.datetime "archived_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "player_type"
    t.index ["abbreviation"], name: "index_positions_on_abbreviation"
    t.index ["archived_at"], name: "index_positions_on_archived_at"
    t.index ["name"], name: "index_positions_on_name"
  end

  create_table "reports", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.text "sql", null: false
    t.text "notes"
    t.datetime "archived_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rosters", force: :cascade do |t|
    t.string "name"
    t.string "abbreviation"
    t.text "notes"
    t.datetime "archived_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scouting_profile_reports", force: :cascade do |t|
    t.bigint "scouting_profile_id", null: false
    t.bigint "scouting_report_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["scouting_profile_id", "scouting_report_id"], name: "index_scouting_profile_reports_unique", unique: true
    t.index ["scouting_profile_id"], name: "index_scouting_profile_reports_on_scouting_profile_id"
    t.index ["scouting_report_id"], name: "index_scouting_profile_reports_on_scouting_report_id"
  end

  create_table "scouting_profiles", force: :cascade do |t|
    t.bigint "player_id"
    t.bigint "timeline_id"
    t.string "risk"
    t.string "eta"
    t.text "note"
    t.decimal "espn_overall_rank", precision: 10, scale: 3
    t.decimal "ath_overall_rank", precision: 10, scale: 3
    t.decimal "ba_overall_rank", precision: 10, scale: 3
    t.decimal "pl_overall_rank", precision: 10, scale: 3
    t.decimal "cbs_overall_rank", precision: 10, scale: 3
    t.decimal "fg_overall_rank", precision: 10, scale: 3
    t.decimal "self_overall_rank", precision: 10, scale: 3
    t.decimal "espn_team_rank", precision: 10, scale: 3
    t.decimal "ath_team_rank", precision: 10, scale: 3
    t.decimal "ba_team_rank", precision: 10, scale: 3
    t.decimal "pl_team_rank", precision: 10, scale: 3
    t.decimal "cbs_team_rank", precision: 10, scale: 3
    t.decimal "fg_team_rank", precision: 10, scale: 3
    t.decimal "self_team_rank", precision: 10, scale: 3
    t.decimal "espn_future_value", precision: 10, scale: 3
    t.decimal "ath_future_value", precision: 10, scale: 3
    t.decimal "ba_future_value", precision: 10, scale: 3
    t.decimal "pl_future_value", precision: 10, scale: 3
    t.decimal "cbs_future_value", precision: 10, scale: 3
    t.decimal "fg_future_value", precision: 10, scale: 3
    t.decimal "self_future_value", precision: 10, scale: 3
    t.decimal "bat_hit_pres", precision: 10, scale: 3
    t.decimal "bat_hit_proj", precision: 10, scale: 3
    t.decimal "bat_game_pwr_pres", precision: 10, scale: 3
    t.decimal "bat_game_pwr_proj", precision: 10, scale: 3
    t.decimal "bat_raw_pwr_pres", precision: 10, scale: 3
    t.decimal "bat_raw_pwr_proj", precision: 10, scale: 3
    t.decimal "bat_pit_sel", precision: 10, scale: 3
    t.decimal "bat_bat_ctrl", precision: 10, scale: 3
    t.decimal "bat_hard_hit", precision: 10, scale: 3
    t.decimal "bat_spd_pres", precision: 10, scale: 3
    t.decimal "bat_spd_proj", precision: 10, scale: 3
    t.decimal "bat_fld_pres", precision: 10, scale: 3
    t.decimal "bat_fld_proj", precision: 10, scale: 3
    t.decimal "pit_control_pres", precision: 10, scale: 3
    t.decimal "pit_control_proj", precision: 10, scale: 3
    t.decimal "pit_command_pres", precision: 10, scale: 3
    t.decimal "pit_command_proj", precision: 10, scale: 3
    t.decimal "pit_fastball_pres", precision: 10, scale: 3
    t.decimal "pit_fastball_proj", precision: 10, scale: 3
    t.decimal "pit_fastball_type", precision: 10, scale: 3
    t.decimal "pit_curve_pres", precision: 10, scale: 3
    t.decimal "pit_curve_proj", precision: 10, scale: 3
    t.decimal "pit_slider_pres", precision: 10, scale: 3
    t.decimal "pit_slider_proj", precision: 10, scale: 3
    t.decimal "pit_sweeper_pres", precision: 10, scale: 3
    t.decimal "pit_sweeper_proj", precision: 10, scale: 3
    t.decimal "pit_changeup_pres", precision: 10, scale: 3
    t.decimal "pit_changeup_proj", precision: 10, scale: 3
    t.decimal "pit_cutter_pres", precision: 10, scale: 3
    t.decimal "pit_cutter_proj", precision: 10, scale: 3
    t.decimal "pit_arm_pres", precision: 10, scale: 3
    t.decimal "pit_arm_proj", precision: 10, scale: 3
    t.datetime "recorded_at"
    t.datetime "archived_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_scouting_profiles_on_player_id"
    t.index ["timeline_id"], name: "index_scouting_profiles_on_timeline_id"
  end

  create_table "scouting_reports", force: :cascade do |t|
    t.bigint "scout_id", null: false
    t.bigint "player_id", null: false
    t.date "reported_at", null: false
    t.text "body"
    t.integer "overall_ranking"
    t.integer "team_ranking"
    t.decimal "future_value", precision: 10, scale: 3
    t.decimal "hit_pres", precision: 10, scale: 3
    t.decimal "hit_proj", precision: 10, scale: 3
    t.decimal "pit_sel", precision: 10, scale: 3
    t.decimal "bat_ctrl", precision: 10, scale: 3
    t.decimal "spd_pres", precision: 10, scale: 3
    t.decimal "spd_proj", precision: 10, scale: 3
    t.decimal "fld_pres", precision: 10, scale: 3
    t.decimal "fld_proj", precision: 10, scale: 3
    t.decimal "hard_hit", precision: 10, scale: 3
    t.date "archived_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "game_pwr_pres", precision: 10, scale: 3
    t.decimal "game_pwr_proj", precision: 10, scale: 3
    t.decimal "raw_pwr_pres", precision: 10, scale: 3
    t.decimal "raw_pwr_proj", precision: 10, scale: 3
    t.string "risk"
    t.string "eta"
    t.string "timeline_type"
    t.decimal "fastball_proj", precision: 10, scale: 3
    t.decimal "sweeper_proj", precision: 10, scale: 3
    t.decimal "changeup_proj", precision: 10, scale: 3
    t.decimal "cutter_proj", precision: 10, scale: 3
    t.decimal "control_proj", precision: 10, scale: 3
    t.decimal "arm_proj", precision: 10, scale: 3
    t.decimal "slider_pres", precision: 10, scale: 3
    t.decimal "slider_proj", precision: 10, scale: 3
    t.decimal "curve_pres", precision: 10, scale: 3
    t.decimal "curve_proj", precision: 10, scale: 3
    t.decimal "command_pres", precision: 10, scale: 3
    t.decimal "command_proj", precision: 10, scale: 3
    t.decimal "fastball_type", precision: 10, scale: 3
    t.datetime "tj_at"
    t.string "video_url"
    t.decimal "fastball_pres", precision: 10, scale: 3
    t.decimal "sweeper_pres", precision: 10, scale: 3
    t.decimal "changeup_pres", precision: 10, scale: 3
    t.decimal "cutter_pres", precision: 10, scale: 3
    t.decimal "control_pres", precision: 10, scale: 3
    t.decimal "arm_pres", precision: 10, scale: 3
    t.bigint "timeline_id"
    t.index ["player_id"], name: "index_scouting_reports_on_player_id"
    t.index ["scout_id"], name: "index_scouting_reports_on_scout_id"
    t.index ["timeline_id"], name: "index_scouting_reports_on_timeline_id"
  end

  create_table "scouts", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "company"
    t.date "archived_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["first_name", "last_name"], name: "index_scouts_on_first_name_and_last_name"
  end

  create_table "stats", force: :cascade do |t|
    t.bigint "player_id"
    t.bigint "team_id"
    t.bigint "opponent_id"
    t.bigint "timeline_id"
    t.string "mlbam_id"
    t.string "game_number"
    t.datetime "game_date"
    t.string "game_location"
    t.string "game_result"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.text "notes"
    t.decimal "bat_ab", precision: 10, scale: 3, comment: "batting - total at bats"
    t.decimal "bat_avg", precision: 10, scale: 3, comment: "batting - batting average"
    t.decimal "bat_babip", precision: 10, scale: 3, comment: "batting - batting average on balls in play"
    t.decimal "bat_bb", precision: 10, scale: 3, comment: "batting - total base on balls (walks)"
    t.decimal "bat_cs", precision: 10, scale: 3, comment: "batting - total caught stealings"
    t.decimal "bat_doubles", precision: 10, scale: 3, comment: "batting - total doubles"
    t.decimal "bat_errors", precision: 10, scale: 3, comment: "batting - total errors"
    t.decimal "bat_gdp", precision: 10, scale: 3, comment: "batting - total ground into double plays"
    t.decimal "bat_hbp", precision: 10, scale: 3, comment: "batting - total hits by pitches"
    t.decimal "bat_hits", precision: 10, scale: 3, comment: "batting - total_hits"
    t.decimal "bat_hr", precision: 10, scale: 3, comment: "batting - total home runs"
    t.decimal "bat_iso", precision: 10, scale: 3, comment: "batting - isolated power"
    t.decimal "bat_k", precision: 10, scale: 3, comment: "batting - total strikeouts"
    t.decimal "bat_nsb", precision: 10, scale: 3, comment: "batting - net stolen bases (sb - cs)"
    t.decimal "bat_obp", precision: 10, scale: 3, comment: "batting - on base percentage"
    t.decimal "bat_ops", precision: 10, scale: 3, comment: "batting - on-base plus slugging percentage"
    t.decimal "bat_pa", precision: 10, scale: 3, comment: "batting - total plate appearances"
    t.decimal "bat_rbi", precision: 10, scale: 3, comment: "batting - total runs batted in"
    t.decimal "bat_runs", precision: 10, scale: 3, comment: "batting - total runs"
    t.decimal "bat_sb", precision: 10, scale: 3, comment: "batting - total stolen bases"
    t.decimal "bat_sf", precision: 10, scale: 3, comment: "batting - total sacrifice flies"
    t.decimal "bat_slg", precision: 10, scale: 3, comment: "batting - slugging percentage"
    t.decimal "bat_triples", precision: 10, scale: 3, comment: "batting - total triples"
    t.decimal "bat_war", precision: 10, scale: 3, comment: "batting - weighted runs created plus (wRC+)"
    t.decimal "bat_woba", precision: 10, scale: 3, comment: "batting - weighted on-base average (wOBA)"
    t.decimal "bat_wraa", precision: 10, scale: 3, comment: "batting - weighted runs above average (wRAA)"
    t.decimal "bat_wrc", precision: 10, scale: 3, comment: "batting - weighted runs created (wRC)"
    t.decimal "bat_wrc_plus", precision: 10, scale: 3, comment: "batting - weighted runs created plus (wRC+)"
    t.decimal "bat_wsb", precision: 10, scale: 3, comment: "batting - weighted stolen base runs (wSB)"
    t.decimal "bat_xbh", precision: 10, scale: 3, comment: "batting - extra base hits"
    t.decimal "pit_k_bb_pct_diff", precision: 10, scale: 3, comment: "pitching - diff between k pct and bb pct (K-BB%)"
    t.decimal "pit_k_bb_ratio", precision: 10, scale: 3, comment: "pitching - k to bb ratio (K/BB)"
    t.decimal "pit_baa", precision: 10, scale: 3, comment: "pitching - batting average against"
    t.decimal "pit_babip", precision: 10, scale: 3, comment: "pitching - batting average balls in play against"
    t.decimal "pit_balks", precision: 10, scale: 3, comment: "pitching - total balks"
    t.decimal "pit_bb", precision: 10, scale: 3, comment: "pitching - total base on balls"
    t.decimal "pit_bb_9", precision: 10, scale: 3, comment: "pitching - walks per nine innings"
    t.decimal "pit_bb_k", precision: 10, scale: 3, comment: "pitching - walk and strikeout ratio"
    t.decimal "pit_bb_pct", precision: 10, scale: 3, comment: "pitching - base on ball percentage"
    t.decimal "pit_bs", precision: 10, scale: 3, comment: "pitching - total blown saves"
    t.decimal "pit_cg", precision: 10, scale: 3, comment: "pitching - total complete games pitched"
    t.decimal "pit_era", precision: 10, scale: 3, comment: "pitching - earned run average"
    t.decimal "pit_fip", precision: 10, scale: 3, comment: "pitching - fielder independent pitching"
    t.decimal "pit_gb_pct", precision: 10, scale: 3, comment: "pitching - ground ball percentage"
    t.decimal "pit_gs", precision: 10, scale: 3, comment: "pitching - total games started"
    t.decimal "pit_ha", precision: 10, scale: 3, comment: "pitching - total hits against"
    t.decimal "pit_hit_bats", precision: 10, scale: 3, comment: "pitching - total hit batters"
    t.decimal "pit_holds", precision: 10, scale: 3, comment: "pitching - total holds"
    t.decimal "pit_hr_9", precision: 10, scale: 3, comment: "pitching - home runs per nine innings"
    t.decimal "pit_hra", precision: 10, scale: 3, comment: "pitching - total home runs against"
    t.decimal "pit_ibb", precision: 10, scale: 3, comment: "pitching - intentional base on balls allowed"
    t.decimal "pit_inn", precision: 10, scale: 3, comment: "pitching - total innings pitched"
    t.decimal "pit_k_9", precision: 10, scale: 3, comment: "pitching - strikeouts per nine innings"
    t.decimal "pit_k_pct", precision: 10, scale: 3, comment: "pitching - strikeout percentage"
    t.decimal "pit_ks", precision: 10, scale: 3, comment: "pitching - total strikeouts"
    t.decimal "pit_lob_pct", precision: 10, scale: 3, comment: "pitching - left on base percentage"
    t.decimal "pit_losses", precision: 10, scale: 3, comment: "pitching - total losses"
    t.decimal "pit_nr", precision: 10, scale: 3, comment: "pitching - net reliefs (saves + holds + relief wins - blown saves)"
    t.decimal "pit_qs", precision: 10, scale: 3, comment: "pitching - total quality starts"
    t.decimal "pit_rw", precision: 10, scale: 3, comment: "pitching - total relief wins"
    t.decimal "pit_saves", precision: 10, scale: 3, comment: "pitching - total saves"
    t.decimal "pit_tbf", precision: 10, scale: 3, comment: "pitching - total batters faced"
    t.decimal "pit_whip", precision: 10, scale: 3, comment: "pitching - walks and hits per inning pitched"
    t.decimal "pit_wilds", precision: 10, scale: 3, comment: "pitching - total wild pitches"
    t.decimal "pit_wins", precision: 10, scale: 3, comment: "pitching - total wins"
    t.decimal "pit_xera", precision: 10, scale: 3, comment: "pitching - expected earned run average"
    t.decimal "pit_xfip", precision: 10, scale: 3, comment: "pitching - expected fielder independent pitching (HRs are 10.5% of Fly Balls induced)"
    t.datetime "recorded_at"
    t.datetime "archived_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["opponent_id"], name: "index_stats_on_opponent_id"
    t.index ["player_id"], name: "index_stats_on_player_id"
    t.index ["team_id"], name: "index_stats_on_team_id"
    t.index ["timeline_id"], name: "index_stats_on_timeline_id"
  end

  create_table "statuses", force: :cascade do |t|
    t.string "name", null: false
    t.string "abbreviation"
    t.integer "weight"
    t.text "notes"
    t.date "archived_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "system_group_system_roles", force: :cascade do |t|
    t.bigint "system_group_id"
    t.bigint "system_role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["system_group_id"], name: "index_system_group_system_roles_on_system_group_id"
    t.index ["system_role_id"], name: "index_system_group_system_roles_on_system_role_id"
  end

  create_table "system_group_users", force: :cascade do |t|
    t.bigint "system_group_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["system_group_id"], name: "index_system_group_users_on_system_group_id"
    t.index ["user_id"], name: "index_system_group_users_on_user_id"
  end

  create_table "system_groups", force: :cascade do |t|
    t.string "name"
    t.string "abbreviation"
    t.string "description"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "system_permissions", force: :cascade do |t|
    t.string "name"
    t.string "abbreviation"
    t.string "resource"
    t.string "operation"
    t.string "description"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "system_role_system_permissions", force: :cascade do |t|
    t.bigint "system_role_id"
    t.bigint "system_permission_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["system_permission_id"], name: "index_system_role_system_permissions_on_system_permission_id"
    t.index ["system_role_id"], name: "index_system_role_system_permissions_on_system_role_id"
  end

  create_table "system_roles", force: :cascade do |t|
    t.string "name"
    t.string "abbreviation"
    t.string "description"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.string "abbreviation"
    t.text "notes"
    t.datetime "archived_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "timelines", force: :cascade do |t|
    t.string "name", null: false
    t.string "abbreviation"
    t.integer "weight"
    t.boolean "default"
    t.text "notes"
    t.datetime "archived_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["abbreviation"], name: "index_timelines_on_abbreviation"
    t.index ["archived_at"], name: "index_timelines_on_archived_at"
    t.index ["name"], name: "index_timelines_on_name"
  end

  create_table "tracking_list_players", force: :cascade do |t|
    t.bigint "tracking_list_id", null: false
    t.bigint "player_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_tracking_list_players_on_player_id"
    t.index ["tracking_list_id", "player_id"], name: "index_tracking_list_players_on_tracking_list_id_and_player_id", unique: true
    t.index ["tracking_list_id"], name: "index_tracking_list_players_on_tracking_list_id"
  end

  create_table "tracking_lists", force: :cascade do |t|
    t.string "name", null: false
    t.text "notes"
    t.bigint "user_id", null: false
    t.date "archived_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "icon_name_on"
    t.string "icon_name_off"
    t.index ["user_id"], name: "index_tracking_lists_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "first_name"
    t.string "last_name"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived_at"
    t.string "middle_name"
    t.string "title"
    t.string "phone_number"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "players", "levels"
  add_foreign_key "players", "rosters"
  add_foreign_key "players", "statuses"
  add_foreign_key "players", "teams"
  add_foreign_key "scouting_profile_reports", "scouting_reports"
  add_foreign_key "scouting_profiles", "players"
  add_foreign_key "scouting_profiles", "timelines"
  add_foreign_key "scouting_reports", "players"
  add_foreign_key "scouting_reports", "scouts"
  add_foreign_key "scouting_reports", "timelines"
  add_foreign_key "stats", "players"
  add_foreign_key "stats", "teams"
  add_foreign_key "stats", "teams", column: "opponent_id"
  add_foreign_key "stats", "timelines"
  add_foreign_key "tracking_list_players", "players"
  add_foreign_key "tracking_list_players", "tracking_lists"
  add_foreign_key "tracking_lists", "users"
end
