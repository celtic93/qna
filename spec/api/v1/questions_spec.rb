require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json',
                    'ACCEPT' => 'application/json' } }

  describe 'GET api/v1/questions' do
    let(:method) { :get }
    let(:api_path) { '/api/v1/questions' }
    let(:resources_response) { json['questions'] }
    let(:resource_response) { resources_response.first }
    let(:access_token) { create(:access_token) }
    let!(:resources) { create_list(:question, 2) }
    let(:resource) { resources.first }
    let(:public_fields) { %w(id title body created_at updated_at) }

    it_behaves_like 'API authorizable'
    it_behaves_like 'API resources list returnable'

    context 'authorized' do
      let!(:answers) { create_list(:answer, 2, question: resource) }

      before { get api_path, params: { access_token: access_token.token },
                             headers: headers }

      it 'contains short title' do
        expect(resource_response['short_title']).to eq resource.title.truncate(10)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { resource_response['answers'].first }

        it 'returns list of answers' do
          expect(resource_response['answers'].size).to eq 2
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
    let!(:resource) { create(:question, :with_file) }
    let!(:comments) { create_list(:comment, 2, commentable: resource) }
    let!(:links) { create_list(:link, 2, linkable: resource) }
    let(:method) { :get }
    let(:api_path) { "/api/v1/questions/#{resource.id}" }
    let(:access_token) { create(:access_token) }
    let(:resource_response) { json['question'] }
    let(:public_fields) { %w(id title body created_at updated_at) }

    it_behaves_like 'API authorizable'
    it_behaves_like 'API resource returnable'
  end

  describe 'POST api/v1/questions' do
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:method) { :post }
    let(:api_path) { '/api/v1/questions' }
    let(:access_token) { create(:access_token) }
    let(:resource_params) { { title: 'Title through API', body: 'Body through API' } }
    let(:do_valid_request) { post api_path,
                             headers: headers, 
                             params: { access_token: access_token.token,
                                       question: resource_params } }
    let(:do_invalid_request) { post api_path,
                               headers: headers, 
                               params: { access_token: access_token.token,
                                         question: attributes_for(:question, :invalid) } }
    let(:resource_class) { Question }
    let(:resource_response) { json['question'] }
    let(:public_fields) { %w(id title body created_at updated_at) }

    it_behaves_like 'API authorizable'
    it_behaves_like 'API resource creatable'
  end

  describe 'PATCH api/v1/questions/:id' do
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:author) { create(:user) }
    let(:resource) { create(:question, user: author) }
    let(:method) { :patch }
    let(:api_path) { "/api/v1/questions/#{resource.id}" }
    let(:access_token) { create(:access_token, resource_owner_id: author.id) }
    let(:other_access_token) { create(:access_token) }
    let(:resource_params) { { title: 'New title through API', body: 'New body through API' } }
    let(:resource_response) { json['question'] }
    let(:public_fields) { %w(id title body created_at updated_at) }
    let(:do_valid_request) { patch api_path,
                             headers: headers, 
                             params: { access_token: access_token.token,
                             question: resource_params } }
    let(:do_invalid_request) { patch api_path,
                               headers: headers, 
                               params: { access_token: access_token.token,
                               question: attributes_for(:question, :invalid) } }
    let(:do_not_author_request) { patch api_path,
                                  headers: headers, 
                                  params: { access_token: other_access_token.token,
                                  question: resource_params } }

    it_behaves_like 'API authorizable'
    it_behaves_like 'API resource updatable'

    context 'authorized' do
      context 'with valid attributes' do
        it 'assigns the requested question to @question' do
          do_valid_request
          expect(assigns(:question)).to eq resource
        end
      end

      context 'with invalid attributes' do
        before { do_invalid_request }

        it 'assigns the requested question to @question' do
          expect(assigns(:question)).to eq resource
        end

        it 'returns question errors' do
          expect(json['errors']['title'].first).to eq "can't be blank"
        end
      end
    end
  end

  describe 'DELETE api/v1/questions/:id' do
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:author) { create(:user) }
    let!(:resource) { create(:question, user: author) }
    let(:method) { :delete }
    let(:api_path) { "/api/v1/questions/#{resource.id}" }
    let(:access_token) { create(:access_token, resource_owner_id: author.id) }
    let(:other_access_token) { create(:access_token) }
    let(:resource_class) { Question }
    let(:do_valid_request) { delete api_path,
                             headers: headers, 
                             params: { access_token: access_token.token } }
    let(:do_not_author_request) { delete api_path,
                                  headers: headers, 
                                  params: { access_token: other_access_token.token } }

    it_behaves_like 'API authorizable'
    it_behaves_like 'API resource destroyable'

    context 'authorized' do
      context 'for the author of the question' do
        it 'assigns the requested question to @question' do
          do_valid_request
          expect(assigns(:question)).to eq resource
        end
      end

      context 'for not the author of the question' do
        it 'assigns the requested question to @question' do
          do_not_author_request
          expect(assigns(:question)).to eq resource
        end
      end
    end
  end
end
