require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:achievement).dependent(:nullify) }
  it { should belong_to(:user) }


  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :achievement }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it_behaves_like 'votable' do
    let(:user) { create(:user) }
    let(:wrong_user) { create(:user) }
    let(:resource) { create(:question, user: user) }
  end

  describe 'Creator of question' do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }

    it 'already subscribed for his question' do
      before_sub = Subscription.count
      question = Question.create(user: user, title: 'new', body: 'new')

      expect(Subscription.count).to be > before_sub

      expect(question.subscribed?(user)).to be_truthy
      expect(question.subscribed?(other_user)).to be_falsey
    end
  end

end
