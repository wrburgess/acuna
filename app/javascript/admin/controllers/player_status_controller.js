import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["statusLink"]

  switchStatus(event) {
    event.preventDefault()
    const statusId = event.currentTarget.dataset.statusId
    const url = new URL(window.location.href)

    if (statusId === "all") {
      url.searchParams.delete("q[status_id_eq]")
    } else {
      url.searchParams.set("q[status_id_eq]", statusId)
    }

    Turbo.visit(url.toString()) // Use Turbo for navigation
  }
}
