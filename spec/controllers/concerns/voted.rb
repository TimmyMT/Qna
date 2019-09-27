require 'rails_helper'

shared_examples_for 'voted_spec' do

  describe "POST #vote" do
    context "Not author" do
      before { sign_in(wrong_user) }

      it 'user can vote up for resource' do
        expect { post :vote_up, params: { id: resource.id } }.to change(resource.votes, :count).by(1)
        expect(resource.rating).to eq 1
      end

      it 'user can vote down for resource' do
        expect { post :vote_down, params: { id: resource.id } }.to change(resource.votes, :count).by(1)
        expect(resource.rating).to eq -1
      end

      it 'user can vote clear of resource' do
        @vote = resource.votes.create(value: 1, user: wrong_user)

        expect { post :vote_clear, params: { id: resource.id } }.to change(resource.votes, :count).by(-1)
        expect(resource.votes.count).to eq 0
      end
    end

    context "Author" do
      before { sign_in(user) }

      it 'author cant vote up for resource' do
        expect { post :vote_up, params: { id: resource.id } }.to_not change(resource.votes, :count)
      end

      it 'author cant vote down for resource' do
        expect { post :vote_down, params: { id: resource.id } }.to_not change(resource.votes, :count)
      end

      it 'author cant vote clear of resource' do
        @vote = resource.votes.create(value: 1, user: wrong_user)

        expect { post :vote_clear, params: { id: resource.id } }.to_not change(resource.votes, :count)
      end
    end

    context "Guest" do
      it 'guest cant vote up for resource' do
        expect { post :vote_up, params: { id: resource.id } }.to_not change(resource.votes, :count)
      end

      it 'guest cant vote down for resource' do
        expect { post :vote_down, params: { id: resource.id } }.to_not change(resource.votes, :count)
      end

      it 'guest cant vote clear of resource' do
        @vote = resource.votes.create(value: 1, user: wrong_user)

        expect { post :vote_clear, params: { id: resource.id } }.to_not change(resource.votes, :count)
      end
    end
  end
end
