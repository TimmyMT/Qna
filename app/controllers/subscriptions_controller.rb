class SubscriptionsController < ActionController::Base
  authorize_resource

  def create
    @resource = Question.find(params[:question_id])
    @resource.subscribe(current_user)
    redirect_to @resource, notice: 'Sub success'
  end

  def destroy
    @resource = Subscription.find(params[:id])
    @question = @resource.question
    @resource.question.unsubscribe(@resource.user)
    redirect_to @question, notice: 'Unsub success'
  end
end
