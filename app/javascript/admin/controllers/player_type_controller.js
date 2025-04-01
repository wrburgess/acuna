import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["typeLink", "nameFilter"]

  connect() {
    console.log("PlayerTypeController connected")
  }

  switchType(event) {
    event.preventDefault()
    const type = event.currentTarget.dataset.type
    const url = new URL(window.location.href)
    url.searchParams.set("player_type", type)
    window.location.href = url.toString()
  }

  filterByName(event) {
    const name = this.nameFilterTarget.value.trim()
    const url = new URL(window.location.href)
    if (name) {
      url.searchParams.set("q[last_name_cont]", name)
    } else {
      url.searchParams.delete("q[last_name_cont]")
    }
    window.location.href = url.toString()
  }

  handleNameFilterKeyup(event) {
    if (event.key === "Enter") {
      this.filterByName(event)
    }
  }
}
