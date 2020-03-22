require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  describe '#index' do
    context 'as an authenticated user' do
      before do
        @user = FactoryBot.create(:user)
      end
      it 'responds successfully' do
        sign_in @user
        get :index
        expect(response).to be_success
      end
      it 'returns a 200 response' do
        sign_in @user
        get :index
        expect(response).to have_http_status(200)
      end
    end
    context 'as a guest' do
      it 'returns a 302 response' do
        get :index
        expect(response).to have_http_status(302)
      end

      it 'redirects to the sign-in page' do
        get :index
        expect(response).to redirect_to '/users/sign_in' #user_session_path
      end
    end
  end

  describe '#show' do
    context 'as an authorized user' do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end
      it 'responds successfully' do
        sign_in @user
        get :show, params: { id: @project.id }

        expect(response).to be_success
      end
    end
    context 'as an unauthorized user' do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: other_user)
      end

      it 'redirects to the dashboard' do
        sign_in @user
        get :show, params: { id: @project.id }

        expect(response).to redirect_to root_path
      end
    end
  end

  describe '#new' do
    context 'as an authorized user' do
     before do
       @user = FactoryBot.create(:user)
     end
     it 'responds successfully' do
        sign_in @user

        get :new

        expect(response).to be_success
      end
   end

   context 'as a guest' do
      it 'returns status 302' do
        get :new

        expect(response).to have_http_status 302
      end

      it 'redirects to the sign in page' do
        get :new

        expect(response).to redirect_to user_session_path
      end
    end
  end

  describe '#create' do
    context 'as an authorized user' do
      before do
        @user = FactoryBot.create(:user)
      end

      context 'with valids attributes' do
        it 'adds a project' do
          project_params = FactoryBot.attributes_for(:project)
          sign_in @user

          expect { post :create, params: {
              project: project_params }
          }.to change(@user.projects, :count).by(1)
        end
      end

      context 'with invalids attributes' do
        it 'does not add a project' do
          project_params = FactoryBot.attributes_for(:project, :invalid)

          sign_in @user
          expect {
            post :create, params: {
                project: project_params
            }
          }.not_to change(@user.projects, :count)
        end
      end
    end
    context 'as a guest' do
      it 'returns a 302 response' do
        project_params = FactoryBot.attributes_for(:project)
        post :create, params: {
            project: project_params }

        expect(response).to have_http_status(302)
      end
    end
    it 'redirects to the sign-in page' do
      project_params = FactoryBot.attributes_for(:project)
      post :create, params: {
          project: project_params
      }

      expect(response).to redirect_to '/users/sign_in'
    end
  end

  describe '#update' do
    context 'as an authorized user' do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      it 'updates a project' do
        project_params = FactoryBot.attributes_for(:project,
                                                   name: 'New Project Name')
        sign_in @user
        patch :update, params: {
            id: @project.id,
            project: project_params
        }

        expect(@project.reload.name).to eq 'New Project Name'
      end
    end

    context 'as an unauthorized user' do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: other_user,
                                     name: 'Same old name')
      end
      it 'does not update the project' do
        project_params = FactoryBot.attributes_for(:project,
                                                   name: 'New Project Name')
        sign_in @user
        patch :update, params: {
            id: @project.id,
            project: project_params
        }

        expect(@project.reload.name).to eq 'Same old name'
      end

      it 'redirects to the dashboard' do
        project_params = FactoryBot.attributes_for(:project,
                                                   name: 'New Project Name')
        sign_in @user
        patch :update, params: {
            id: @project.id,
            project: project_params
        }

        expect(response).to redirect_to root_path
      end
    end

    context 'as a guest do' do
      before do
        @project = FactoryBot.create(:project)
      end

      it 'returns a 302 response' do
        project_params = FactoryBot.attributes_for(:project)
        patch :update, params: {
            id: @project.id,
            project: project_params
        }

        expect(response).to have_http_status(302)
      end

      it 'redirects to sign in page' do
        project_params = FactoryBot.attributes_for(:project)
        patch :update, params: {
            id: @project.id,
            project: project_params
        }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#edit' do
    context 'as an authorized user' do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end
      it 'responds successfully' do
        sign_in @user

        get :edit, params: {
          id: @project.id
        }

        expect(response).to be_success
      end
    end

    context 'as an unauthorized user' do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: other_user)
      end

      it 'returns status 302' do
        sign_in @user

        get :edit, params: {
            id: @project.id
        }
        expect(response).to have_http_status(302)
      end

      it 'redirects to dashboard' do
        sign_in @user

        get :edit, params: {
            id: @project.id
        }
        expect(response).to redirect_to root_path
      end
    end

    context 'as a guest' do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end
      it 'returns status 302' do
        get :edit, params: {
            id: @project.id
        }

        expect(response).to have_http_status(302)
      end

      it 'redirects to sign in page' do
        get :edit, params: {
            id: @project.id
        }

        expect(response).to redirect_to user_session_path
      end
    end
  end

  describe '#destroy' do
    context 'as an authorized user' do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end
      it 'deletes a project' do
        sign_in @user

        expect {
          delete :destroy, params: {
              id: @project.id
          }
        }.to change(@user.projects,:count).by(-1)
      end
    end
    context 'an an unauthorized user' do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: other_user)
      end
      it 'does not delete the project' do
        sign_in @user

        expect {
          delete :destroy, params: {
              id: @project.id
          }
        }.not_to change(Project, :count)
      end

      it 'redirect to dashboard page' do
        sign_in @user

          delete :destroy, params: {
              id: @project.id
          }
        expect(response).to redirect_to root_path
      end
    end
    context 'as a guest' do
      before do
        @project = FactoryBot.create(:project)
      end
      it 'returns a 302 response' do
        delete :destroy, params: {
            id: @project.id
        }

        expect(response).to have_http_status(302)
      end

      it 'redirect to sign in page' do
        delete :destroy, params: {
            id: @project.id
        }

        expect(response).to redirect_to user_session_path
      end
    end
  end
end
