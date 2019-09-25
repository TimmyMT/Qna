$(document).on('turbolinks:load', function() {
  $('.change-rating').on('ajax:success', function(e) {
    var data = e.detail[0];
    var object = e.detail[0][0];

    var vote_value = e.detail[0][1];
    var clas_object = object.votable_type.toLowerCase();
    var clas_id = object.votable_id;

    $('.rating-'+ clas_object + '_' + clas_id).text(vote_value);

    ['#vote-up-', '#vote-down-', '#vote-clear-'].forEach(function(classPrefix) {
      $(classPrefix  + clas_object + "_" + clas_id).toggle();
    });
  })
});
