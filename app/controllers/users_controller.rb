class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :change_password, :update_password]

  before_action :authorise
  before_action :admin_only, only: [:new, :create, :index]
  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        @user.update_column("password", Digest::MD5.hexdigest(user_params[:password]))
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  # def destroy
  #   @user.destroy
  #   respond_to do |format|
  #     format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  def change_password
  end

  def update_password
    if @role == "admin" and !params[:new_password].blank?
      @user.update_attributes(password: Digest::MD5.hexdigest(params[:new_password]))
      redirect_to users_path
    elsif !params[:new_password].blank? and @user.password == Digest::MD5.hexdigest(params[:old_password]) and params[:new_password] == params[:confirm_password]
      @user.update_attributes(password: Digest::MD5.hexdigest(params[:new_password]))
      redirect_to user_path(@user)
    else
      @user.errors.add(:base, "something went wrong")
      render template: "users/change_password"
    end
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    if @role == "admin"
      params.require(:user).permit(:first_name, :last_name, :email, :role, :password)
    else
      params.require(:user).permit(:first_name, :last_name, :email)
    end
  end

  def authorise
    get_out if @role == "author" and (session[:user_id].to_s != params[:id])
  end

  def get_out
    reset_session
    flash[:notice] = "You dont have sufficient rights to do this..."
    redirect_to :root
  end

  def admin_only
    get_out if @role != "admin"
  end


end
