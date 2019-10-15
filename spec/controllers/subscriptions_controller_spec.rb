require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:question) { create(:question, user: other_user) }

  before { sign_in(user) }

  describe 'POST #create' do
    it 'the user subscribed to the resource' do
      expect do
        post :create, params: { question_id: question.id }
      end.to change(question.subscriptions, :count).by(1)
    end
  end

  describe 'DELETE #destroy' do
    it 'the user unsubscribed to the resource' do
      question.subscriptions.create(user: user)
      expect do
        delete :destroy, params: { id: question.id }
      end.to change(question.subscriptions, :count).by(-1)
    end

    it 'the user unsubscribed to the resource' do
      expect do
        delete :destroy, params: { id: question.id }
      end.to_not change(question.subscriptions, :count)
    end
  end
end
