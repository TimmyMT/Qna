var ready = function () {
  App.cable.subscriptions.create('AnswersChannel', {
    connected: function() {
      console.log('Answers channel connected');
      this.perform('follow')
    },

    received: function(data) {
      var answer = data.answer;
      if (answer.user_id !== gon.current_user_id) {
        console.log(answer);
        $('.answers').append(JST["templates/answer"](data));
      }
    }
  })
};

$(document).on('turbolinks:load', ready);
