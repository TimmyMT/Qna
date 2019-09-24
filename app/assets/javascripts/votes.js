$(document).on('turbolinks:load', function() {
  $('.change-rating').on('ajax:success', function(e) {
    var data = e.detail[0];
    var object = e.detail[0][0];
    var rating_value = e.detail[0][1];
    var object_klass = e.detail[0][2];

    $('.rating-'+ object_klass+ '_' + object.id).text(rating_value);

    ['#vote-up-', '#vote-down-', '#vote-clear-'].forEach(function(classPrefix) {
      $(classPrefix  + object_klass + "_" + object.id).toggle();
    });
  })
});
