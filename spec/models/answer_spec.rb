require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should have_many(:links).dependent(:destroy) }
  it { should validate_presence_of(:body) }
  it { should have_many(:votes).dependent(:destroy) }

  it { should accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'model methods' do
    let!(:user) { create(:user) }
    let!(:wrong_user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:achievement) { create(:achievement, question: question) }
    let!(:best_answer) { create(:answer, question: question, user: user, best: true) }

    context 'swith best' do
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

  it_behaves_like 'votable' do
    let(:user) { create(:user) }
    let(:wrong_user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:resource) { create(:answer, question: question, user: user) }
  end
end
