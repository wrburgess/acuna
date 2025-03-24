import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button"]
  static values = {
    playerId: Number,
    trackingListId: Number,
    tracked: Boolean
  }

  toggle(event) {
    event.preventDefault()
    
    const url = this.trackedValue 
      ? `/admin/tracking_list_players/${this.trackingListIdValue}/${this.playerIdValue}`
      : '/admin/tracking_list_players'
    
    const method = this.trackedValue ? 'DELETE' : 'POST'
    
    const csrfToken = document.querySelector('meta[name="csrf-token"]').content
    
    fetch(url, {
      method: method,
      headers: {
        'X-CSRF-Token': csrfToken,
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: method === 'POST' ? JSON.stringify({
        tracking_list_player: {
          tracking_list_id: this.trackingListIdValue,
          player_id: this.playerIdValue
        }
      }) : null
    })
    .then(response => {
      if (response.ok) {
        return response.json()
      }
      throw new Error('Network response was not ok')
    })
    .then(data => {
      this.updateButton(data.tracked)
    })
    .catch(error => {
      console.error('Error:', error)
    })
  }
  
  updateButton(tracked) {
    const button = this.buttonTarget
    const icon = button.querySelector('i')
    const trackingList = button.dataset.trackingListName
    
    // Toggle tracked state
    this.trackedValue = tracked
    
    // Update icon class
    if (tracked) {
      icon.classList.remove('text-muted')
      icon.classList.add('text-warning')
      
      // Replace icon_name_off with icon_name_on
      const offClass = button.dataset.iconOff
      const onClass = button.dataset.iconOn
      icon.classList.remove(offClass)
      icon.classList.add(onClass)
      
      // Update tooltip
      button.setAttribute('title', `Remove from ${trackingList}`)
    } else {
      icon.classList.remove('text-warning')
      icon.classList.add('text-muted')
      
      // Replace icon_name_on with icon_name_off
      const onClass = button.dataset.iconOn
      const offClass = button.dataset.iconOff
      icon.classList.remove(onClass)
      icon.classList.add(offClass)
      
      // Update tooltip
      button.setAttribute('title', `Add to ${trackingList}`)
    }
    
    // Reinitialize tooltip if Bootstrap tooltips are being used
    if (typeof bootstrap !== 'undefined') {
      const tooltip = bootstrap.Tooltip.getInstance(button)
      if (tooltip) {
        tooltip.dispose()
      }
      new bootstrap.Tooltip(button)
    }
  }
}
