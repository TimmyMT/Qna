var ready = function () {
  var questionId = $('.question').data('id');

  if (typeof questionId !== 'undefined') {
    App.current_question = App.cable.subscriptions.create('AnswersChannel', {
      connected: function() {
        this.perform('follow', {
          question_id: questionId
        });
      },

      received: function(data) {
        var answer = data.answer;

        if (answer.user_id !== gon.current_user_id) {
          $('.answers').append(JST["templates/answer"](data));
        }
      }
    })
  } else if (App.current_question) {
    App.current_question.unsubscribe();
  }

};

$(document).on('turbolinks:load', ready);
