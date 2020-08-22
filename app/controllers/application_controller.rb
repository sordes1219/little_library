class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  before_action :set_current_user
  
  def set_current_user
    @current_user = User.find_by(id:session[:user_id])
  end
  
  def authenticate_user
    if @current_user == nil
      flash[:notice] = "ログインが必要です"
      redirect_to("/login")
    end
  end
  
  def forbid_login_user
    if @current_user != nil
      flash[:notice] = "すでにログインしています"
      redirect_to("/books/putback/index")
    end
  end
  
  def user_group_normalization(param)
    group_list = ["taiyo","sora","umi","futaba","soyokaze","daichi"]
    return group_list.grep(param).first
  end
  
end
