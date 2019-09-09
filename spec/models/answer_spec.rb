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

    it 'update best attribute of answer' do
      answer.switch_best
      answer.reload
      best_answer.reload

      expect(answer.best).to be_truthy
      expect(best_answer.best).to be_falsey
    end
  end
end
