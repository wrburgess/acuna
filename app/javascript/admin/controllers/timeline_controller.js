import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["timelineLink"]

  switchTimeline(event) {
    event.preventDefault()
    const timelineId = event.currentTarget.dataset.timelineId
    const url = new URL(window.location.href)

    if (timelineId === 1) {
      url.searchParams.delete("timeline_id")
    } else {
      url.searchParams.set("timeline_id", timelineId)
    }

    Turbo.visit(url.toString()) // Use Turbo for navigation
  }
}
