require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                      "ACCEPT" => 'application/json' } }

  describe 'GET /api/v1/profiles/me' do
    let(:method) { :get }
    let(:api_path) { '/api/v1/profiles/me' }
    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %W[id email admin created_at updated_at].each do |attr|
          expect(json[attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %W[password ecrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    let!(:me) { create(:user) }
    let!(:users) { create_list(:user, 2) }
    let!(:method) { :get }
    let!(:api_path) { '/api/v1/profiles' }
    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'return all users list without current_user' do
        expect(json.size).to eq 2

        json.each do |object|
          expect(object['email']).to_not eq me.email
        end
      end

      it 'returns all public fields' do
        %w[id email created_at updated_at].each do |attr|
          expect(json.first[attr]).to eq users.first.send(attr).as_json
        end
      end
    end
  end
end
