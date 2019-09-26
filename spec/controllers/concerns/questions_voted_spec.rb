require 'rails_helper'

RSpec.describe Voted, type: :controller do
  controller AnswersController do
    include Voted
  end

  before do
    routes.draw do
      post 'vote_up_answer' => 'answers#vote_up'
      post 'vote_down_answer' => 'answers#vote_down'
      post 'vote_clear_answer' => 'answers#vote_clear'
    end
  end

  describe "POST #vote" do
    let(:user) { create(:user) }
    let(:wrong_user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }

    context "Not author" do
      before { sign_in(wrong_user) }

      it 'user can vote up for answer' do
        expect { post :vote_up, params: { id: answer.id } }.to change(answer.votes, :count).by(1)
        expect(answer.votes.last.value).to eq 1
      end

      it 'user can vote down for answer' do
        expect { post :vote_down, params: { id: answer.id } }.to change(answer.votes, :count).by(1)
        expect(answer.votes.last.value).to eq -1
      end

      it 'user can vote clear of answer' do
        @vote = answer.votes.create(value: 1, user: wrong_user)

        expect { post :vote_clear, params: { id: answer.id } }.to change(answer.votes, :count).by(-1)
        expect(answer.votes.count).to eq 0
      end
    end

    context "Author" do
      before { sign_in(user) }

      it 'user can vote up for answer' do
        expect { post :vote_up, params: { id: answer.id } }.to_not change(answer.votes, :count)
      end

      it 'user can vote down for answer' do
        expect { post :vote_down, params: { id: answer.id } }.to_not change(answer.votes, :count)
      end

      it 'user can vote clear of answer' do
        @vote = answer.votes.create(value: 1, user: wrong_user)

        expect { post :vote_clear, params: { id: answer.id } }.to_not change(answer.votes, :count)
      end
    end

    context "Guest" do
      it 'user can vote up for answer' do
        expect { post :vote_up, params: { id: answer.id } }.to_not change(answer.votes, :count)
      end

      it 'user can vote down for answer' do
        expect { post :vote_down, params: { id: answer.id } }.to_not change(answer.votes, :count)
      end

      it 'user can vote clear of answer' do
        @vote = answer.votes.create(value: 1, user: wrong_user)

        expect { post :vote_clear, params: { id: answer.id } }.to_not change(answer.votes, :count)
      end
    end
  end

end
