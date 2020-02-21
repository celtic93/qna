require 'rails_helper'

RSpec.describe SearchController, type: :controller do

  describe 'GET #search' do
    context 'with scope' do
      Services::Searching::SCOPES.each do |scope|
        before do
          expect(scope.constantize).to receive(:search).with('test')
          get :search, params: { search: { query: 'test', scope: scope } }
        end

        it "searchs in #{scope}" do
        end

        it 'renders search view' do
          expect(response).to render_template :search
        end
      end
    end

    context 'with no scope' do
      before do
        expect(ThinkingSphinx).to receive(:search).with('test')
        get :search, params: { search: { query: 'test', scope: nil } }
      end

      it 'searchs everywhere' do
      end

      it 'renders search view' do
        expect(response).to render_template :search
      end
    end

    context 'with other scope' do
      before do
        expect(ThinkingSphinx).to receive(:search).with('test')
        get :search, params: { search: { query: 'test', scope: 'other' } }
      end

      it 'searchs everywhere' do
      end

      it 'renders search view' do
        expect(response).to render_template :search
      end
    end
  end
end
