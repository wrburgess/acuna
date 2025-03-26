import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["link"]
  static values = {
    defaultView: { type: String, default: "stats" }
  }

  connect() {
    console.log("ColumnViewController connected to:", this.element)
    
    // Get the current view from the URL
    const urlParams = new URLSearchParams(window.location.search)
    const currentView = urlParams.get('view') || this.defaultViewValue
    console.log("Current view is:", currentView)
    
    // Force processing after a short delay to ensure DOM is fully loaded
    setTimeout(() => {
      if (this.element.classList.contains('table-responsive')) {
        console.log("Processing table columns for view:", currentView)
        this.processTableColumns(currentView)
      } else if (this.element.classList.contains('d-flex')) {
        console.log("Setting active link for view:", currentView)
        this.setActiveNav(currentView)
      }
    }, 100)
  }

  // Process table columns based on the selected view
  processTableColumns(viewName) {
    const table = this.element.querySelector('table')
    if (!table) {
      console.error("No table found within the element")
      return
    }

    console.log("Found table, processing columns")
    
    // Get all headers and process each one
    const headers = Array.from(table.querySelectorAll('thead th'))
    console.log(`Found ${headers.length} table headers`)
    
    headers.forEach((header, index) => {
      // Get the view attribute from the link
      const link = header.querySelector('a')
      const viewAttribute = link ? link.getAttribute('view') : null
      
      console.log(`Column ${index}: Header text="${header.textContent.trim()}", view="${viewAttribute}"`)
      
      // Determine if column should be visible
      const isBaseColumn = viewAttribute === 'base'
      const isCurrentViewColumn = viewAttribute === viewName
      const hasNoViewAttr = !viewAttribute
      const shouldShow = isBaseColumn || isCurrentViewColumn || hasNoViewAttr
      
      // Set initial visibility for header
      this.applyVisibility(header, shouldShow)
      
      // Set visibility for all cells in this column
      Array.from(table.querySelectorAll('tbody tr')).forEach(row => {
        if (index < row.cells.length) {
          this.applyVisibility(row.cells[index], shouldShow)
        }
      })
      
      console.log(`Column ${index}: Set visibility to ${shouldShow}`)
    })
  }
  
  // Apply visibility using both class and direct style
  applyVisibility(element, visible) {
    if (!element) return
    
    if (visible) {
      element.classList.remove('d-none')
      element.style.removeProperty('display')
    } else {
      element.classList.add('d-none')
      element.style.display = 'none'
    }
  }

  // Set active navigation link
  setActiveNav(viewName) {
    const links = this.element.querySelectorAll('.nav-item a')
    
    links.forEach(link => {
      try {
        const href = link.getAttribute('href')
        const url = new URL(href, window.location.origin)
        const linkView = url.searchParams.get('view')
        
        console.log(`Nav link: "${link.textContent.trim()}", view="${linkView}"`)
        
        if (linkView === viewName) {
          link.classList.add('active')
        } else {
          link.classList.remove('active')
        }
      } catch (e) {
        console.error("Error parsing URL:", e)
      }
    })
  }
}
