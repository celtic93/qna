require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json',
                    'ACCEPT' => 'application/json' } }
  let(:question) { create(:question) }

  describe 'GET api/v1/questions/:id/answers' do
    it_behaves_like 'API authorizable' do
      let(:method) { :get }
      let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer) { answers.first }
      let(:answer_response) { json['answers'].first }

      before { get "/api/v1/questions/#{question.id}/answers",
               params: { access_token: access_token.token },
               headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 2
      end

      it 'returns all public fields' do
        %w(id body question_id created_at updated_at best).each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(answer_response['user']['id']).to eq answer.user.id
      end
    end
  end

  describe 'GET api/v1/answers/:id' do
    let!(:answer) { create(:answer, :with_file) }
    let!(:comments) { create_list(:comment, 2, commentable: answer) }
    let!(:links) { create_list(:link, 2, linkable: answer) }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answer'] }

      before { get "/api/v1/answers/#{answer.id}",
               params: { access_token: access_token.token },
               headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w(id body user_id question_id created_at updated_at best).each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      describe 'comments' do
        let(:comment) { comments.first }
        let(:comment_response) { answer_response['comments'].first }

        it 'returns list of comments' do
          expect(answer_response['comments'].size).to eq 2
        end

        it 'returns all public fields' do
          %w(id body user_id commentable_type commentable_id created_at updated_at).each do |attr|
            expect(comment_response[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      describe 'files' do
        let(:file) { answer.files.first }
        let(:file_response) { answer_response['files'].first }

        it 'returns list of files' do
          expect(answer_response['files'].size).to eq answer.files.count
        end

        it 'returns all public fields' do
          expect(file_response['id']).to eq file.id
          expect(file_response['name']).to eq file.filename.to_s
          expect(file_response['url']).to eq rails_blob_path(file, only_path: true)
        end
      end

      describe 'links' do
        let(:link) { links.last }
        let(:link_response) { answer_response['links'].first }

        it 'returns list of links' do
          expect(answer_response['links'].size).to eq 2
        end

        it 'returns all public fields' do
          %w(id name url linkable_type linkable_id created_at updated_at).each do |attr|
            expect(link_response[attr]).to eq link.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'POST api/v1/questions/:id/answers' do
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let!(:question) { create(:question) }

    it_behaves_like 'API authorizable' do
      let(:method) { :post }
      let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      context 'with valid attributes' do
        let(:do_request) { post "/api/v1/questions/#{question.id}/answers",
                           headers: headers, 
                           params: { access_token: access_token.token,
                                     answer: { body: 'Body through API' } } }

        it 'saves a new answer in database' do
          expect { do_request }.to change(question.answers, :count).by(1)
        end

        it 'returns question with right attributes' do
          do_request
          expect(json['answer']['body']).to eq 'Body through API'
        end

        it 'returns all public fields' do
          do_request

          %w(id body user_id question_id created_at updated_at best).each do |attr|
            expect(json['answer']).to have_key(attr)
          end
        end

        it 'returns 200 status' do
          do_request
          expect(response).to be_successful
        end
      end

      context 'with invalid attributes' do
        let(:do_request) { post "/api/v1/questions/#{question.id}/answers",
                           headers: headers, 
                           params: { access_token: access_token.token,
                                     answer: attributes_for(:answer, :invalid) } }
                                     
        it 'does not saves a new answer in database' do
          expect { do_request }.to_not change(question.answers, :count)
        end

        it 'returns 422 status' do
          do_request
          expect(response.status).to eq 422
        end
      end
    end
  end

  describe 'PATCH api/v1/answers/:id' do
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:author) { create(:user) }
    let(:answer) { create(:answer, user: author) }

    it_behaves_like 'API authorizable' do
      let(:method) { :patch }
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: author.id) }

      context 'with valid attributes' do
        before { patch "/api/v1/answers/#{answer.id}",
                 headers: headers, 
                 params: { access_token: access_token.token,
                 answer: { body: 'New body through API' } } }

        it 'assigns the requested answer to @answer' do
          expect(assigns(:answer)).to eq answer
        end

        it 'changes answer attributes' do
          answer.reload
          expect(answer.body).to eq 'New body through API'
        end

        it 'returns answer with updated attributes' do
          expect(json['answer']['body']).to eq 'New body through API'
        end

        it 'returns all public fields' do
          answer.reload

          %w(id body user_id question_id created_at updated_at best).each do |attr|
            expect(json['answer'][attr]).to eq answer.send(attr).as_json
          end
        end

        it 'returns successful status' do
          expect(response).to be_successful
        end
      end

      context 'with invalid attributes' do
        before { patch "/api/v1/answers/#{answer.id}",
                 headers: headers, 
                 params: { access_token: access_token.token,
                 answer: attributes_for(:answer, :invalid) } }

        it 'assigns the requested answer to @answer' do
          expect(assigns(:answer)).to eq answer
        end

        it 'does not changes answer attributes' do
          answer.reload
          expect(answer.body).to eq answer.body
        end

        it 'returns answer errors' do
          expect(json['errors']['body'].first).to eq "can't be blank"
        end

        it 'returns 422 status' do
          expect(response.status).to eq 422
        end
      end

      context 'for not the author of the answer' do
        let(:other_access_token) { create(:access_token) }

        before { patch "/api/v1/answers/#{answer.id}",
                 headers: headers, 
                 params: { access_token: access_token.token,
                 answer: { body: 'New body through API' } } }

        it 'does not changes answer attributes' do
          answer.reload
          expect(answer.body).to eq answer.body
        end

        it 'returns successful status' do
          expect(response).to be_successful
        end
      end
    end
  end

  describe 'DELETE api/v1/answers/:id' do
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:author) { create(:user) }
    let!(:answer) { create(:answer, user: author) }

    it_behaves_like 'API authorizable' do
      let(:method) { :delete }
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: author.id) }

      context 'for the author of the answer' do
        let(:do_request) { delete "/api/v1/answers/#{answer.id}",
                           headers: headers, 
                           params: { access_token: access_token.token } }

        it 'assigns the requested answer to @answer' do
          do_request
          expect(assigns(:answer)).to eq answer
        end

        it 'deletes the answer from database' do
          expect { do_request }.to change(Answer, :count).by(-1)
        end

        it 'returns 200 status' do
          do_request
          expect(response).to be_successful
        end
      end

      context 'for not the author of the answer' do
        let(:other_access_token) { create(:access_token) }

        let(:do_request) { delete "/api/v1/answers/#{answer.id}",
                           headers: headers, 
                           params: { access_token: other_access_token.token } }

        it 'assigns the requested answer to @answer' do
          do_request
          expect(assigns(:answer)).to eq answer
        end

        it 'does not deletes the answer from database' do
          expect { do_request }.to_not change(Answer, :count)
        end

        it 'returns unsuccessful status' do
          do_request
          expect(response).to_not be_successful
        end
      end
    end
  end
end
