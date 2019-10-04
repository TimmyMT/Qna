var ready = function () {
  var questionId = $('.question').data('id');

  if (typeof questionId !== 'undefined') {
    App.current_boards = App.cable.subscriptions.create('CommentsChannel', {
      connected: function() {
        this.perform('follow', {
          question_id: questionId
        });
      },

      received: function(data) {
        var comment = data.comment;
        var comment_class = $('.comments' + comment.commentable_type + '_' + comment.commentable_id);
        if (comment.user_id !== gon.current_user_id) {
          $(comment_class).append(JST["templates/comment"](data))
        }
      }
    })
  } else if (App.current_boards) {
    App.current_boards.unsubscribe();
  }

};

$(document).on('turbolinks:load', ready);
