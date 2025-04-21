import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list", "form", "commentBody", "editForm", "editCommentBody"]

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
        "Accept": "text/vnd.turbo-stream.html"
      }
    })
    .then(response => response.text())
    .then(html => {
      Turbo.renderStreamMessage(html)
      this.commentBodyTarget.value = ''
    })
  }

  editComment(event) {
    const commentId = event.currentTarget.dataset.commentId
    const commentBody = event.currentTarget.dataset.commentBody
    const editForm = document.getElementById(`edit-comment-form-${commentId}`)
    const commentDisplay = document.getElementById(`comment-display-${commentId}`)
    
    document.getElementById(`edit-comment-body-${commentId}`).value = commentBody
    editForm.classList.remove('d-none')
    commentDisplay.classList.add('d-none')
  }

  cancelEdit(event) {
    const commentId = event.currentTarget.dataset.commentId
    const editForm = document.getElementById(`edit-comment-form-${commentId}`)
    const commentDisplay = document.getElementById(`comment-display-${commentId}`)
    
    editForm.classList.add('d-none')
    commentDisplay.classList.remove('d-none')
  }

  updateComment(event) {
    event.preventDefault()
    const commentId = event.currentTarget.dataset.commentId
    const form = document.getElementById(`edit-comment-form-${commentId}`)
    const formData = new FormData(form)
    
    fetch(form.action, {
      method: 'PATCH',
      body: formData,
      headers: {
        "Accept": "text/vnd.turbo-stream.html"
      }
    })
    .then(response => response.text())
    .then(html => {
      Turbo.renderStreamMessage(html)
      form.classList.add('d-none')
      document.getElementById(`comment-display-${commentId}`).classList.remove('d-none')
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