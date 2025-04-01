import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["filter"]

  connect() {
    console.log("Filter controller connected")
  }

  applyFilter(event) {
    event.preventDefault()
    const filterType = event.target.dataset.filterType
    const filterValue = event.target.dataset.filterValue
    const url = new URL(window.location.href)

    if (filterValue === "all" || filterValue === "none") {
      url.searchParams.delete(filterType)
    } else {
      url.searchParams.set(filterType, filterValue)
    }

    window.location.href = url.toString()
  }

  handleNameFilterKeyup(event) {
    if (event.key === "Enter") {
      this.filterByName(event)
    }
  }

  filterByName(event) {
    event.preventDefault()
    const input = event.target.value.trim()
    const url = new URL(window.location.href)

    if (input === "") {
      url.searchParams.delete("q[last_name_cont]")
    } else {
      url.searchParams.set("q[last_name_cont]", input)
    }

    window.location.href = url.toString()
  }
}
