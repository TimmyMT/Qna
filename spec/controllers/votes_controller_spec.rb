require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:author) { create(:user) }
  let(:not_author) { create(:user) }
  let!(:question) { create(:question, user: author) }

  context "Not author of object" do
    before do
      sign_in(not_author)
    end

    it 'Not author can vote for object' do
      expect do
        post :give_vote, params: { klass_name_id: question.id, klass_name: question.class,
                                   user: not_author, value: 1}
      end.to change(Vote, :count).by(1)
    end

    it 'Not author can clear his vote of object' do
      @vote = question.votes.create(value: 1, user: not_author)
      expect(question.votes.count).to eq 1

      expect do
        delete :pick_up_vote, params: { votable_id: question.id }
      end.to change(Vote, :count).by(-1)
    end
  end

  context "Author of object" do
    before do
      sign_in(author)
    end

    it 'Not author can vote for object' do
      expect do
        post :give_vote, params: { klass_name_id: question.id, klass_name: question.class,
                                   user: author, value: 1}
      end.to_not change(Vote, :count)
    end

    it 'Not author can clear his vote of object' do
      @vote = question.votes.create(value: 1, user: not_author)
      expect(question.votes.count).to eq 1

      expect do
        delete :pick_up_vote, params: { votable_id: question.id }
      end.to_not change(Vote, :count)
    end
  end

  context "Guest" do
    it 'Not author can vote for object' do
      expect do
        post :give_vote, params: { klass_name_id: question.id, klass_name: question.class,
                                   user: not_author, value: 1}
      end.to_not change(Vote, :count)
    end

    it 'Not author can clear his vote of object' do
      @vote = question.votes.create(value: 1, user: not_author)
      expect(question.votes.count).to eq 1

      expect do
        delete :pick_up_vote, params: { votable_id: question.id }
      end.to_not change(Vote, :count)
    end
  end

end
