require 'rails_helper'

RSpec.describe Rating, type: :model do
  it { should belong_to(:ratingable) }

  describe "changes rating" do
    let!(:user) { create(:user) }
    let!(:not_author) { create(:user) }
    let!(:question) { create(:question, user: user) }

    before do
      @rating = question.rating
    end

    context 'not author' do
      it 'rating up' do
        @rating.up(not_author)
        expect(@rating.value).to eq 1
      end

      it 'rating down' do
        @rating.down(not_author)
        expect(@rating.value).to eq -1
      end

      context 'clear vote' do
        it 'when rating < 0' do
          @rating.value = -1
          @rating.votes[not_author.id] = '-'
          @rating.clear_vote(not_author)
          expect(@rating.value).to eq 0
          expect(@rating.votes).to eq({})
        end

        it 'when rating > 0' do
          @rating.value = 1
          @rating.votes[not_author.id] = '+'
          @rating.clear_vote(not_author)
          expect(@rating.value).to eq 0
          expect(@rating.votes).to eq({})
        end
      end
    end

    context 'author' do
      it 'rating up' do
        @rating.up(user)
        expect(@rating.value).to eq 0
      end

      it 'rating down' do
        @rating.down(user)
        expect(@rating.value).to eq 0
      end

      context 'clear vote' do
        it 'when rating < 0' do
          @rating.value = -1
          @rating.votes[not_author.id] = '-'
          @rating.clear_vote(user)
          expect(@rating.value).to eq -1
          expect(@rating.votes).to eq({not_author.id => '-'})
        end

        it 'when rating > 0' do
          @rating.value = 1
          @rating.votes[not_author.id] = '+'
          @rating.clear_vote(user)
          expect(@rating.value).to eq 1
          expect(@rating.votes).to eq({not_author.id => '+'})
        end
      end
    end
  end
end
