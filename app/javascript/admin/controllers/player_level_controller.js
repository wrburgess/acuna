import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["levelLink"]

  switchLevel(event) {
    event.preventDefault()
    const levelId = event.currentTarget.dataset.levelId
    const url = new URL(window.location.href)

    if (levelId === "all") {
      url.searchParams.delete("q[level_id_eq]")
    } else {
      url.searchParams.set("q[level_id_eq]", levelId)
    }

    Turbo.visit(url.toString()) // Use Turbo for navigation
  }
}
