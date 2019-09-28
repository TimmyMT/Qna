shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  describe 'vote_ actions' do
    it 'vote_up' do
      resource.vote_up(wrong_user)
      expect(resource.votes.last.user).to eq wrong_user
      expect(resource.votes.last.value).to eq 1
      expect(resource.rating).to eq resource.votes.last.value
    end

    it 'vote_down' do
      resource.vote_down(wrong_user)
      expect(resource.votes.last.user).to eq wrong_user
      expect(resource.votes.last.value).to eq -1
      expect(resource.rating).to eq resource.votes.last.value
    end

    it 'vote_clear' do
      resource.votes.create!(user: wrong_user, value: 1)
      expect(resource.votes.last.user).to eq wrong_user
      expect(resource.votes.last.value).to eq 1
      expect(resource.rating).to eq resource.votes.last.value

      resource.vote_clear(wrong_user)
      expect(resource.votes.where(user: wrong_user)).to eq []
      expect(resource.rating).to eq 0
    end

    it 'user cant vote double' do
      resource.vote_up(wrong_user)
      expect(resource.rating).to eq 1
      current_rating = resource.rating

      expect do
        resource.vote_down(wrong_user)
      end.to raise_error(ActiveRecord::RecordInvalid,'Validation failed: User has already been taken')

      expect(resource.rating).to eq current_rating
    end

    it 'author cant vote' do
      current_rating = resource.rating

      expect do
        resource.vote_up(user)
      end.to raise_error(ActiveRecord::RecordInvalid,"Validation failed: User Author can't vote")

      expect(resource.rating).to eq current_rating
    end
  end
end
