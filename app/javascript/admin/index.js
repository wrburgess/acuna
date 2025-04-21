import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"

// Initialize Stimulus for admin
const application = Application.start()

// Enable debug mode in development
application.debug = true

window.Stimulus = application

// Import Bootstrap JS
import "bootstrap"

// Log that admin JS is loaded
// console.log("Admin JavaScript bundle loaded")
