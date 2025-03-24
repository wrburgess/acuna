import { application } from "../../controllers/application"

// console.log("Admin JavaScript bundle loaded")

import TomSelectController from "./tom_select_controller"
application.register("tom-select", TomSelectController)

import FormValidationController from "./form_validation_controller"
application.register("form-validation", FormValidationController)

import ColumnViewController from "./column_view_controller"
application.register("column-view", ColumnViewController)

import TrackingListButtonController from "./tracking_list_button_controller"
application.register("tracking-list-button", TrackingListButtonController)
