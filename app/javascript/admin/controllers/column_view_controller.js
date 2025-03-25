import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["statsButton", "scoringButton", "scoutingButton"]

  connect() {
    const view = new URLSearchParams(window.location.search).get('view') || 'stats'
    this[`show${view.charAt(0).toUpperCase() + view.slice(1)}`]()
  }

  showStats(event) {
    if (event) event.preventDefault()
    this.toggleActiveButton('stats')
    this.showColumns('stats')
    this.updateUrl('stats')
  }

  showScoring(event) {
    if (event) event.preventDefault()
    this.toggleActiveButton('scoring')
    this.showColumns('scoring')
    this.updateUrl('scoring')
  }

  showScouting(event) {
    if (event) event.preventDefault()
    this.toggleActiveButton('scouting')
    this.showColumns('scouting')
    this.updateUrl('scouting')
  }

  toggleActiveButton(activeView) {
    this.statsButtonTarget.classList.toggle('active', activeView === 'stats')
    this.scoringButtonTarget.classList.toggle('active', activeView === 'scoring')
    this.scoutingButtonTarget.classList.toggle('active', activeView === 'scouting')
  }

  showColumns(activeView) {
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

  updateUrl(view) {
    const url = new URL(window.location.href)
    const params = new URLSearchParams(url.search)
    params.set('view', view)
    
    // Preserve existing query parameters
    const newUrl = `${url.pathname}?${params.toString()}`
    window.history.pushState({}, '', newUrl)
  }
}
