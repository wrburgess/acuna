import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["link"]

  connect() {
    this.activeView = this.getInitialView()
    this.updateActiveLink()
  }

  switchView(event) {
    event.preventDefault()
    const view = event.currentTarget.dataset.view
    this.activeView = view
    this.updateActiveLink()
    this.updateTableColumns(view)
  }

  getInitialView() {
    const urlParams = new URLSearchParams(window.location.search)
    return urlParams.get("view") || "stats" // Default to "stats" view
  }

  updateActiveLink() {
    this.linkTargets.forEach(link => {
      link.classList.toggle("active", link.dataset.view === this.activeView)
    })
  }

  updateTableColumns(view) {
    const url = new URL(window.location.href)
    url.searchParams.set("view", view)
    Turbo.visit(url.toString()) // Use Turbo to reload the page with the new view
  }
}
