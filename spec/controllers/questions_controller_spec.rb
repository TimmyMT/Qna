require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:wrong_user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe "GET #index" do
    before do
      @questions = Question.create!([
         {title: 'q1', body: 'bq1', user: user},
         {title: 'q2', body: 'bq2', user: user},
         {title: 'q3', body: 'bq3', user: user}
       ])

      get :index
    end

    it "populate an array of all questions" do
      expect(@questions).to match_array(@questions)
    end

    it 'renders index view' do
      expect(response).to render_template(:index)
    end
  end

  describe "GET #show" do
    before { get :show, params: { id: question } }

    it 'aasigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'aasigns new link for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'renders show view' do
      expect(response).to render_template(:show)
    end
  end

  describe "GET #new" do
    context 'authorized user' do
      before { login(user) }
      before { get :new }

      it 'render link fields when tries create new question' do
        expect(assigns(:question).links.first).to be_a_new(Link)
      end

      it 'renders new view for authorized user' do
        expect(response).to render_template(:new)
      end
    end

    it 'redirect sign in view for guest' do
      get :new
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe 'POST #create' do
    context 'Guest' do
      it 'tries to create question' do
        expect { post :create, params: {question: attributes_for(:question) } }.to_not change(Question, :count)
      end
    end

    context 'Authorized user' do
      before { login(user) }

      context 'with valid attributes' do

        it 'saves a new question in the database' do
          expect { post :create, params: {question: attributes_for(:question, user: user) } }.to change(Question, :count).by(1)
          question = Question.order(created_at: :desc).first
          expect(question.user).to eq(user)
        end

        it 'create question with achievement' do
          expect do
            post :create, params: {question: attributes_for(:question, user: user,
                                   achievement: FactoryBot.create(:achievement, question: question)) }
          end.to change(Achievement, :count).by(1)
          expect(question.achievement).to eq Achievement.last
        end

        it 'create question with link' do
          expect do
            post :create, params: {question: attributes_for(:question, user: user,
                                   links: FactoryBot.create(:link, linkable_id: question.id, linkable_type: question.class.to_s)) }
          end.to change(Link, :count).by(1)
          expect(question.links.last).to eq Link.last
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

  end

  describe 'PATCH #update' do
    context 'Guest' do
      it 'tries update question' do
        patch :update, params: { id: question, question: {body: 'new'} }
        question.reload

        expect(question.body).to eq 'MyText'
      end
    end

    context 'Authorized user' do
      context 'right user' do
        before { login(user) }

        context 'with valid attributes' do
          it 'assigns the requested question to @question' do
            patch :update, params: { id: question, question: attributes_for(:question), user: user, format: :js }

            expect(assigns(:question)).to eq question
          end

          it 'changes question attributes' do
            patch :update, params: { id: question, question: {title: 'new', body: 'new'}, user: user, format: :js }
            question.reload

            expect(question.title).to eq 'new'
            expect(question.body).to eq 'new'
          end
        end

        context 'with invalid attributes' do
          before { patch :update, params: { id: question, question: attributes_for(:question, :invalid_question), user: user, format: :js } }

          it 'does not change question' do
            question.reload

            expect(question.title).to eq 'MyString'
            expect(question.body).to eq 'MyText'
          end
        end
      end

      context 'tries with wrong user' do
        before { login(wrong_user) }

        it 'changes question attributes' do
          patch :update, params: { id: question, question: {body: 'new'}, user: wrong_user, format: :js }
          question.reload

          expect(question.body).to eq 'MyText'
        end
      end
    end

  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, user: user) }

    context 'Guest' do
      it 'tries to delete' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end
    end

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

    context 'Not question author' do
      user = User.create(email: 'wrong_user@test.com', password: '123456', password_confirmation: '123456')
      before { login(user) }

      it 'not delete the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end
    end

  end

  it_behaves_like 'voted_spec' do
    let(:user) { create(:user) }
    let(:wrong_user) { create(:user) }
    let(:resource) { create(:question, user: user) }
  end

end
