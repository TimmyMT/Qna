require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe "GET #index" do
    let!(:questions) { create_list(:question, 3) }

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
    before { get :new }

    it 'renders new view' do
      expect(response).to render_template(:new)
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: question } }

    it 'renders edit view' do
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: {question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirect to show view' do
        post :create, params: {question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: {question: attributes_for(:question, :invalid_question) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: {question: attributes_for(:question, :invalid_question) }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do
    before { get :edit, params: { id: question } }
    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: {title: 'new', body: 'new'} }
        question.reload

        expect(question.title).to eq 'new'
        expect(question.body).to eq 'new'
      end

      it 'redirects to updated attributes' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid_question) } }

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

  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }

    it 'deletes the question' do
      question
      expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end

    it 'redirects to index' do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to questions_path
    end
  end

end
