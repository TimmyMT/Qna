require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe "GET #index" do
    let!(:questions) { create_list(:question, 3, user: user) }

    before { get :index }

    it "populate an array of all questions" do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template(:index)
    end
  end

  describe "GET #show" do
    before { get :show, params: { id: question } }

    it 'renders show view' do
      expect(response).to render_template(:show)
    end
  end

  describe "GET #new" do
    it 'renders new view for authorized user' do
      login(user)
      get :new
      expect(response).to render_template(:new)
    end

    it 'redirect sign in view for guest' do
      get :new
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe 'GET #edit' do
    context 'Authorized user' do
      it 'renders edit view for author' do
        login(user)
        get :edit, params: { id: question }
        expect(question.user_id).to eq(user.id)
        expect(response).to render_template(:edit)
      end

      it 'redirect to question view for not author' do
        user = FactoryBot.create(:user)
        # user = User.create!(email: 'wrong_user1@test.com', password: '123456', password_confirmation: '123456')
        login(user)
        get :edit, params: { id: question }

        expect(question.user_id).to_not eq(user.id)
        expect(response).to redirect_to(question)
      end
    end

    context 'Not Authorized user' do
      it 'redirect to sign in' do
        get :edit, params: { id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  ###############################################################################################

  describe 'POST #create' do
    before { login(user) }
    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: {question: attributes_for(:question, user: user) } }.to change(Question, :count).by(1)
      end

      it 'redirect to show view' do
        post :create, params: {question: attributes_for(:question, user: user) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: {question: attributes_for(:question, :invalid_question, user: user) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: {question: attributes_for(:question, :invalid_question, user: user) }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do

    context 'right user' do
      before { login(user) }
      before { get :edit, params: { id: question } }

      context 'with valid attributes' do
        it 'assigns the requested question to @question' do
          patch :update, params: { id: question, question: attributes_for(:question), user: user }

          expect(question.user_id).to eq(user.id)
          expect(assigns(:question)).to eq question
        end

        it 'changes question attributes' do
          patch :update, params: { id: question, question: {title: 'new', body: 'new'}, user: user }
          question.reload

          expect(question.user_id).to eq(user.id)
          expect(question.title).to eq 'new'
          expect(question.body).to eq 'new'
        end

        it 'redirects to updated attributes' do
          patch :update, params: { id: question, question: attributes_for(:question), user: user }

          expect(question.user_id).to eq(user.id)
          expect(response).to redirect_to question
        end
      end

      context 'with invalid attributes' do
        before { patch :update, params: { id: question, question: attributes_for(:question, :invalid_question), user: user } }

        it 'does not change question' do
          question.reload

          expect(question.title).to eq 'MyString'
          expect(question.body).to eq 'MyText'
        end

        it 're-renders edit view' do
          expect(response).to render_template(:edit)
        end
      end
    end

    context 'tries with wrong user' do
      user = FactoryBot.create(:user)
      # user = User.create(email: 'wrong_user@test.com', password: '123456', password_confirmation: '123456')
      before { login(user) }
      before { get :edit, params: { id: question } }

      it 'changes question attributes' do
        patch :update, params: { id: question, question: {body: 'new'}, user: user }
        question.reload

        expect(question.user_id).to_not eq(user.id)
        expect(question.body).to_not eq 'new'
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, user: user) }

    context 'Authorized user' do
      before { login(user) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'Not Authorized user' do
      user = User.create(email: 'wrong_user@test.com', password: '123456', password_confirmation: '123456')
      before { login(user) }

      it 'not delete the question' do
        expect(question.user_id).to_not eq(user.id)
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end
    end

  end

end
