import { application } from "../../controllers/application"

import TomSelectController from "./tom_select_controller"
application.register("tom-select", TomSelectController)

import FormValidationController from "./form_validation_controller"
application.register("form-validation", FormValidationController)

import TrackingListPlayerController from "./tracking_list_player_controller"
application.register("tracking-list-player", TrackingListPlayerController)

import PlayerSearchController from "./player_search_controller"
application.register("player-search", PlayerSearchController)

import ColumnViewController from "./column_view_controller"
application.register("column-view", ColumnViewController)

import PlayerTypeController from "./player_type_controller"
application.register("player-type", PlayerTypeController)
