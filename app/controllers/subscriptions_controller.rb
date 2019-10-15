class SubscriptionsController < ActionController::Base
  before_action :authenticate_user!

  authorize_resource

  def create
    @question = Question.find(params[:question_id])
    @question.subscribers.push(current_user)
    redirect_to @question, notice: 'Sub success'
  end

  def destroy
    @question = Question.find(params[:id])
    @question.subscribers.delete(current_user)
    redirect_to @question, notice: 'Unsub success'
  end
end
