import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = true
window.Stimulus   = application

export { application }

//  Initialize Bootstrap popovers.  Code taken from Bootstrap
const popoverTriggerList = document.querySelectorAll('[data-bs-toggle="popover"]')
const popoverList = [...popoverTriggerList].map(popoverTriggerEl => new bootstrap.Popover(popoverTriggerEl))

//  I don't know what this does.  It is an attempt to get Bootstrap dropdown menus to function more than once...
//<script>data-turbolinks-eval=false</script>


// $(document).ready(function(){
//   $('.dropdown-toggle').dropdown();
// });