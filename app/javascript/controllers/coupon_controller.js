import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  apply(event) {
    event.preventDefault()
    const couponCode = this.element.querySelector("input[name='coupon_code']").value
  }
}
