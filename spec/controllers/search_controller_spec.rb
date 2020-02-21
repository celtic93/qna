require 'rails_helper'

RSpec.describe SearchController, type: :controller do

  describe 'GET #search' do
    Services::Searching::SCOPES.each do |scope|
      it "searchs in #{scope}" do
        expect(scope.constantize).to receive(:search).with('test')
        get :search, params: { search: { query: 'test', scope: scope } }
      end

      it 'renders search view' do
        expect(scope.constantize).to receive(:search).with('test')
        get :search, params: { search: { query: 'test', scope: scope } }
        expect(response).to render_template :search
      end

    end

    it 'searchs everywhere if scope nil' do
      expect(ThinkingSphinx).to receive(:search).with('test')
      get :search, params: { search: { query: 'test', scope: nil } }
    end

    it 'searchs everywhere if scope not in list' do
      expect(ThinkingSphinx).to receive(:search).with('test')
      get :search, params: { search: { query: 'test', scope: 'other' } }
    end
  end
end
