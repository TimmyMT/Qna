var ready = function () {
  App.cable.subscriptions.create('QuestionsChannel', {
    connected: function() {
      this.perform('follow')
    },

    received: function(data) {
      var question = data.question;
      $('.questions').append(JST["templates/question"](data));
    }
  })
};

$(document).on('turbolinks:load', ready);
