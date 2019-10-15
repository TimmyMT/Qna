require 'rails_helper'

RSpec.describe DailyMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let!(:question) { create(:question, user: other_user) }
    let(:mail) { DailyMailer.digest(user) }

    it 'renders the headers' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match("Hello")

      Question.where('created_at < ?', 1.day.ago).each do |question|
        expect(mail.body.encoded).to_not match(question.title)
      end
    end
  end
end
