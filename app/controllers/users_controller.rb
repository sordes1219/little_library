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
  
  def signup_form
    @user = User.new
  end
  
  def signup
    @name = params[:name]
    @group = params[:group]
    @email = params[:email]
    @password = params[:password]
    admin = false
    @user = User.new(name:@name,group:@group,email:@email,password:@password,admin:admin)
    
    if @user.save
      if params[:image]
        image = params[:image]
        image_url = "#{@user.id}.jpg"
        File.binwrite("public/user_images/#{image_url}",image.read)
        @user.image_url = image_url
        @user.save
      end
      flash[:notice] = "ユーザ登録しました"
      redirect_to("/users/#{@group}/index")
    else
      render("users/signup_form")
    end
  end
  
  def update_form
    @user = User.find_by(id:params[:user_id])
    @name = @user.name
    @group = @user.group
    @email = @user.email
    @password = @user.password
  end
  
  def update
    @name = params[:name]
    @group = params[:group]
    @email = params[:email]
    @password = params[:password]
    @user = User.find_by(id:params[:user_id])
    @user.name = @name
    @user.group = @group
    @user.email = @email
    @user.password = @password
    if @user.save
      if params[:image]
        image = params[:image]
        image_url = "#{@user.id}.jpg"
        File.binwrite("public/user_images/#{image_url}",image.read)
        @user.image_url = image_url
        @user.save
      end
      flash[:notice] = "ユーザ情報を更新しました"
      redirect_to("/users/#{@group}/index")
    else
      render("users/update_form")
    end
  end
  
  def delete
    user = User.find_by(id: params[:user_id])
    histories = History.where(user_id: params[:user_id])
    group = user.group
    if user.delete && histories.delete_all
      flash[:notice] = "ユーザを削除しました"
      redirect_to("/users/#{group}/index")
    else
      flash[:notice] = "ユーザを削除できませんでした"
      redirect_to("/users/#{group}/index")
    end
  end
  
  def index
    @group = params[:group]
    @users = User.where(group:@group)
  end

end
