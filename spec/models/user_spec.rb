require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:achievements) }
  it { should have_many(:votes) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'Check instance method for author of object' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:wrong_user) { create(:user) }

    it 'return true for author input:resource' do
      expect(user).to be_creator(question)
      # expect(user.creator?(question)).to be_truthy
    end

    it 'return false for not author input:resource' do
      expect(wrong_user).to_not be_creator(question)
      # expect(wrong_user.creator?(question)).to be_falsey
    end
  end
end
