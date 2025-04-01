import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["typeLink", "nameFilter"]

  connect() {
    console.log("PlayerTypeController connected")
    console.log("TypeLink targets:", this.typeLinkTargets)
    console.log("NameFilter target:", this.nameFilterTarget)
  }

  switchType(event) {
    event.preventDefault()
    const type = event.currentTarget.dataset.type
    const url = new URL(window.location.href)
    url.searchParams.set("player_type", type)
    console.log(`Switching player type to: ${type}`)
    Turbo.visit(url.toString()) // Use Turbo to handle navigation
  }

  filterByName(event) {
    if (event.key === "Enter") {
      const name = this.nameFilterTarget.value.trim()
      const url = new URL(window.location.href)
      if (name) {
        url.searchParams.set("q[last_name_cont]", name)
      } else {
        url.searchParams.delete("q[last_name_cont]")
      }
      console.log(`Filtering by name: ${name}, URL: ${url.toString()}`)
      Turbo.visit(url.toString()) // Use Turbo to handle navigation
    }
  }

  handleNameFilterKeyup(event) {
    console.log(`Key pressed: ${event.key}`) // Log the key pressed
    this.filterByName(event) // Trigger filtering
  }
}
