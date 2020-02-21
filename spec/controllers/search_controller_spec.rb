require 'rails_helper'

RSpec.describe SearchController, type: :controller do

  describe 'GET #search' do
    context 'with scope' do
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
    end

    context 'with no scope' do
      it 'searchs everywhere' do
        expect(ThinkingSphinx).to receive(:search).with('test')
        get :search, params: { search: { query: 'test', scope: nil } }
      end

      it 'renders search view' do
        expect(ThinkingSphinx).to receive(:search).with('test')
        get :search, params: { search: { query: 'test', scope: nil } }
        expect(response).to render_template :search
      end
    end

    context 'with other scope' do
      it 'searchs everywhere' do
        expect(ThinkingSphinx).to receive(:search).with('test')
        get :search, params: { search: { query: 'test', scope: 'other' } }
      end

      it 'renders search view' do
        expect(ThinkingSphinx).to receive(:search).with('test')
        get :search, params: { search: { query: 'test', scope: 'other' } }
        expect(response).to render_template :search
      end
    end
  end
end
