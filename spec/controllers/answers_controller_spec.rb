require 'rails_helper'

RSpec.describe AnswersController, type: :controller do


  describe 'POST #create' do
    let(:user) { create(:user) }
    before { login(user) }
    let(:question) { create(:question, user: user) }

    context 'valid' do
      it 'create a new answer' do
        expect do
          post :create, params: {question_id: question, answer: attributes_for(:answer), user: user}
        end.to change(Answer, :count).by(1)
      end

      it 'redirect to answers page after create' do
        post :create, params: {question_id: question, answer: attributes_for(:answer), user: user}
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'invalid' do
      it 'not created answer' do
        expect do
          post :create, params: {question_id: question, answer: attributes_for(:answer, :invalid_answer), user: user}
        end.to_not change(Answer, :count)
      end

      it 're-render new page' do
        post :create, params: {question_id: question, answer: attributes_for(:answer, :invalid_answer), user: user}
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do

    let(:user) { create(:user) }
    before { login(user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }

    context 'valid' do
      it 'updated answer' do
        patch :update, params: {id: answer, question_id: question, answer: attributes_for(:answer), user: user}

        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: {id: answer, question_id: question, answer: {body: 'new'}, user: user}
        answer.reload

        expect(answer.body).to eq 'new'
      end

      it 'changes answer attributes with wrong user' do
        user = FactoryBot.create(:user)
        login(user)
        patch :update, params: {id: answer, question_id: question, answer: {body: 'new'}, user: user}
        answer.reload

        expect(answer.body).to_not eq 'new'
      end
    end

    context 'invalid' do
      it 'not updated answer' do
        patch :update, params: {id: answer, question_id: question, answer: attributes_for(:answer, :invalid_answer), user: user}
        answer.reload

        expect(answer.body).to eq 'MyText'
      end

      it 'render edit after fail update' do
        patch :update, params: {id: answer, question_id: question, answer: attributes_for(:answer, :invalid_answer), user: user}
        expect(response).to render_template(:edit)
      end
    end

  end

  describe 'DELETE #destroy' do
    let(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }

    it 'deleted answer' do
      expect do
        delete :destroy, params: {id: answer}
      end.to change(Answer, :count).by(-1)
    end

    it 'redirect to question page after deleted' do
      delete :destroy, params: {id: answer}
      expect(response).to redirect_to(question)
    end
  end

end
