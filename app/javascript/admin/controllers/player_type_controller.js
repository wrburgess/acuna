import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["batterTable", "pitcherTable", "nameFilter"]
  static values = {
    type: { type: String, default: "batter" }
  }

  connect() {
    // Set initial state based on URL parameter or default to "batter"
    const urlParams = new URLSearchParams(window.location.search)
    const playerType = urlParams.get("player_type") || "batter"
    this.typeValue = playerType
    this.updateTables()
  }

  switchType(event) {
    event.preventDefault()
    const clickedType = event.currentTarget.dataset.type
    
    // Don't do anything if clicking the already active type
    if (clickedType === this.typeValue) return
    
    // Update type value
    this.typeValue = clickedType
    
    // Instead of just updating URL and tables, we'll do a full page reload
    // to make sure all the filter links are regenerated with the correct player_type
    const url = new URL(window.location)
    url.searchParams.set("player_type", clickedType)
    
    // Navigate to the new URL instead of using pushState
    window.location.href = url.toString()
  }
  
  updateTables() {
    if (this.typeValue === "batter") {
      this.batterTableTarget.classList.remove("d-none")
      this.pitcherTableTarget.classList.add("d-none")
    } else {
      this.batterTableTarget.classList.add("d-none")
      this.pitcherTableTarget.classList.remove("d-none")
    }
  }
  
  updateActiveLink() {
    // Find all type links and update active state
    const typeLinks = document.querySelectorAll("[data-player-type-target='typeLink']")
    typeLinks.forEach(link => {
      if (link.dataset.type === this.typeValue) {
        link.classList.add("active")
      } else {
        link.classList.remove("active")
      }
    })
  }

  // Filter table by name input
  filterByName() {
    const filterValue = this.nameFilterTarget.value.toLowerCase().trim()
    
    // Get the relevant table based on current player type
    const tableTarget = this.typeValue === "batter" ? this.batterTableTarget : this.pitcherTableTarget
    const rows = tableTarget.querySelectorAll("tbody tr")
    
    rows.forEach(row => {
      const playerNameCell = row.querySelector("td:nth-child(2)")
      if (playerNameCell) {
        const playerName = playerNameCell.textContent.toLowerCase()
        if (playerName.includes(filterValue)) {
          row.classList.remove("d-none")
        } else {
          row.classList.add("d-none")
        }
      }
    })
  }
  
  // Handle Enter key to apply server-side filtering
  handleNameFilterKeyup(event) {
    if (event.key === "Enter") {
      this.applyServerSideFilter()
    }
  }
  
  // Apply server-side filtering for more complex searches
  applyServerSideFilter() {
    const filterValue = this.nameFilterTarget.value.trim()
    if (filterValue === "") return
    
    const url = new URL(window.location)
    
    // Parse existing query parameters
    const searchParams = new URLSearchParams(url.search)
    const qParams = {}
    
    // Collect existing q parameters
    for (const [key, value] of searchParams.entries()) {
      if (key.startsWith("q[")) {
        const paramName = key.match(/q\[(.*?)\]/)[1]
        qParams[paramName] = value
      }
    }
    
    // Add or update the last_name_cont parameter
    qParams["last_name_cont"] = filterValue
    
    // Clear existing q parameters
    for (const key of [...searchParams.keys()]) {
      if (key.startsWith("q[")) {
        searchParams.delete(key)
      }
    }
    
    // Add updated q parameters
    for (const [key, value] of Object.entries(qParams)) {
      searchParams.set(`q[${key}]`, value)
    }
    
    // Preserve player_type and other non-q parameters
    url.search = searchParams.toString()
    
    // Navigate to the filtered URL
    window.location.href = url.toString()
  }
}
