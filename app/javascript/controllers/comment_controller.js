import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("CommentController connected");
  }
  toggleForm(event) {
    console.log("Edit clicked");
    //  These two lines stop the browser from scrolling to the top whenever
    //  this method is called
    event.preventDefault();
    event.stopPropagation();
    const formID = event.params["form"];

    const form = document.getElementById(formID);
    form.classList.toggle("myhidden");
  }
}