require 'rails_helper'

shared_examples_for 'voted' do
  let!(:author) { create(:user) }
  let!(:user) { create(:user) }

  describe 'POST #vote' do
    context 'for not votable author' do
      before { login(user) }

      it 'saves a new vote in db' do
        expect { post :vote, params: { id: voted,
                                       voted: { value: 1 },
                                       format: :json } }.to change(Vote, :count).by(1)
      end

      it 'render valid json' do
        post :vote, params: { id: voted, voted: { value: 1 }, format: :json }

        expected = { votable_type: voted.class.to_s.downcase,
                     votable_id: voted.id,
                     rating: voted.rating
        }.to_json

        expect(response) == expected
      end
    end

    context 'for votable author' do
      before { login(author) }

      it 'does not create new vote' do
        expect { post :vote, params: { id: voted,
                                       voted: { value: 1 },
                                       format: :json } }.to_not change(Vote, :count)
      end
    end

    context 'for unauthorized user' do
      it 'does not create new vote' do
        expect { post :vote, params: { id: voted,
                                       voted: { value: 1 },
                                       format: :json } }.to_not change(Vote, :count)
      end
    end
  end
end
