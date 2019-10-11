require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => 'application/json' } }

  let(:user) { create(:user) }

  describe 'GET /api/v1/questions' do
    let(:method) { :get }
    let(:api_path) { '/api/v1/questions' }
    it_behaves_like 'API Authorizable'

    context 'authorized' do

      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2, user: user) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question, user: user) }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %W[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answers_response) { question_response['answers'] }

        it 'returns list of answers' do
          expect(answers_response.size).to eq 3
        end

        it 'returns all public fields' do
          %W[id body user_id created_at updated_at].each do |attr|
            expect(answers_response.first[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/{id}' do
    let(:method) { :get }
    let(:api_path) { '/api/v1/questions/1' }
    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:question) { create(:question, :with_attachment, user: user) }
      let!(:link) { create(:link, linkable: question) }
      let!(:comment) { create(:comment, commentable: question, user: user) }
      let(:question_response) { json['question'] }

      before do
        get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'contains links' do
        links = question_response['links']
        expect(links.count).to eq question.links.count

        %w[id name url].each do |attr|
          expect(links.first[attr]).to eq question.links.first.send(attr.as_json)
        end
      end

      it 'contains links for attached files' do
        files = question_response['url_files']
        expect(files.count).to eq question.url_files.count

        files.each_with_index do |file, index|
          expect(file.url).to eq question.url_files[index].url
        end
      end

      it 'contains comments' do
        comments = question_response['comments']
        expect(comments.count).to eq question.comments.count

        %w[id body].each do |attr|
          expect(comments.first[attr]).to eq question.comments.first.send(attr).as_json
        end
      end

      it 'contains author object' do
        expect(question_response['user']['id']).to eq question.user_id
      end
    end
  end

  describe 'POST /api/v1/questions/' do
    let(:access_token) { create(:access_token) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        post "/api/v1/questions/", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        post "/api/v1/questions/", params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      it 'return 201 status' do
        expect do
          post "/api/v1/questions/", params: { question: attributes_for(:question),
                                               access_token: access_token.token }
        end.to change(Question, :count).by(1)

        expect(response).to have_http_status :created
        expect(response.headers['Location']).to eq api_v1_question_url(Question.last)
      end

      it 'not valid question' do
        expect do
          post "/api/v1/questions/", params: { question: { body: '' },
                                               access_token: access_token.token }
        end.to_not change(Question, :count)

        expect(response).to have_http_status :bad_request
      end
    end
  end
end
