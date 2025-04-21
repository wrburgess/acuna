import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  static targets = ["list", "form", "commentBody"]

  connect() {
    console.log("Comments controller connected")
  }

  submitComment(event) {
    event.preventDefault()
    const form = this.formTarget
    const formData = new FormData(form)
    
    fetch(form.action, {
      method: 'POST',
      body: formData,
      headers: {
        "Accept": "text/vnd.turbo-stream.html",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      }
    })
    .then(response => response.text())
    .then(html => {
      Turbo.renderStreamMessage(html)
      this.commentBodyTarget.value = ''
    })
    .catch(error => {
      console.error("Error submitting comment:", error)
    })
  }

  editComment(event) {
    const commentId = event.currentTarget.dataset.commentId
    const commentBody = event.currentTarget.dataset.commentBody
    
    // First make sure we can find the elements we need
    const editFormContainer = document.getElementById(`edit-comment-form-${commentId}`)
    const commentDisplay = document.getElementById(`comment-display-${commentId}`)
    const textArea = document.getElementById(`edit-comment-body-${commentId}`)
    
    if (!editFormContainer || !commentDisplay || !textArea) {
      console.error("Could not find required elements for editing")
      return
    }
    
    // Set the current comment text in the textarea
    textArea.value = commentBody
    
    // Show the edit form and hide the display
    editFormContainer.classList.remove('d-none')
    commentDisplay.classList.add('d-none')
  }

  cancelEdit(event) {
    const commentId = event.currentTarget.dataset.commentId
    const editFormContainer = document.getElementById(`edit-comment-form-${commentId}`)
    const commentDisplay = document.getElementById(`comment-display-${commentId}`)
    
    if (editFormContainer && commentDisplay) {
      editFormContainer.classList.add('d-none')
      commentDisplay.classList.remove('d-none')
    }
  }

  updateComment(event) {
    event.preventDefault()
    
    // Find the form - this works whether the action is on the form or a button inside it
    const form = event.currentTarget.tagName === 'FORM' ? 
                event.currentTarget : 
                event.currentTarget.closest('form')
    
    if (!form || !(form instanceof HTMLFormElement)) {
      console.error("Cannot find valid form element")
      return
    }
    
    const commentId = form.dataset.commentId
    
    // Create FormData with the form element
    const formData = new FormData(form)
    
    fetch(form.action, {
      method: 'PATCH',
      body: formData,
      headers: {
        "Accept": "text/vnd.turbo-stream.html",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      }
    })
    .then(response => {
      if (!response.ok) {
        throw new Error(`HTTP error! Status: ${response.status}`)
      }
      return response.text()
    })
    .then(html => {
      Turbo.renderStreamMessage(html)
      
      // Hide the form and show the display
      const editFormContainer = document.getElementById(`edit-comment-form-${commentId}`)
      const commentDisplay = document.getElementById(`comment-display-${commentId}`)
      
      if (editFormContainer && commentDisplay) {
        editFormContainer.classList.add('d-none')
        commentDisplay.classList.remove('d-none')
      }
    })
    .catch(error => {
      console.error("Error updating comment:", error)
      alert("Failed to update comment. Please try again.")
    })
  }

  archiveComment(event) {
    if (confirm("Are you sure you want to archive this comment?")) {
      const commentId = event.currentTarget.dataset.commentId
      
      fetch(`/admin/comments/${commentId}/archive`, {
        method: 'PATCH',
        headers: {
          "Accept": "text/vnd.turbo-stream.html",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        }
      })
      .then(response => response.text())
      .then(html => {
        // Remove the comment from the list
        document.getElementById(`comment-item-${commentId}`).remove()
      })
    }
  }
}
