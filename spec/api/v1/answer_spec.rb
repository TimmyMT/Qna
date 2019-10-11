require 'rails_helper'

describe 'Answer API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => 'application/json' } }

  describe 'GET /api/v1/answers/{id}' do

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/answers/1' }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token) }
      let!(:question) { create(:question, user: user) }
      let!(:answer) { create(:answer, :with_attachment, question: question, user: user) }
      let!(:comment) { create(:comment, commentable: answer, user: user) }
      let!(:link) { create(:link, linkable: answer) }
      let(:answer_response) { json['answer'] }

      before do
        get "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(json['answer'][attr]).to eq answer.send(attr).as_json
        end
      end

      it 'contains question object' do
        expect(answer_response['question']['id']).to eq answer.question_id
      end

      it 'contains user object' do
        expect(answer_response['user']['id']).to eq answer.user_id
      end

      it 'contains comments' do
        comments = answer_response['comments']
        expect(comments.count).to eq answer.comments.count

        %w[id body].each do |attr|
          expect(comments.first[attr]).to eq answer.comments.first.send(attr).as_json
        end
      end

      it 'contains links' do
        links = answer_response['links']
        expect(links.count).to eq answer.links.count

        %w[id name url].each do |attr|
          expect(links.first[attr]).to eq answer.links.first.send(attr).as_json
        end
      end

      it 'contains links for attached files' do
        files = answer_response['url_files']
        expect(files.count).to eq answer.url_files.count

        files.each_with_index do |file, index|
          expect(file.url).to eq answer.url_files[index].url
        end
      end
    end

  end

  describe 'POST /api/v1/question/{question_id}/answers/' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let(:access_token) { create(:access_token) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        post "/api/v1/questions/#{question.id}/answers", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        post "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      it 'returns 201, and redirect to answer' do
        expect do
          post "/api/v1/questions/#{question.id}/answers/", params: { answer: attributes_for(:answer),
                                                                      question_id: question.id,
                                                                      access_token: access_token.token}
        end.to change(Answer, :count).by(1)

        expect(response).to have_http_status :created
        expect(response.headers['Location']).to eq api_v1_answer_url(Answer.last)
      end

      it 'not valid answer' do
        expect do
          post "/api/v1/questions/#{question.id}/answers/", params: { answer: { body: '' },
                                                                      question_id: question.id,
                                                                      access_token: access_token.token}
        end.to_not change(Answer, :count)

        expect(response).to have_http_status :bad_request
      end
    end
  end

end
