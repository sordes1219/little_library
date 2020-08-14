class UsersController < ApplicationController

  def index_rent
    @histories = History.where(user_id:@current_user.id,status:"rental")
  end
  
  def index_putback
    @histories = History.where(user_id:@current_user.id,status:"putback")
  end
  
  def login_form
  end
  
  def login
    @user = User.find_by(email:params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = "ログインしました"
      redirect_to("/books/putback")
    else
      @error_message = "メールアドレスかパスワードが間違っています"
      @email = params[:email]
      @password = params[:password]
      render("users/login_form")
    end
  end
  
  def logout
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to("/login")
  end
  

end
