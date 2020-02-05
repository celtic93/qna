require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json',
                    'ACCEPT' => 'application/json' } }
  let(:question) { create(:question) }

  describe 'GET api/v1/questions/:id/answers' do
    let(:method) { :get }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:access_token) { create(:access_token) }
    let!(:resources) { create_list(:answer, 2, question: question) }
    let(:resource) { resources.first }
    let(:resources_response) { json['answers'] }
    let(:resource_response) { resources_response.first }
    let(:public_fields) { %w(id body question_id created_at updated_at best) }

    it_behaves_like 'API authorizable'
    it_behaves_like 'API resources list returnable'
  end

  describe 'GET api/v1/answers/:id' do
    let!(:resource) { create(:answer, :with_file) }
    let!(:comments) { create_list(:comment, 2, commentable: resource) }
    let!(:links) { create_list(:link, 2, linkable: resource) }
    let(:method) { :get }
    let(:api_path) { "/api/v1/answers/#{resource.id}" }
    let(:access_token) { create(:access_token) }
    let(:resource_response) { json['answer'] }
    let(:public_fields) { %w(id body user_id question_id created_at updated_at best) }

    it_behaves_like 'API authorizable'
    it_behaves_like 'API resource returnable'
  end

  describe 'POST api/v1/questions/:id/answers' do
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let!(:question) { create(:question) }
    let(:method) { :post }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:access_token) { create(:access_token) }
    let(:resource_params) { { body: 'Body through API' } }
    let(:do_valid_request) { post api_path,
                             headers: headers, 
                             params: { access_token: access_token.token,
                                       answer: resource_params } }
    let(:do_invalid_request) { post api_path,
                               headers: headers, 
                               params: { access_token: access_token.token,
                                         answer: attributes_for(:answer, :invalid) } }
    let(:resource_class) { question.answers }
    let(:resource_response) { json['answer'] }
    let(:public_fields) { %w(id body user_id question_id created_at updated_at best) }

    it_behaves_like 'API authorizable'
    it_behaves_like 'API resource creatable'
  end

  describe 'PATCH api/v1/answers/:id' do
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:author) { create(:user) }
    let(:resource) { create(:answer, user: author) }
    let(:method) { :patch }
    let(:api_path) { "/api/v1/answers/#{resource.id}" }
    let(:access_token) { create(:access_token, resource_owner_id: author.id) }
    let(:other_access_token) { create(:access_token) }
    let(:resource_params) { { body: 'New body through API' } }
    let(:resource_response) { json['answer'] }
    let(:public_fields) { %w(id body user_id question_id created_at updated_at best) }
    let(:do_valid_request) { patch api_path,
                             headers: headers, 
                             params: { access_token: access_token.token,
                             answer: resource_params } }
    let(:do_invalid_request) { patch api_path,
                               headers: headers, 
                               params: { access_token: access_token.token,
                               answer: attributes_for(:answer, :invalid) } }
    let(:do_not_author_request) { patch api_path,
                                  headers: headers, 
                                  params: { access_token: other_access_token.token,
                                  answer: resource_params } }

    it_behaves_like 'API authorizable'
    it_behaves_like 'API resource updatable'

    context 'authorized' do
      context 'with valid attributes' do
        it 'assigns the requested answer to @answer' do
          do_valid_request
          expect(assigns(:answer)).to eq resource
        end
      end

      context 'with invalid attributes' do
        before { do_invalid_request }

        it 'assigns the requested answer to @answer' do
          expect(assigns(:answer)).to eq resource
        end

        it 'returns answer errors' do
          expect(json['errors']['body'].first).to eq "can't be blank"
        end
      end
    end
  end

  describe 'DELETE api/v1/answers/:id' do
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:author) { create(:user) }
    let!(:resource) { create(:answer, user: author) }
    let(:method) { :delete }
    let(:api_path) { "/api/v1/answers/#{resource.id}" }
    let(:access_token) { create(:access_token, resource_owner_id: author.id) }
    let(:other_access_token) { create(:access_token) }
    let(:resource_class) { Answer }
    let(:do_valid_request) { delete api_path,
                             headers: headers, 
                             params: { access_token: access_token.token } }
    let(:do_not_author_request) { delete api_path,
                                  headers: headers, 
                                  params: { access_token: other_access_token.token } }

    it_behaves_like 'API authorizable'
    it_behaves_like 'API resource destroyable'

    context 'authorized' do
      context 'for the author of the answer' do
        it 'assigns the requested answer to @answer' do
          do_valid_request
          expect(assigns(:answer)).to eq resource
        end
      end

      context 'for not the author of the answer' do
        it 'assigns the requested answer to @answer' do
          do_not_author_request
          expect(assigns(:answer)).to eq resource
        end
      end
    end
  end
end
