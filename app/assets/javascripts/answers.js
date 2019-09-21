$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).removeClass('hidden');
  });

  $('form.new-answer').on('ajax:success', function(e) {
    console.log(e.detail)
    var answer = e.detail[0];

    $('.answers').append('<p>' + answer.body + '</p>');
  })
    .on('ajax:error', function (e) {
      var errors = e.detail[0]

      $.each(errors, function (index, value) {
        $('.answer-errors').append('<div class="alert alert-danger">' + value + '</div>')
      });
      $('.answer-errors').html(xhr.responseText)
    })

});
