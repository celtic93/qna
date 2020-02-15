require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'POST #create' do
    let(:subscribe) { post :create, params: { id: question.id }, format: :js }

    context 'Authenticated user' do
      before { login(user) }

      it 'saves a new subscription to database' do
        expect { subscribe }.to change(question.subscriptions, :count).by(1)
      end

      it 'returns status 2xx' do
        subscribe
        expect(response).to be_successful
      end

      it 'assigns new subscription to current_user' do
        subscribe
        expect(question.subscriptions.last).to eq user.subscriptions.last
      end
    end

    context 'Unauthenticated user' do
      it 'not saves a new subscription to database' do
        expect { subscribe }.to_not change(question.subscriptions, :count)
      end

      it 'returns status 4xx' do
        subscribe
        expect(response).to_not be_successful
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscription) { create(:subscription, question: question, user: user) }
    let(:unsubscribe) { delete :destroy, params: { id: question.id }, format: :js }

    context 'Authenticated user' do
      before { login(user) }

      it 'deletes subscription for question' do
        expect { unsubscribe }.to change(question.subscriptions, :count).by(-1)
      end

      it 'returns status 2xx' do
        unsubscribe
        expect(response).to be_successful
      end
    end

    context 'Unauthenticated user' do
      it 'not deletes subscription for question' do
        expect { unsubscribe }.to_not change(question.subscriptions, :count)
      end

      it 'returns status 4xx' do
        unsubscribe
        expect(response).to_not be_successful
      end
    end
  end
end
