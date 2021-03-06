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

    it_behaves_like 'API Authorizable json format' do
      let!(:method) { :post }
      let!(:api_path) { "/api/v1/questions/#{question.id}/answers" }
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

        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end

  describe 'PATCH /api/v1/questions/{id}' do
    let!(:access_token) { create(:access_token) }
    let!(:question) { create(:question, user_id: access_token.resource_owner_id) }
    let!(:answer) { create(:answer, question: question, user_id: access_token.resource_owner_id) }

    it_behaves_like 'API Authorizable json format' do
      let!(:method) { :patch }
      let!(:api_path) { "/api/v1/answers/#{answer.id}" }
    end

    context 'authorized' do
      it 'return 201 status when question successfully updated' do
        expect do
          patch "/api/v1/answers/#{answer.id}", params: { answer: { body: 'Updated text'},
                                                              access_token: access_token.token }
        end.to_not change(Answer, :count)

        answer.reload
        expect(response).to have_http_status :ok
        expect(answer.body).to eq 'Updated text'
      end

      it 'not valid answer' do
        before_body = answer.body
        patch "/api/v1/answers/#{answer.id}", params: { answer: { body: '' },
                                                            access_token: access_token.token }
        answer.reload
        expect(response).to have_http_status :unprocessable_entity
        expect(answer.body).to eq before_body
      end
    end
  end

  describe 'DELETE /api/v1/answers/{id}' do
    let!(:access_token) { create(:access_token) }
    let!(:question) { create(:question, user_id: access_token.resource_owner_id) }
    let!(:answer) { create(:answer, question: question, user_id: access_token.resource_owner_id) }

    it_behaves_like 'API Authorizable json format' do
      let!(:method) { :delete }
      let!(:api_path) { "/api/v1/answers/#{answer.id}" }
    end

    context 'authorized' do
      it 'deletes answer' do
        expect do
          delete "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token }
        end.to change(Answer, :count).by(-1)
        expect(response).to have_http_status :ok
      end
    end
  end

end
