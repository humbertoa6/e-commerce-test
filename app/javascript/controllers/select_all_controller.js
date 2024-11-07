import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["userCheckbox", "selectAll"]

  connect() {
    this.selectAllTarget.addEventListener("change", this.toggleSelectAll.bind(this))
  }

  toggleSelectAll(event) {
    const isChecked = event.target.checked
    this.userCheckboxTargets.forEach(checkbox => {
      checkbox.checked = isChecked
    })
  }
}
