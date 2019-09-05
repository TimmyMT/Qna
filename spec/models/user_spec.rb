require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'Check instance method for author of object' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:wrong_user) { create(:user) }

    it 'return true for author input:user' do
      expect(user.is_creator?(question.user)).to eq(true)
    end

    it 'return false for not author input:wrong_user' do
      expect(wrong_user.is_creator?(question.user)).to eq(false)
    end
  end
end
