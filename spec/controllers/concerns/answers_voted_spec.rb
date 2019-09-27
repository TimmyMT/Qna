require 'rails_helper'

RSpec.describe Voted, type: :controller do
  controller QuestionsController do
    include Voted
  end

  before do
    routes.draw do
      post 'vote_up_question' => 'questions#vote_up'
      post 'vote_down_question' => 'questions#vote_down'
      post 'vote_clear_question' => 'questions#vote_clear'
    end
  end

  describe "POST #vote" do
    let(:user) { create(:user) }
    let(:wrong_user) { create(:user) }
    let!(:question) { create(:question, user: user) }

    context "Not author" do
      before { sign_in(wrong_user) }

      it 'user can vote up for question' do
        expect { post :vote_up, params: { id: question.id } }.to change(question.votes, :count).by(1)
        expect(question.rating).to eq 1
      end

      it 'user can vote down for question' do
        expect { post :vote_down, params: { id: question.id } }.to change(question.votes, :count).by(1)
        expect(question.rating).to eq -1
      end

      it 'user can vote clear of question' do
        @vote = question.votes.create(value: 1, user: wrong_user)

        expect { post :vote_clear, params: { id: question.id } }.to change(question.votes, :count).by(-1)
        expect(question.votes.count).to eq 0
      end
    end

    context "Author" do
      before { sign_in(user) }

      it 'author cant vote up for question' do
        expect { post :vote_up, params: { id: question.id } }.to_not change(question.votes, :count)
      end

      it 'author cant vote down for question' do
        expect { post :vote_down, params: { id: question.id } }.to_not change(question.votes, :count)
      end

      it 'author cant vote clear of question' do
        @vote = question.votes.create(value: 1, user: wrong_user)

        expect { post :vote_clear, params: { id: question.id } }.to_not change(question.votes, :count)
      end
    end

    context "Guest" do
      it 'guest cant vote up for question' do
        expect { post :vote_up, params: { id: question.id } }.to_not change(question.votes, :count)
      end

      it 'guest cant vote down for question' do
        expect { post :vote_down, params: { id: question.id } }.to_not change(question.votes, :count)
      end

      it 'guest cant vote clear of question' do
        @vote = question.votes.create(value: 1, user: wrong_user)

        expect { post :vote_clear, params: { id: question.id } }.to_not change(question.votes, :count)
      end
    end
  end

end
