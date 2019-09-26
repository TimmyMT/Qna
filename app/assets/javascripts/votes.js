$(document).on('turbolinks:load', function() {
  $('.change-rating').on('ajax:success', function(e) {
    var data = e.detail[0];

    var rating = data.rating;
    var object_klass = data.klass;
    var object_id = data.id;

    $('.rating-'+ object_klass + '_' + object_id).text(rating);

    ['#vote-up-', '#vote-down-', '#vote-clear-'].forEach(function(classPrefix) {
      $(classPrefix  + object_klass + "_" + object_id).toggle();
    });
  })
});
