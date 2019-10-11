shared_examples_for 'API Authorizable json format' do
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      do_request(method, api_path, params: { format: :json })
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      do_request(method, api_path, params: { format: :json, access_token: '1234' })
      expect(response.status).to eq 401
    end
  end
end
