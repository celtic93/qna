require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'GET #new' do
    context 'for authenticated user' do
      before { login(user) }
      before { get :new, params: { question_id: question } }

      it 'assigns a new Answer to @answer' do
        expect(assigns(:answer)).to be_a_new(Answer)
      end

      it 'renders new view' do
        expect(response).to render_template :new
      end
    end

    context 'for unauthenticated user' do
      before { get :new, params: { question_id: question } }

      it 'do not assigns a new Answer to @answer' do
        expect(assigns(:answer)).to_not be_a_new(Answer)
      end

      it 'redirects to sign up page' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: answer } }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #edit' do
    context 'for authenticated user' do
      before { login(user) }
      before { get :edit, params: { id: answer } }

      it 'assigns the requested answer to @answer' do
        expect(assigns(:answer)).to eq answer
      end

      it 'renders edit view' do
        expect(response).to render_template :edit
      end
    end

    context 'for unauthenticated user' do
      before { get :edit, params: { id: answer } }

      it 'do not assigns the requested answer to @answer' do
        expect(assigns(:answer)).to_not eq answer
      end

      it 'redirects to sign up page' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      before { login(user) }

      it 'saves a new answer in database' do
        expect { post :create, params: { question_id: question,
                                         user_id: user,
                                         answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)

      end

      it 'redirects to question' do
        post :create, params: { question_id: question,
                                answer: attributes_for(:answer) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      before { login(user) }

      it 'does not save the answer' do
        expect { post :create, params: { question_id: question,
                                         answer: attributes_for(:answer, :invalid) } }.to_not change(question.answers, :count)
      end

      it 'redirects to question' do
        post :create, params: { question_id: question,
                                answer: attributes_for(:answer, :invalid) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'for unauthenticated user' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question,
                                         answer: attributes_for(:answer) } }.to_not change(question.answers, :count)
      end

      it 'redirects to sign up page' do
        post :create, params: { question_id: question,
                                answer: attributes_for(:answer) }

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      before { login(user) }

      it 'assigns the requested answer to @answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'body' } }
        answer.reload

        expect(answer.body).to eq 'body'
      end

      it 'redirects to updated answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }
        expect(response).to redirect_to answer
      end
    end

    context 'with invalid attributes' do
      before { login(user) }
      before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) } }

      it 'does not change answer' do
        answer.reload

        expect(answer.body).to eq 'Answer Text'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end

    context 'for not the author of the answer' do
      let(:not_author) { create(:user) }

      before { login(not_author) }
      before { patch :update, params: { id: answer, answer: { body: 'body' } } }

      it 'does not change answer' do
        answer.reload

        expect(answer.body).to eq 'Answer Text'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end

    context 'for unauthenticated user' do
      before { patch :update, params: { id: answer, answer: { body: 'body' } } }

      it 'does not change answer' do
        answer.reload

        expect(answer.body).to eq 'Answer Text'
      end

      it 'redirects to sign up page' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'for the author of the answer' do
      before { login(user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(question.answers, :count).by(-1)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to answer.question
      end
    end

    context 'for not the author of the answer' do
      let(:not_author) { create(:user) }
      
      before { login(not_author) }

      it "don't delete the answer" do
        expect { delete :destroy, params: { id: answer } }.to_not change(question.answers, :count)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to answer.question
      end
    end

    context 'for unauthenticated user' do
      it "don't delete the answer" do
        expect { delete :destroy, params: { id: answer } }.to_not change(question.answers, :count)
      end

      it 'redirects to sign up page' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
