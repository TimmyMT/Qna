require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:votable) }
  it { should belong_to(:user) }

  describe "uniqueness validate" do
    let!(:user) { create(:user) }
    let!(:wrong_user) { create(:user) }
    let!(:question) { create(:question, user: user) }

    it 'user cant vote double once' do
      @vote = question.votes.create(value: 1, user: wrong_user)
      expect(question.votes.last).to eq @vote
      @vote = question.votes.create(value: 1, user: wrong_user)
      @vote.valid?
      @vote.errors.full_messages.should eq ["User has already been taken"]
    end
  end

  describe "custom validate of author" do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }

    it 'validates author cant vote' do
      @vote = question.votes.new(value: 1, user: user)
      @vote.valid?
      @vote.errors[:user].should eq ["Author can't vote"]
    end
  end

end
