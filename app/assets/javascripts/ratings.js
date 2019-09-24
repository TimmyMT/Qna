$(document).on('turbolinks:load', function() {
  $('.change-rating').on('ajax:success', function(e) {
    var data = e.detail[0];
    var object = e.detail[0][0];
    var rating_value = e.detail[0][1];
    var object_klass = e.detail[0][2];

    $('.rating-'+ object_klass+ '_' + object.id).text(rating_value);

    // var btnVoteUp = document.getElementById("vote-up-" + object_klass + "_" + object.id);
    // var btnVoteDown = document.getElementById("vote-down-" + object_klass + "_" + object.id);
    // var btnVoteClear = document.getElementById("vote-clear-" + object_klass + "_" + object.id);
    //
    // if (btnVoteClear.style.display === "") {
    //   btnVoteDown.style.display = "";
    //   btnVoteUp.style.display = "";
    //   btnVoteClear.style.display = "none";
    // } else {
    //   btnVoteDown.style.display = "none";
    //   btnVoteUp.style.display = "none";
    //   btnVoteClear.style.display = "";
    // }

    ['#vote-up-', '#vote-down-', '#vote-clear-'].forEach(function(classPrefix) {
      $(classPrefix  + object_klass + "_" + object.id).toggle();
    });
  })
});
