require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json',
                    'ACCEPT' => 'application/json' } }

  describe 'GET api/v1/questions' do
    it_behaves_like 'API authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/questions' }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 2, question: question) }

      before { get '/api/v1/questions', params: { access_token: access_token.token },
                                        headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w(id title body created_at updated_at).each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(10)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 2
        end

        it 'returns all public fields' do
          %w(id body user_id created_at updated_at best).each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET api/v1/questions/:id' do
    let!(:question) { create(:question, :with_file) }
    let!(:comments) { create_list(:comment, 2, commentable: question) }
    let!(:links) { create_list(:link, 2, linkable: question) }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
      let(:api_path) { "/api/v1/questions/#{question.id}" }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }

      before { get "/api/v1/questions/#{question.id}",
               params: { access_token: access_token.token },
               headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w(id title body created_at updated_at).each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      describe 'comments' do
        let(:comment) { comments.first }
        let(:comment_response) { question_response['comments'].first }

        it 'returns list of comments' do
          expect(question_response['comments'].size).to eq 2
        end

        it 'returns all public fields' do
          %w(id body user_id commentable_type commentable_id created_at updated_at).each do |attr|
            expect(comment_response[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      describe 'files' do
        let(:file) { question.files.first }
        let(:file_response) { question_response['files'].first }

        it 'returns list of files' do
          expect(question_response['files'].size).to eq question.files.count
        end

        it 'returns all public fields' do
          expect(file_response['id']).to eq file.id
          expect(file_response['name']).to eq file.filename.to_s
          expect(file_response['url']).to eq rails_blob_path(file, only_path: true)
        end
      end

      describe 'links' do
        let(:link) { links.last }
        let(:link_response) { question_response['links'].first }

        it 'returns list of links' do
          expect(question_response['links'].size).to eq 2
        end

        it 'returns all public fields' do
          %w(id name url linkable_type linkable_id created_at updated_at).each do |attr|
            expect(link_response[attr]).to eq link.send(attr).as_json
          end
        end
      end
    end
  end
end
