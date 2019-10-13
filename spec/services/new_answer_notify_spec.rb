require 'rails_helper'

RSpec.describe Services::NewAnswerNotify do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: other_user) }

  it 'sends notify to answers question user' do
    expect(NewAnswerNotifyMailer).to receive(:notify_email).with(answer).and_call_original
    subject.send_notify(answer)
  end
end
