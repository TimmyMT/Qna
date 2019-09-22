require 'rails_helper'

RSpec.describe RatingsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:wrong_user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  context 'wrong user' do
    before do
      sign_in(wrong_user)
    end

    it 'up rating of object' do
      expect(question.rating.value).to eq 0
      patch :up, params: {id: question.rating, format: :json}
      question.reload

      expect(question.rating.value).to eq 1
    end

    it 'down rating of object' do
      expect(question.rating.value).to eq 0
      patch :down, params: {id: question.rating, format: :json}
      question.reload

      expect(question.rating.value).to eq -1
    end

    it 'clear vote rating of object' do
      @rating = question.rating
      @rating.update(value: 1, votes: {wrong_user.id => '+'})

      expect(question.rating.value).to eq 1

      patch :clear_vote_from, params: {id: question.rating, format: :json}
      question.reload

      expect(question.rating.value).to eq 0
      expect(question.rating.votes[wrong_user.id]).to eq nil
    end
  end

  context 'author of object' do
    before do
      sign_in(user)
    end

    it 'up rating of object' do
      expect(question.rating.value).to eq 0
      patch :up, params: {id: question.rating, format: :json}
      question.reload

      expect(question.rating.value).to eq 0
    end

    it 'down rating of object' do
      expect(question.rating.value).to eq 0
      patch :down, params: {id: question.rating, format: :json}
      question.reload

      expect(question.rating.value).to eq 0
    end

    it 'clear vote rating of object' do
      @rating = question.rating
      @rating.update(value: 1, votes: {wrong_user.id => '+'})
      expect(question.rating.value).to eq 1

      patch :clear_vote_from, params: {id: question.rating, format: :json}
      question.reload

      expect(question.rating.value).to eq 1
      expect(question.rating.votes).to eq({wrong_user.id => '+'})
    end
  end

  context 'guest' do
    it 'up rating of object' do
      expect(question.rating.value).to eq 0
      patch :up, params: {id: question.rating, format: :json}
      question.reload

      expect(question.rating.value).to eq 0
    end

    it 'down rating of object' do
      expect(question.rating.value).to eq 0
      patch :down, params: {id: question.rating, format: :json}
      question.reload

      expect(question.rating.value).to eq 0
    end

    it 'clear vote rating of object' do
      @rating = question.rating
      @rating.update(value: 1, votes: {wrong_user.id => '+'})
      expect(question.rating.value).to eq 1

      patch :clear_vote_from, params: {id: question.rating, format: :json}
      question.reload

      expect(question.rating.value).to eq 1
      expect(question.rating.votes).to eq({wrong_user.id => '+'})
    end
  end

end
