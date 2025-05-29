import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle"
export default class extends Controller {
  // Define a target for our content to be toggled
  static targets = ["content"];  

  // Setup values that we reference in our controller and are passed in by view
  static values = {
    class: String,
    initialActive: { type: Boolean, default: false }
  }

  connect() {
    if (this.initialActiveValue === true) {
      //Use the initialActiveValue passed from data-toggle-initial-active-value to set inital state of toggled item
      this.toggle()
    }
  }

  toggle() {
    // use the classValue passed by our View via data-toggle-class-value to override the class in the View when teh click event occurs
    let classToToggle = this.classValue;
    this.contentTarget.classList.toggle(classToToggle);
    // Try to find a textarea inside and focus it
    const textarea = this.contentTarget.querySelector("textarea")
    if (textarea) textarea.focus()
  }
}
