#App.cable.subscriptions.create('QuestionsChannel', {
#  connected: ->
#    console.log('Connected!')
#    @perform 'follow'
#  ,
#
#  received: (data) ->
#    $(".questions").append data
#});
