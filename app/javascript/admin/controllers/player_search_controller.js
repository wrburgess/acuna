import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results"]
  
  connect() {
    console.log("Player search controller connected")
    document.addEventListener('click', this.handleClickOutside.bind(this))
  }
  
  disconnect() {
    document.removeEventListener('click', this.handleClickOutside.bind(this))
  }
  
  handleClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.resultsTarget.classList.add('d-none')
    }
  }
  
  search() {
    const query = this.inputTarget.value.trim()
    console.log("Searching for:", query)
    
    if (query.length < 2) {
      this.resultsTarget.classList.add('d-none')
      return
    }
    
    // Add debug log
    console.log(`Fetching from: /admin/players/search?q=${encodeURIComponent(query)}`)
    
    fetch(`/admin/players/search?q=${encodeURIComponent(query)}`)
      .then(response => {
        console.log("Response status:", response.status)
        return response.json()
      })
      .then(data => {
        console.log("Received data:", data)
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
        this.resultsTarget.classList.add('d-block')
      })
      .catch(error => {
        console.error('Error searching players:', error)
      })
  }
}
