import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results"]
  
  connect() {
    // Close dropdown when clicking outside
    document.addEventListener('click', this.closeDropdown.bind(this))
  }
  
  disconnect() {
    document.removeEventListener('click', this.closeDropdown.bind(this))
  }
  
  closeDropdown(event) {
    if (!this.element.contains(event.target)) {
      this.resultsTarget.classList.add('d-none')
    }
  }
  
  search() {
    const query = this.inputTarget.value.trim()
    
    if (query.length < 2) {
      this.resultsTarget.classList.add('d-none')
      return
    }
    
    fetch(`/admin/players/search?q=${encodeURIComponent(query)}`)
      .then(response => response.json())
      .then(data => {
        this.resultsTarget.innerHTML = ''
        
        if (data.length === 0) {
          const noResults = document.createElement('div')
          noResults.classList.add('dropdown-item', 'text-muted')
          noResults.textContent = 'No players found'
          this.resultsTarget.appendChild(noResults)
        } else {
          data.forEach(player => {
            const item = document.createElement('a')
            item.classList.add('dropdown-item')
            item.href = player.profile_url
            item.textContent = player.formatted_name
            this.resultsTarget.appendChild(item)
          })
        }
        
        this.resultsTarget.classList.remove('d-none')
      })
      .catch(error => {
        console.error('Error searching players:', error)
      })
  }
}
