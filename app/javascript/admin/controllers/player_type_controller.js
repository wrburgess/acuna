import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["typeLink", "nameFilter"]

  connect() {
    console.log("Player type controller connected")
  }

  switchType(event) {
    event.preventDefault()
    const type = event.currentTarget.dataset.type
    
    // Get current URL and params
    const url = new URL(window.location.href)
    
    // Update player_type parameter
    url.searchParams.set('player_type', type)
    
    // Navigate to new URL
    window.location.href = url.toString()
  }

  filterByName() {
    // Debounce to avoid too many requests
    clearTimeout(this.debounceTimer)
    this.debounceTimer = setTimeout(() => {
      this.applyNameFilter()
    }, 300)
  }

  handleNameFilterKeyup(event) {
    // Handle Enter key press
    if (event.key === "Enter") {
      event.preventDefault()
      this.applyNameFilter()
    }
  }

  applyNameFilter() {
    const nameValue = this.nameFilterTarget.value
    
    // Get current URL and params
    const url = new URL(window.location.href)
    const params = url.searchParams
    
    // Create or update the q[last_name_cont] parameter
    if (nameValue) {
      params.set('q[last_name_cont]', nameValue)
    } else {
      // Remove the name filter if empty
      params.delete('q[last_name_cont]')
    }
    
    // Navigate to filtered URL
    window.location.href = url.toString()
  }
}
