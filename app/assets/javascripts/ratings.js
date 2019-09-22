$(document).on('turbolinks:load', function() {
  $('.change-rating').on('ajax:success', function(e) {
    var data = e.detail[0];
    $(".rating_" + data.id + "> span").text(data.value);

    // console.log("this: ", this);
    var clearBtn = $(".clear-vote-link", this);
    var upBtn = $(".up-vote-link", this);
    var downBtn = $(".down-vote-link", this);

    var isClearVote = $(e.target).hasClass("clear-vote-link");
    if (isClearVote) {
      clearBtn.hide();
      upBtn.show();
      downBtn.show();
    } else {
      clearBtn.show();
      upBtn.hide();
      downBtn.hide();
    }
  })
});
