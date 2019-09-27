shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  describe 'vote_ actions' do
    it 'vote_up' do
      resource.vote_up(wrong_user)
      expect(resource.votes.last.user).to eq wrong_user
      expect(resource.votes.last.value).to eq 1
    end

    it 'vote_down' do
      resource.vote_down(wrong_user)
      expect(resource.votes.last.user).to eq wrong_user
      expect(resource.votes.last.value).to eq -1
    end

    it 'vote_clear' do
      resource.votes.create!(user: wrong_user, value: 1)
      expect(resource.votes.last.user).to eq wrong_user
      expect(resource.votes.last.value).to eq 1

      resource.vote_clear(wrong_user)
      expect(resource.votes.where(user: wrong_user)).to eq []
    end

    it 'user cant vote double' do
      @vote = resource.votes.create(user: wrong_user, value: 1)
      expect(resource.votes.last).to eq @vote
      @double_vote = resource.votes.new(user: wrong_user, value: -1)

      expect(@double_vote.valid?).to be_falsey
      expect(@double_vote.errors[:user_id]).to eq ["has already been taken"]
    end

    it 'author cant vote' do
      @vote = resource.votes.new(user: user, value: 1)

      expect(@vote.valid?).to be_falsey
      expect(@vote.errors[:user]).to eq ["Author can't vote"]
    end
  end
end
