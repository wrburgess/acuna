import { application } from "../../controllers/application"

import TomSelectController from "./tom_select_controller"
application.register("tom-select", TomSelectController)

import FormValidationController from "./form_validation_controller"
application.register("form-validation", FormValidationController)

import TrackingListPlayerController from "./tracking_list_player_controller"
application.register("tracking-list-player", TrackingListPlayerController)

import PlayerSearchController from "./player_search_controller"
application.register("player-search", PlayerSearchController)

import PlayerTypeController from "./player_type_controller"
application.register("player-type", PlayerTypeController)

import PlayerLevelController from "./player_level_controller"
application.register("player-level", PlayerLevelController)

import PlayerRosterController from "./player_roster_controller"
application.register("player-roster", PlayerRosterController)

import PlayerStatusController from "./player_status_controller"
application.register("player-status", PlayerStatusController)

import TimelineController from "./timeline_controller"
application.register("timeline", TimelineController)

import ColumnViewController from "./column_view_controller"
application.register("column-view", ColumnViewController)
