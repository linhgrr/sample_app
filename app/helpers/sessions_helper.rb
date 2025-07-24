module SessionsHelper
  def log_in user
    session[:user_id] = user.id
  end

  def current_user
    if (user_id = session[:user_id])
      user = User.find_by id: user_id
      if user && session[:session_token] && user.authenticated?(session[:session_token])
        @current_user ||= user
      elsif user && session[:session_token].nil?
        # fallbak trong truong hợp session hien tai khong co session_token
        @current_user ||= user
      end
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by id: user_id
      if user&.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def logged_in?
    current_user.present?
  end

  def log_out
    if logged_in?
      forget(current_user)
      forget_session(current_user)
    end
    reset_session
    @current_user = nil
  end

  def remember user
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget user
    user.forget
    cookies.delete :user_id
    cookies.delete :remember_token
  end

  def create_session user
    user.create_session
    session[:session_token] = user.session_token
  end

  def forget_session user
    user.forget_session if user
  end
end
