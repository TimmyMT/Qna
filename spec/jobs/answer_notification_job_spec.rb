require 'rails_helper'

RSpec.describe AnswerNotificationJob, type: :job do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let!(:users) { create_list(:user, 5) }

  it 'sends answer' do
    question.subscribers.delete(user)
    expect(AnswerNotificationMailer).to_not receive(:notify).with(user, answer).and_call_original

    users.each do |user|
      question.subscribers.push(user)
      expect(AnswerNotificationMailer).to receive(:notify).with(user, answer).and_call_original
    end

    AnswerNotificationJob.perform_now(answer)
  end
end
