require 'spec_helper'
require 'rails_helper'
RSpec.describe UsersController do
  before(:each) do
    @admin = create(:user)
    @user  = create(:user, email: "u2@user.com",role: "author")
    @user1  = create(:user, email: "u3@user.com",role: "author")
  end

  after(:each) do
    #DatabaseCleaner.clean
  end

  describe "GET #index" do
    ## For User index page
    it "should load users index page for admin" do
      session[:user_id] = @admin.id
      get :index
      expect(response).to render_template(:index)
    end
  end

  it "should logout and go to login page if normal user try to load users index page" do
    session[:user_id] = @user.id
    get :index
    expect(response).to redirect_to(:root)
    expect(session[:user_id]).to eq(nil)
  end


   it "should load the show user page of self for admin" do
      session[:user_id] = @admin.id
      get :show, id: @admin.id
      expect(response).to render_template(:show)
    end

    it "should load the show user page of other user for admin" do
      session[:user_id] = @admin.id
      get :show, id: @user.id
      expect(response).to render_template(:show)
    end

  it "should load the show user page of other user for admin" do
    session[:user_id] = @admin.id
    get :show, id: @user1.id
    expect(response).to render_template(:show)
  end

    it "should load the show user page of self for normal user" do
      session[:user_id] = @user.id
      get :show, id: @user.id
      expect(response).to render_template(:show)
    end

    it "should logout and go to login page if normal user try to load show user page of other user" do
      session[:user_id] = @user.id
      get :show, id: @user1.id
      expect(response).to redirect_to(:root)
      expect(session[:user_id]).to eq(nil)
      expect(flash[:notice]).to eq("You dont have sufficient rights to do this...")
    end

    ## For User New page
    it "should load the new user page of for admin" do
      session[:user_id] = @admin.id
      get :new
      expect(response).to render_template(:new)
    end

    it "should logout and go to login page if normal user try to load new user page" do
      session[:user_id] = @user.id
      get :new
      expect(response).to redirect_to(:root)
      expect(session[:user_id]).to eq(nil)
      expect(flash[:notice]).to eq("You dont have sufficient rights to do this...")
    end

    ## For User Create
    it "should create new user for admin" do
      session[:user_id] = @admin.id
      post :create, {format: "html", user: {first_name: "raghu", email: "raghu@kreatio.com", password: "raghu", role: "admin"}}
      new_user = User.find_by_email("raghu@kreatio.com")
      expect(new_user.first_name).to eq("raghu")
      expect(response).to redirect_to(user_path(new_user))
    end

    it "should logout and go to login page if normal user try to create new user" do
      session[:user_id] = @user.id
      post :create, {format: "html", user: {first_name: "raghu", email: "raghu@kreatio.com", password: "raghu", role: "admin"}}
      expect(response).to redirect_to(:root)
      expect(session[:user_id]).to eq(nil)
      expect(flash[:notice]).to eq("You dont have sufficient rights to do this...")
    end

    ## For User Edit
    it "should load edit page of self for admin" do
      session[:user_id] = @admin.id
      get :edit, id: @admin.id
      expect(response).to render_template(:edit)
    end

    it "should load edit page of other user for admin" do
      session[:user_id] = @admin.id
      get :edit, id: @user.id
      expect(response).to render_template(:edit)
    end

  end