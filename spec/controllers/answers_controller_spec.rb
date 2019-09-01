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

    context 'valid' do

    end

    context 'invalid' do

    end
  end

end
