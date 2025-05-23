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

  toggle(event) {
    // use the classValue passed by our View via data-toggle-class-value to override the class in the View when teh click event occurs
    let classToToggle = this.classValue;
    this.contentTarget.classList.toggle(classToToggle);
    //  These two lines stop the browser from scrolling to the top whenever
    //  this method is called
    event.preventDefault();
    event.stopPropagation();
  }
}
