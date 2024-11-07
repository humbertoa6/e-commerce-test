// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import AutohideController from "./autohide_controller"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
application.register("autohide", AutohideController)
eagerLoadControllersFrom("controllers", application)
