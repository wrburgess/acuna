// app/javascript/admin/comment_controller.js

import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["body", "form", "list"];

  connect() {
    console.log("Comment controller connected");
  }

  expand(event) {
    const commentBody = event.target.closest(".comment").querySelector(".comment-body");
    commentBody.textContent = commentBody.dataset.fullBody;
    event.target.remove();
  }

  edit(event) {
    const commentId = event.target.dataset.id;
    // Logic to handle editing a comment
    console.log(`Edit comment with ID: ${commentId}`);
  }

  archive(event) {
    const commentId = event.target.dataset.id;
    // Logic to handle archiving a comment
    console.log(`Archive comment with ID: ${commentId}`);
  }

  submit(event) {
    event.preventDefault();
    const formData = new FormData(this.formTarget);

    fetch(this.formTarget.action, {
      method: "POST",
      body: formData,
      headers: {
        "X-CSRF-Token": document.querySelector("meta[name=csrf-token]").content,
      },
    })
      .then((response) => response.json())
      .then((data) => {
        if (data.success) {
          this.listTarget.insertAdjacentHTML("beforeend", data.comment_html);
          this.formTarget.reset();
        } else {
          console.error("Failed to create comment", data.errors);
        }
      });
  }
}