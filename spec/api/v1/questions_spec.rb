require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => 'application/json' } }
  describe 'GET /api/v1/questions' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/questions', params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2, user: user) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question, user: user) }

      before do
        get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers
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
end
