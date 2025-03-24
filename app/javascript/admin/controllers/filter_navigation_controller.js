import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["levelLink", "statusLink", "positionLink", "listLink", "timelineLink"]

  connect() {
    // Set default active states based on URL
    this.setInitialActiveStates()
  }

  setInitialActiveStates() {
    const params = new URLSearchParams(window.location.search)
    
    // Set active states for each filter type
    this.setActiveForCategory("levelLink", "q[level_id_eq]", params)
    this.setActiveForCategory("statusLink", "q[status_id_eq]", params)
    this.setActiveForCategory("positionLink", ["q[position_eq]", "q[position_in][]"], params)
    this.setActiveForCategory("listLink", "q[tracking_list_players_tracking_list_id_eq]", params)
    
    // Default timeline is 2024
    if (this.hasTarget("timelineLink")) {
      // Find the 2024 link
      const year2024Link = this.timelineLinkTargets.find(el => el.textContent.trim() === "2024")
      if (year2024Link) {
        year2024Link.classList.add("active")
      }
    }
  }

  setActiveForCategory(targetName, paramNames, urlParams) {
    if (!this.hasTarget(targetName)) return
    
    // Convert single param name to array for consistency
    const paramArray = Array.isArray(paramNames) ? paramNames : [paramNames]
    
    // Check if any of the params exist in the URL
    const hasParam = paramArray.some(param => urlParams.has(param))
    
    if (hasParam) {
      // Find the link that matches the param value
      this[`${targetName}Targets`].forEach(link => {
        const linkUrl = new URL(link.href)
        const linkParams = new URLSearchParams(linkUrl.search)
        
        const isMatch = paramArray.some(param => {
          const urlValue = urlParams.get(param)
          const linkValue = linkParams.get(param)
          return urlValue && linkValue && urlValue === linkValue
        })
        
        // Special case for position_in[] which can be an array
        const positionInMatch = paramArray.includes("q[position_in][]") && 
          this.arrayParamMatches(urlParams, linkParams, "q[position_in][]")
        
        if (isMatch || positionInMatch) {
          link.classList.add("active")
        } else {
          link.classList.remove("active")
        }
      })
    } else {
      // If no param exists, set the "All" link as active
      const allLink = this[`${targetName}Targets`].find(link => {
        // For list links look for "All Lists" text
        if (targetName === "listLink" && link.textContent.trim() === "All Lists") {
          return true
        }
        
        // For other categories look for "All" text
        if (targetName !== "listLink" && link.textContent.trim() === "All") {
          return true
        }
        
        return false
      })
      
      if (allLink) {
        allLink.classList.add("active")
      }
    }
  }

  arrayParamMatches(urlParams, linkParams, paramName) {
    const urlValues = urlParams.getAll(paramName)
    const linkValues = linkParams.getAll(paramName)
    
    // If array lengths don't match, it's not a match
    if (urlValues.length !== linkValues.length) return false
    
    // Sort both arrays for comparison
    const sortedUrlValues = [...urlValues].sort()
    const sortedLinkValues = [...linkValues].sort()
    
    // Check if every element matches
    return sortedUrlValues.every((val, idx) => val === sortedLinkValues[idx])
  }

  levelClick(event) {
    this.handleClick(event, "levelLink", ["statusLink", "positionLink"])
  }

  statusClick(event) {
    this.handleClick(event, "statusLink", ["levelLink", "positionLink"])
  }

  positionClick(event) {
    this.handleClick(event, "positionLink", ["levelLink", "statusLink"])
  }

  listClick(event) {
    // List clicks don't preserve other filter types
    this.handleClick(event, "listLink", [])
  }

  timelineClick(event) {
    this.handleClick(event, "timelineLink", ["levelLink", "statusLink", "positionLink", "listLink"])
  }

  handleClick(event, activeCategory, preserveCategories) {
    event.preventDefault()
    
    // Set this link as active
    this[`${activeCategory}Targets`].forEach(link => {
      link.classList.remove("active")
    })
    event.currentTarget.classList.add("active")
    
    // Build URL with preserved parameters
    const newUrl = this.buildUrl(event.currentTarget.href, preserveCategories)
    
    // Navigate to the new URL with a full page load to ensure proper state
    window.location.href = newUrl
  }

  buildUrl(baseUrl, preserveCategories) {
    if (preserveCategories.length === 0) return baseUrl
    
    const currentUrl = new URL(window.location.href)
    const currentParams = new URLSearchParams(currentUrl.search)
    const newUrl = new URL(baseUrl)
    const newParams = new URLSearchParams(newUrl.search)
    
    // Map categories to their respective parameter names
    const paramMapping = {
      "levelLink": ["q[level_id_eq]"],
      "statusLink": ["q[status_id_eq]"],
      "positionLink": ["q[position_eq]", "q[position_in][]"],
      "listLink": ["q[tracking_list_players_tracking_list_id_eq]"]
    }
    
    // Copy parameters from current URL for each preserved category
    preserveCategories.forEach(category => {
      const params = paramMapping[category] || []
      
      params.forEach(param => {
        // Don't override params already set in the new URL
        if (newParams.has(param)) return
        
        // For array params (like position_in[])
        if (param.endsWith("[]")) {
          const values = currentParams.getAll(param)
          values.forEach(val => {
            newParams.append(param, val)
          })
        } else if (currentParams.has(param)) {
          newParams.set(param, currentParams.get(param))
        }
      })
    })
    
    return `${newUrl.pathname}?${newParams.toString()}`
  }
}
