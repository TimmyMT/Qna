require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:achievements) }
  it { should have_many(:votes) }
  it { should have_many(:authorizations).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('Services::FindForOauth') }

    it 'calls Services::FindForOauth' do
      expect(Services::FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end

    it 'create autorization' do
      before_count = user.authorizations.count
      user.create_authorization!(auth)
      expect(user.authorizations.count).to_not eq before_count
      expect(user.authorizations.last.provider).to eq auth.provider
      expect(user.authorizations.last.uid).to eq auth.uid
    end
  end

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
