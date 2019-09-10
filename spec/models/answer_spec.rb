require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:body) }

  describe 'switch_best' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:best_answer) { create(:answer, question: question, user: user, best: true) }


    it 'check best attribute for new best answer' do
      answer.switch_best
      answer.reload

      expect(answer).to be_best
    end

    it 'check best attribute for old best answer' do
      answer.switch_best
      best_answer.reload

      expect(best_answer).to_not be_best
    end
  end
end
