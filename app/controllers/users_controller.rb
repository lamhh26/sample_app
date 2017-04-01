class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create]
  before_action :find_by_user, except: [:index, :new, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.select(:id, :name, :email).paginate page: params[:page],
      per_page: Settings.page
  end

  def show
    @microposts = @user.microposts.order_desc.paginate page: params[:page],
      per_page: Settings.page
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".activation"
      redirect_to root_url
    else
      render :new
    end
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".profile"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".success"
    else
      flash[:warning] = t ".warning"
    end
    redirect_to users_url
  end

  def following
    @title = t ".title"
    @users = @user.following.paginate page: params[:page]
    render "show_follow"
  end

  def followers
    @title = t ".title"
    @users = @user.followers.paginate page: params[:page]
    render "show_follow"
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def find_by_user
    @user = User.find_by id: params[:id]
    unless @user
      flash[:danger] = t ".user_not_found"
      redirect_to root_url
    end
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    unless current_user.admin?
      flash[:warning] = t ".not_admin"
      redirect_to root_url
    end
  end
end
