import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["statsButton", "scoringButton", "scoutingButton"]

  connect() {
    // Show stats view by default
    this.showStats()
  }

  showStats(event) {
    if (event) event.preventDefault()
    this.toggleActiveButton('stats')
    this.showColumns('stats')
  }

  showScoring(event) {
    if (event) event.preventDefault()
    this.toggleActiveButton('scoring')
    this.showColumns('scoring')
  }

  showScouting(event) {
    if (event) event.preventDefault()
    this.toggleActiveButton('scouting')
    this.showColumns('scouting')
  }

  toggleActiveButton(activeView) {
    this.statsButtonTarget.classList.toggle('active', activeView === 'stats')
    this.scoringButtonTarget.classList.toggle('active', activeView === 'scoring')
    this.scoutingButtonTarget.classList.toggle('active', activeView === 'scouting')
  }

  showColumns(activeView) {
    // Always show base columns
    const allColumnElements = document.querySelectorAll('[data-column-view-category]')
    
    // First hide all non-base columns
    allColumnElements.forEach(element => {
      const categories = element.dataset.columnViewCategory.split(' ')
      
      if (!categories.includes('base')) {
        element.style.display = 'none'
      } else {
        element.style.display = ''
      }
    })
    
    // Then show columns for the active view
    allColumnElements.forEach(element => {
      const categories = element.dataset.columnViewCategory.split(' ')
      
      if (categories.includes(activeView)) {
        element.style.display = ''
      }
    })
  }
}
