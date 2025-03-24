import { application } from "../../controllers/application"

// console.log("Admin JavaScript bundle loaded")

import TomSelectController from "./tom_select_controller"
application.register("tom-select", TomSelectController)

import FormValidationController from "./form_validation_controller"
application.register("form-validation", FormValidationController)

import ColumnViewController from "./column_view_controller"
application.register("column-view", ColumnViewController)

import FilterNavigationController from "./filter_navigation_controller"
application.register("filter-navigation", FilterNavigationController)
