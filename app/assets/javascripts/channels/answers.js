var ready = function () {
  App.cable.subscriptions.create('AnswersChannel', {
    connected: function() {
      console.log('Answers channel connected');
      this.perform('follow')
    },

    received: function(data) {
      var answer = data.answer;
      var answer_links = data.answer_links;
      var answer_files = data.answer_files;
      console.log(answer_files);
      if (answer.user_id !== gon.current_user_id) {
        $('.answers').append(JST["templates/answer"](data));
        // $('.answers').append($.parseHTML(data.html, true));
      }
    }
  })
};

$(document).on('turbolinks:load', ready);
