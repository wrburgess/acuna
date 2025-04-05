import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["rosterLink"]

  switchRoster(event) {
    event.preventDefault()
    const rosterId = event.currentTarget.dataset.rosterId
    const url = new URL(window.location.href)

    if (rosterId === "all") {
      url.searchParams.delete("q[roster_id_eq]")
    } else {
      url.searchParams.set("q[roster_id_eq]", rosterId)
    }

    Turbo.visit(url.toString()) // Use Turbo for navigation
  }
}
