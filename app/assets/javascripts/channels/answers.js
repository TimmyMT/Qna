var ready = function () {
  var questionId = $('.question').data('id');
  console.log('question_id: ', questionId);

  if (questionId !== undefined) {
    App.current_question = App.cable.subscriptions.create('AnswersChannel', {
      connected: function() {
        this.perform('follow', {
          question_id: questionId
        });
        console.log('Answers of Question-' + questionId + ' was connected');
      },

      received: function(data) {
        var answer = data.answer;
        var answer_links = data.answer_links;
        var answer_files = data.answer_files;

        if (answer.user_id !== gon.current_user_id) {
          $('.answers').append(JST["templates/answer"](data));
        }
      }
    })
  } else if (questionId === undefined) {
    App.current_question.unsubscribe();
  }

};

$(document).on('turbolinks:load', ready);
