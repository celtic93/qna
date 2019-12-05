require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    let!(:question) { create(:question, :with_file) }

    context 'for the author of the question' do
      before { login(question.user) }

      it 'deletes the attached file from question' do
        expect { delete :destroy, params: { id: question.files.first }, format: :js }.to change(question.files, :count).by(-1)
      end

      it 'renders destroy' do
        delete :destroy, params: { id: question.files.first, format: :js }
        expect(response).to render_template :destroy
      end
    end

    context 'for not the author of the question' do
      let(:not_author) { create(:user) }
      
      before { login(not_author) }

      it "don't delete the attached file from question" do
        expect { delete :destroy, params: { id: question.files.first } }.to_not change(question.files, :count)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: question.files.first }
        expect(response).to redirect_to question
      end
    end

    context 'for unauthenticated user' do
      it "don't delete the attached file from question" do
        expect { delete :destroy, params: { id: question.files.first } }.to_not change(question.files, :count)
      end

      it 'redirects to sign up page' do
        delete :destroy, params: { id: question.files.first }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
