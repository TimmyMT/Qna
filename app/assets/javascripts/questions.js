var edit_question_click = function() {
  $(document).on('click', '.edit-question-link', function(e) {
    e.preventDefault();
    $(this).hide();
    questionId = $(this).data('questionId');
    $('form#edit-question-' + questionId).show();
  });
};

$(document).on('turbolinks:load', edit_question_click);
