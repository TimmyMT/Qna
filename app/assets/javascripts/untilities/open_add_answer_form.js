function hide() {
  var add_answer = document.getElementById("addAnswerForm");
  var hide_button = document.getElementById("addAnswerButton");
  if (add_answer.style.display === "none") {
    add_answer.style.display = "block";
    hide_button.style.display = "none";
  } else {
    add_answer.style.display = "none";
    hide_button.style.display = "block"
  }
}
