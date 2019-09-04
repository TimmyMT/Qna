require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  describe 'GET #edit' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }

    context 'Authorized user' do
      it 'render edit view for author' do
        login(user)
        get :edit, params: { id: answer, question: question, user: user }
        expect(answer.user).to eq(user)
        expect(response).to render_template(:edit)
      end

      it 'redirect to question view for not author' do
        user = FactoryBot.create(:user)
        login(user)
        get :edit, params: { id: answer, question: question, user: user }

        expect(answer.user).to_not eq(user)
        expect(response).to redirect_to(question)
      end
    end

    context 'Not Authorized user' do
      it 'redirect to sign in' do
        get :edit, params: { id: answer }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    context 'Guest' do
      it 'tries create answer' do
        expect do
          post :create, params: {question_id: question, answer: attributes_for(:answer, :invalid_answer)}
        end.to_not change(Answer, :count)
      end
    end

    context 'Authorized user' do
      before { login(user) }

      context 'valid' do
        it 'create a new answer' do
          expect do
            post :create, params: {question_id: question, answer: attributes_for(:answer), user: user}
          end.to change(Answer, :count).by(1)
          answer = Answer.last
          expect(answer.user).to eq(user)
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
  end

  describe 'PATCH #update' do

    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }

    context 'Guest' do
      it 'tries update' do
        patch :update, params: {id: answer, question_id: question, answer: {body: 'new'}}
        answer.reload

        expect(answer.body).to_not eq 'new'
      end
    end

    context 'Authorized user' do
      before { login(user) }

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

  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'Guest' do
      it 'tries to delete answer' do
        expect { delete :destroy, params: {id: answer} }.to_not change(Answer, :count)
      end
    end

    context 'Authorized user' do
      before { login(user) }

      context 'User is answer author' do
        it 'deleted answer' do
          expect(answer.user).to eq(user)
          expect { delete :destroy, params: {id: answer, user: user} }.to change(Answer, :count).by(-1)
        end

        it 'redirect to question page after deleted' do
          delete :destroy, params: {id: answer, user: user}
          expect(answer.user).to eq(user)
          expect(response).to redirect_to(question)
        end
      end

      context 'User is not answer author' do
        it 'deleted answer' do
          user = FactoryBot.create(:user)
          login(user)
          expect(answer.user).to_not eq(user)
          expect { delete :destroy, params: {id: answer, user: user} }.to_not change(Answer, :count)
        end
      end
    end


  end

end
