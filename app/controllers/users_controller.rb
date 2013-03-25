class UsersController < ApplicationController
  before_filter :signed_out_user, only: [:new, :create]
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: [:destroy]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(params[:user])
      # Handle a successful update.
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    user_to_delete = User.find(params[:id])
    if user_to_delete == current_user
      flash[:error] = "An admin cannot delete themselves"
      redirect_to root_path
    else
      user_to_delete.destroy
      flash[:success] = "User deleted."
      redirect_to users_url
    end
  end
  
  private
    def signed_out_user
      unless !signed_in?
        redirect_to root_url, notice: "Already signed in."
      end
    end
  
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path, { notice: "Access denied."} ) unless current_user?(@user)
    end
  
    def admin_user
      redirect_to(root_path, { notice: "Not an admin. Permission denied."} ) unless current_user.admin?
    end
  
end
