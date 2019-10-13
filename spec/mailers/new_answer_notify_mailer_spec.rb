require 'rails_helper'

RSpec.describe  NewAnswerNotifyMailer, type: :mailer do
  describe "notify" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: other_user) }
    let(:mail) { NewAnswerNotifyMailer.notify_email(answer) }
    
    it 'renders the headers' do
      expect(mail.subject).to eq("Notify email")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end
    
    it 'renders the body' do
      expect(mail.body.encoded).to match("Hi")
    end
  end
end
