import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.applyView()
  }

  applyView() {
    const view = new URLSearchParams(window.location.search).get("view") || "stats"
    const table = this.element.closest("table")

    if (!table) return

    // Always show "base" columns
    table.querySelectorAll("th.base, td.base").forEach((el) => {
      el.style.display = ""
    })

    // Hide all "stats", "scoring", and "scouting" columns by default
    table.querySelectorAll("th.stats, td.stats, th.scoring, td.scoring, th.scouting, td.scouting").forEach((el) => {
      el.style.display = "none"
    })

    // Show columns for the selected view
    table.querySelectorAll(`th.${view}, td.${view}`).forEach((el) => {
      el.style.display = ""
    })
  }
}
