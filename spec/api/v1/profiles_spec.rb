require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json',
                    'ACCEPT' => 'application/json' } }

  describe 'GET api/v1/profiles/me' do
    it_behaves_like 'API authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles/me' }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { access_token: access_token.token },
                                          headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w(id email created_at updated_at).each do |attr|
          expect(json['user'][attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w(password encrypted_password).each do |attr|
          expect(json['user']).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET api/v1/profiles' do
    it_behaves_like 'API authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles' }
    end

    context 'authorized' do
      let(:users) { create_list(:user, 2) }
      let(:me) { users.first }
      let(:user) { users.last }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles', params: { access_token: access_token.token },
                                       headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all users except current user' do
        expect(json['users'].size).to eq(users.size - 1)
        expect(json['users'].find { |user_hash| user_hash['id'] == user.id }).to_not be_empty
        expect(json['users'].find { |user_hash| user_hash['id'] == me.id }).to be_nil
      end

      it 'returns all public fields' do
        %w(id email created_at updated_at).each do |attr|
          expect(json['users'].last[attr]).to eq user.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w(password encrypted_password).each do |attr|
          expect(json['users'].last).to_not have_key(attr)
        end
      end
    end
  end
end
