require 'rails_helper'

shared_examples_for "subscribed" do

  before { sign_in(user) }

  describe 'POST #subscribe' do
    it 'the user subscribed to the resource' do
      expect{ post :subscribe, params: { id: resource } }.to change(resource.subscribers, :count).by(1)
    end
  end

  describe 'DELETE #unsubscribe' do
    it 'the user unsubscribed to the resource' do
      post :subscribe, params: { id: resource }
      expect{ delete :unsubscribe, params: { id: resource } }.to change(resource.subscribers, :count).by(-1)
    end
  end
end
