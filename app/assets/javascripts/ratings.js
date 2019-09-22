$(document).on('turbolinks:load', function() {
  $('.change-rating').on('ajax:success', function(e) {
    var data = e.detail[0];
    $(".rating_" + data.id + "> h5").text(data.value);

    ['.up-rating_', '.down-rating_', '.clear_vote-rating_'].forEach(function(classPrefix) {
      $(classPrefix + data.id).toggle();
    });
  })
});
