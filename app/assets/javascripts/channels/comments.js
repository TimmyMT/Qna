var ready = function () {
  App.cable.subscriptions.create('CommentsChannel', {
    connected: function() {
      this.perform('follow');
    },

    received: function(data) {
      var comment = data.comment;
      var comment_class = $('.comments' + comment.commentable_type + '_' + comment.commentable_id);
      $(comment_class).append(JST["templates/comment"](data))
    }
  })
};

$(document).on('turbolinks:load', ready);
