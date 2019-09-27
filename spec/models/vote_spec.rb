require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:votable) }
  it { should belong_to(:user) }

  # it { should validate_uniqueness_of(:user_id).scoped_to(:votable_id, :votable_type) }
  #
  # describe "custom validate of author" do
  #   let!(:user) { create(:user) }
  #   let!(:question) { create(:question, user: user) }
  #
  #   it 'validates author cant vote' do
  #     @vote = question.votes.new(value: 1, user: user)
  #     @vote.valid?
  #     @vote.errors[:user].should eq ["Author can't vote"]
  #   end
  # end

end
