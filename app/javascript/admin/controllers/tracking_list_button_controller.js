import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button"]
  static values = {
    playerId: Number,
    trackingListId: Number,
    isTracked: Boolean,
    iconOn: String,
    iconOff: String
  }

  connect() {
    // Initialize Bootstrap tooltips if they're being used
    if (typeof bootstrap !== 'undefined') {
      this.initTooltips()
    }
  }

  initTooltips() {
    const tooltipTriggerList = this.element.querySelectorAll('[data-bs-toggle="tooltip"]')
    tooltipTriggerList.forEach(tooltipTriggerEl => {
      new bootstrap.Tooltip(tooltipTriggerEl)
    })
  }

  async toggle(event) {
    event.preventDefault()
    
    // Determine the action based on current tracking status
    const action = this.isTrackedValue ? 'remove' : 'add'
    const url = `/admin/tracking_lists/${this.trackingListIdValue}/${action}_player`
    const method = 'POST'
    
    try {
      // Send request to server
      const response = await fetch(url, {
        method: method,
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': this.getCSRFToken()
        },
        body: JSON.stringify({ player_id: this.playerIdValue })
      })
      
      if (response.ok) {
        // Toggle the tracked status
        this.isTrackedValue = !this.isTrackedValue
        this.updateButtonAppearance()
      } else {
        console.error('Server responded with error:', await response.text())
      }
    } catch (error) {
      console.error('Error toggling tracking status:', error)
    }
  }
  
  updateButtonAppearance() {
    const iconElement = this.buttonTarget.querySelector('i')
    
    // Update icon class based on tracked status
    if (this.isTrackedValue) {
      iconElement.className = `bi ${this.iconOnValue} text-warning`
      this.buttonTarget.setAttribute('title', `Remove from tracking list`)
    } else {
      iconElement.className = `bi ${this.iconOffValue} text-muted`
      this.buttonTarget.setAttribute('title', `Add to tracking list`)
    }
    
    // Update tooltip if Bootstrap is available
    if (typeof bootstrap !== 'undefined') {
      const tooltip = bootstrap.Tooltip.getInstance(this.buttonTarget)
      if (tooltip) {
        tooltip.dispose()
        new bootstrap.Tooltip(this.buttonTarget)
      }
    }
  }
  
  getCSRFToken() {
    return document.querySelector('meta[name="csrf-token"]').getAttribute('content')
  }
}
