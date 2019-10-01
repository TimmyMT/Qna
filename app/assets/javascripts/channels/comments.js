var ready = function () {
  App.cable.subscriptions.create('CommentsChannel', {
    connected: function() {
      console.log('Comments channel connected');
      this.perform('follow');
      console.log('current_user_id:', gon.current_user_id);
      console.log('user_signed_in:', gon.user_signed_in);
    },

    received: function(data) {
      var comment = data.comment;
      var comment_class = $('.comments' + comment.commentable_type + '_' + comment.commentable_id);
      $(comment_class).append(JST["templates/comment"](data))
    }
  })
};

$(document).on('turbolinks:load', ready);
