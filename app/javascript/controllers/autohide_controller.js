import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="autohide"
export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.dimiss()
    }, 2000);
  }

  dimiss() {
    this.element.remove()
  }
}
