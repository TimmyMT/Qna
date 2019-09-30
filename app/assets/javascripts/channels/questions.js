var ready = function () {
  App.cable.subscriptions.create('QuestionsChannel', {
    connected: function() {
      console.log('Connected');
      this.perform('follow')
    },

    received: function(data) {
      var question = data.question;
      console.log(question);
      $('.questions').append('<p>' + "<a href='http://localhost:3000/questions/" + question.id + "'>" + question.title + "</a>" + '</p>')
    }
  })
};

$(document).on('turbolinks:load', ready);
