require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:achievement).dependent(:nullify) }
  it { should belong_to(:user) }
  it { should have_many(:votes).dependent(:destroy) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :achievement }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'model methods' do
    let!(:user) { create(:user) }
    let!(:wrong_user) { create(:user) }
    let!(:question) { create(:question, user: user) }

    context 'vote_ actions' do
      it 'vote_up' do
        question.vote_up(wrong_user)
        expect(question.votes.last.user).to eq wrong_user
        expect(question.votes.last.value).to eq 1
      end

      it 'vote_down' do
        question.vote_down(wrong_user)
        expect(question.votes.last.user).to eq wrong_user
        expect(question.votes.last.value).to eq -1
      end

      it 'vote_clear' do
        question.votes.create!(user: wrong_user, value: 1)
        expect(question.votes.last.user).to eq wrong_user
        expect(question.votes.last.value).to eq 1

        question.vote_clear(wrong_user)
        expect(question.votes.where(user: wrong_user)).to eq []
      end
    end
  end
end
