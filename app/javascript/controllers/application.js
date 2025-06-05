import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = true
window.Stimulus   = application

export { application }

//  To get Bootstrap Dropdowns [using popper] to work consistently, reinitialize Bootstrap 
//  Dropdowns after Turbo loads
document.addEventListener("turbo:load", () => {
  // Re-enable Bootstrap dropdowns
  document.querySelectorAll('[data-bs-toggle="dropdown"]').forEach((dropdownToggleEl) => {
    new bootstrap.Dropdown(dropdownToggleEl);
  });
});
