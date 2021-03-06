require 'spec_helper'

describe UsersController do

  fixtures :all
  describe 'DELETE #destroy' do
    let(:user) { users(:employee) }
    before do
      sign_in(users(:admin))
      delete :destroy, id: user
    end

    it 'deletes the user' do
      expect{ User.find(users(:employee))}.to raise_error
    end


    it 'gives a flash message of successful delete' do
      expect(flash[:success]).to eq 'Successfully deleted the user.'
    end

    it 'redirects to the user profile page' do
      expect(response).to redirect_to user_profile_path(users(:admin))
    end

    context 'when the user has checked out books' do
      let(:user) { users(:employee_with_checked_out_books) }
      it 'deletes the user book issue history' do
        expect(UserBook.find_by_user_id(user.id)).to eq nil
      end
    end
  end

  describe 'PUT #update' do

    admin_first_name = ''
    before do
      sign_in(users(:admin))
      admin_first_name = users(:admin).first_name
      put :update, user: user_params, id:users(:admin).id
    end

    context 'with valid params' do
      let(:user_params) do
        {
          "first_name" => 'ValidFirstName',
          "last_name" => 'ValidLastName',
          "email" => 'ValidEmail@email.com',
          "role" => 'employee'
        }
      end

      it 'updates the attributes of the user' do
        expect(users(:admin).reload.first_name).to eq 'ValidFirstName'
      end

      it 'redirects to the user profile path' do
        expect(response).to redirect_to user_profile_path(users(:admin))
      end

      it 'shows a flash message of successful user update' do
        expect(flash[:success]).to eq 'Successfully updated the user.'

      end

    end

    context 'with invalid params' do
      let(:user_params) do
        {
          "first_name" => '',
          "last_name" => 'ValidLastName',
          "email" => 'ValidEmail@email.com',
          "role" => 'employee'
        }
      end
      it 'does not update the attributes of the user' do
        expect(users(:admin).reload.first_name).to eq admin_first_name

      end

      it 'renders the edit user page' do
        expect(response).to render_template 'edit'
      end

    end
  end
  describe 'GET #new' do
    before do
      sign_in(users(:admin))
      get :new
    end

    it 'assigns a new user' do
      expect(assigns(:user)).to be_a_new(User)
    end

    it 'renders the new user template' do
      expect(response).to render_template('new')
    end
  end

  describe 'GET #index' do
    before do
      sign_in(users(:admin))
    end

    # it 'assigns the list of all users' do
      # # User.destroy_all
      # # user = User.create(first_name: 'userFirstName', last_name: 'userLastName', email: 'userEmailAddress@email.com', password: '1234FakePassword')
      # binding.pry
      # get :index
      # binding.pry

      # expect(assigns(:users)).to eq [user]
    # end
    it 'shows a list of all the users' do
      get :index
      expect(response).to render_template('index')
    end
  end

  describe 'GET #edit' do
    before do
      sign_in(users(:admin))
      get :edit, id: users(:employee)
    end

    it 'assigns users to the passed in user' do
      expect(assigns(:user)).to eq users(:employee)
    end
    it 'renders the edit user page' do
      expect(response).to render_template('edit')
    end

  end

  describe 'POST #create' do
    before do
      sign_in(users(:admin))
      post :create, user: user_params
    end

    context 'when the parameters are valid' do
      let(:user_params) do
        {
          "first_name" => 'UserFirstName',
          "last_name" => 'UserLastName',
          "email" => 'user@email.com',
          "password" => 'FakePassword1234'
        }
      end
      it 'creates a new user' do
        expect(User.find_by_email('user@email.com')).to be_true
      end

      it 'redirects to the homepage of the logged in user' do
        expect(response).to redirect_to user_profile_path(users(:admin))
      end

      it 'shows a successful user creation' do
        expect(flash[:success]).to eq 'Added a new user successfully.'
      end
    end

    context 'when the parameters are invalid' do
      let(:user_params) do
        {
          "first_name" => '',
          "last_name" => 'UserLastName',
          "email" => 'user@email.com',
          "password" => 'FakePassword1234'
        }
      end
      it 'does not create a new user' do
        expect(User.find_by_email('user@email.com')).to_not be_true
      end

      it 'redirects to the application error page' do
        expect(response).to render_template('new')
      end
    end
  end

  describe 'GET #profile' do
    before do
      sign_in(users(:employee))
      get "profile", id: users(:employee).id
    end

    it 'renders the user profile page' do
      expect(response).to render_template('profile')
    end
  end

  describe 'GET #show' do
    before do
      sign_in(users(:employee))
      get "show", id: users(:employee).id
    end

    it 'renders the show user page' do
      expect(response).to render_template('show')
    end
  end
end
