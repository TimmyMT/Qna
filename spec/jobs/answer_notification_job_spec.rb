require 'rails_helper'

RSpec.describe AnswerNotificationJob, type: :job do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  it 'sends answer' do
    expect(AnswerNotificationMailer).to receive(:notify).with(user, answer).and_call_original
    AnswerNotificationJob.perform_now(answer)
  end
end
