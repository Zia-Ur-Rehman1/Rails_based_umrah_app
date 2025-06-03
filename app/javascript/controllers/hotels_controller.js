import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="hotels"
export default class extends Controller {
  static targets = ["sar", "pkr"]
 connect() {
    this.convert()
  }
  convert() {
    const sar = parseFloat(this.sarTarget.value) || 0
    const rate = 74.86
    this.pkrTarget.textContent = `${(sar * rate).toFixed(2)}`
  }

}



