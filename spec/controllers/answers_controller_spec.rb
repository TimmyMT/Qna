require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  describe 'POST #create' do
    let(:question) { create(:question) }

    context 'valid' do
      it 'create a new answer' do
        expect do
          post :create, params: {question_id: question, answer: attributes_for(:answer)}
        end.to change(Answer, :count).by(1)
      end

      it 'redirect to answers page after create' do
        post :create, params: {question_id: question, answer: attributes_for(:answer)}
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'invalid' do
      it 'not created answer' do
        expect do
          post :create, params: {question_id: question, answer: attributes_for(:answer, :invalid_answer)}
        end.to_not change(Answer, :count)
      end

      it 're-render new page' do
        post :create, params: {question_id: question, answer: attributes_for(:answer, :invalid_answer)}
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATH #update' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }

    context 'valid' do
      it 'updated answer' do
        patch :update, params: {id: answer, question_id: question, answer: attributes_for(:answer)}
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: {id: answer, question_id: question, answer: {body: 'new'}}
        answer.reload

        expect(answer.body).to eq 'new'
      end
    end

    context 'invalid' do
      it 'not updated answer' do
        patch :update, params: {id: answer, question_id: question, answer: attributes_for(:answer, :invalid_answer)}
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
