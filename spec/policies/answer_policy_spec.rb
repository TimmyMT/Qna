require 'rails_helper'

RSpec.describe AnswerPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:other_user) { create(:user, admin: true) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: other_user) }

  subject { described_class }

  permissions :update? do
    it 'grants access if user is admin' do
      expect(subject).to permit(other_user, answer)
    end
  end
end
