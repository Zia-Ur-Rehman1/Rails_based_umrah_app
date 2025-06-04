import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="hotels"
export default class extends Controller {
  static targets = ["sar", "pkr"]
  static values = { rate: Number }
  connect() {
if (this.hasSarTarget && this.hasPkrTarget) {
    this.convert()
  }
  }
  convert() {
    const sar = parseFloat(this.sarTarget.value) || 0
    const rate = this.rateValue || 74.86
    this.pkrTarget.textContent = `${(sar * rate).toFixed(2)}`
  }

}



