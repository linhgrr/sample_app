class UsersController < ApplicationController
  before_action :load_user, only: :show

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      flash[:success] = t(".signup_success")
      redirect_to user_path @user, locale: I18n.locale, status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit User::PERMITTED_ATTRIBUTES
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t(".user_not_found")
    redirect_to root_path
  end
end
