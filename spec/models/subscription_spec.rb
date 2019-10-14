require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:question) }

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  it 'uniqueness validate' do
    Subscription.create(user: user, question: question)
    @double_sub = Subscription.create(user: user, question: question)
    @double_sub.errors.full_messages.should eq ["User has already been taken"]
  end
end
