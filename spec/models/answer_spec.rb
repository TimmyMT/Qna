require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should have_many(:links).dependent(:destroy) }
  it { should validate_presence_of(:body) }
  it { should have_many(:votes).dependent(:destroy) }

  it { should accept_nested_attributes_for :links }

  describe 'model methods' do
    let!(:user) { create(:user) }
    let!(:wrong_user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:achievement) { create(:achievement, question: question) }
    let!(:best_answer) { create(:answer, question: question, user: user, best: true) }

    context 'vote_ actions' do
      it 'vote_up' do
        answer.vote_up(wrong_user)
        expect(answer.votes.last.user).to eq wrong_user
        expect(answer.votes.last.value).to eq 1
      end

      it 'vote_down' do
        answer.vote_down(wrong_user)
        expect(answer.votes.last.user).to eq wrong_user
        expect(answer.votes.last.value).to eq -1
      end

      it 'vote_clear' do
        answer.votes.create!(user: wrong_user, value: 1)
        expect(answer.votes.last.user).to eq wrong_user
        expect(answer.votes.last.value).to eq 1

        answer.vote_clear(wrong_user)
        expect(answer.votes.where(user: wrong_user)).to eq []
      end

      it 'author cant vote' do
        @vote = answer.votes.new(user: user, value: 1)

        expect(@vote.valid?).to be_falsey
        expect(@vote.errors[:user]).to eq ["Author can't vote"]
      end
    end

    context 'swith best' do
      it 'have many attached files' do
        expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
      end

      it 'user taked achievement for best answer' do
        answer.switch_best

        expect(user.achievements.last).to eq achievement
      end

      it 'check best attribute for new best answer' do
        answer.switch_best

        expect(answer).to be_best
      end

      it 'check best attribute for old best answer' do
        answer.switch_best
        best_answer.reload

        expect(best_answer).to_not be_best
      end
    end
  end

end
