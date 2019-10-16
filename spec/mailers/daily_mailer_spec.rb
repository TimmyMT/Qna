require 'rails_helper'

RSpec.describe DailyMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let!(:question) { create(:question, user: other_user) }
    let!(:old_question) { create(:question,
                                title: 'old question',
                                user: other_user,
                                created_at: 2.days.ago) }
    let(:mail) { DailyMailer.digest(user) }

    it 'renders the headers' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match("Hello")

      expect(mail.body.encoded).to_not match(old_question.title)
      expect(mail.body.encoded).to match(question.title)
    end
  end
end
