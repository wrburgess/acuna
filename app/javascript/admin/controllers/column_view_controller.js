import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["link"]

  connect() {
    console.log("Column view controller connected")
    this.showRelevantColumns()
  }

  showRelevantColumns() {
    // Get current view from URL
    const url = new URL(window.location.href)
    const viewParam = url.searchParams.get('view') || 'stats' // Default to stats
    
    // Find all table columns with class stats, scoring, or scouting
    const statsCols = document.querySelectorAll('th.stats, td.stats')
    const scoringCols = document.querySelectorAll('th.scoring, td.scoring')
    const scoutingCols = document.querySelectorAll('th.scouting, td.scouting')
    
    // Hide all columns first
    this.hideElements(statsCols)
    this.hideElements(scoringCols)
    this.hideElements(scoutingCols)
    
    // Show appropriate columns based on view
    switch(viewParam) {
      case 'stats':
        this.showElements(statsCols)
        break
      case 'scoring':
        this.showElements(scoringCols)
        break
      case 'scouting':
        this.showElements(scoutingCols)
        break
      default:
        this.showElements(statsCols) // Default to stats view
    }
  }
  
  hideElements(elements) {
    elements.forEach(el => el.style.display = 'none')
  }
  
  showElements(elements) {
    elements.forEach(el => el.style.display = '')
  }
}
