require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'Facebook' do
    before do
      request.env['omniauth.auth'] = mock_auth_hash(:facebook, 'test_user@test.com')
      get :facebook
    end

    it 'redirects to root path' do
      expect(response).to redirect_to root_path
    end

    it 'return user' do
      expect(controller.current_user).to be_a User
    end
  end

  describe 'Github' do
    before do
      request.env['omniauth.auth'] = mock_auth_hash(:github, 'test_user@test.com')
      get :github
    end

    it 'redirects to root path' do
      expect(response).to redirect_to root_path
    end

    it 'return user' do
      expect(controller.current_user).to be_a User
    end
  end
end
