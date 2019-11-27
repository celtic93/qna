require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'GET #new' do
    context 'for authenticated user' do
      before do
        login(user)
        get :new, params: { question_id: question }
      end

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
      before do
        login(user)
        get :edit, params: { id: answer }
      end

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
                                         answer: attributes_for(:answer) }, format: :js }.to change(question.answers, :count).by(1)

      end

      it 'renders create' do
        post :create, params: { question_id: question,
                                answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      before { login(user) }

      it 'does not save the answer' do
        expect { post :create, params: { question_id: question,
                                         answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(question.answers, :count)
      end

      it 'renders create' do
        post :create, params: { question_id: question,
                                answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :create
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
        patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'body' } }, format: :js
        answer.reload

        expect(answer.body).to eq 'body'
      end

      it 'renders update' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before do
        login(user)
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
      end

      it 'does not change answer' do
        answer.reload

        expect(answer.body).to eq 'Answer Text'
      end

      it 'renders update' do
        expect(response).to render_template :update
      end
    end

    context 'for not the author of the answer' do
      let(:not_author) { create(:user) }

      before do
        login(not_author)
        patch :update, params: { id: answer, answer: { body: 'body' } }
      end

      it 'does not change answer' do
        answer.reload

        expect(answer.body).to eq 'Answer Text'
      end

      it 'redirects to question' do
        expect(response).to redirect_to answer.question
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

  describe 'PATCH #best' do
    context 'for the author of the question' do
      before { login(question.user) }

      it 'assigns the requested answer to @answer' do
        patch :best, params: { id: answer }, format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :best, params: { id: answer }, format: :js
        answer.reload

        expect(answer).to be_best
      end

      it 'renders best' do
        patch :best, params: { id: answer }, format: :js
        expect(response).to render_template :best
      end
    end

    context 'for not the author of the question' do
      let(:not_author) { create(:user) }

      before do
        login(not_author)
        patch :best, params: { id: answer, answer: { best: true } }
      end

      it 'does not change answer' do
        answer.reload

        expect(answer.best).to be_falsey
      end

      it 'redirects to question' do
        expect(response).to redirect_to answer.question
      end  
    end

    context 'for unauthenticated user' do
      before { patch :best, params: { id: answer, answer: { best: true } } }

      it 'does not change answer' do
        answer.reload

        expect(answer.best).to be_falsey
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
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(question.answers, :count).by(-1)
      end

      it 'renders destroy' do
        delete :destroy, params: { id: answer, format: :js }
        expect(response).to render_template :destroy
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
