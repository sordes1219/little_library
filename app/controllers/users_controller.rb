class UsersController < ApplicationController

  before_action :authenticate_user,{only:[:logout,:signup,:signup_form,:update_form,:update,:delete,:book_status,:index]}
  before_action :forbid_login_user,{only:[:login,:login_form]}
  before_action :user_params_sanitize,{only:[:login,:signup,:update]}
  before_action :user_id_sanitize,{only:[:update_form,:update,:delete,:book_status]}
  before_action :user_group_sanitize,{only:[:signup,:update,:index]}
  before_action :book_status_sanitize,{only:[:book_status]}
  before_action :user_find_by_id,{only:[:update_form,:update,:delete]}
  # before_action :upload_file_sanitize,{only:[:signup,:update]}

  def login_form
  end

  def login
    @user = User.find_by(email: @email)
    if @user && @user.authenticate(@password)
      session[:user_id] = @user.id
      flash[:notice] = "ログインしました"
      redirect_to("/books/putback/index")
    else
      @error_message = "メールアドレスかパスワードが間違っています"
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
    @user = User.new(name: @name,group: @group,email: @email,password: @password,admin: false)

    if params[:image]
      image = params[:image]
      image_url = "#{@user.id}.jpg"
      File.binwrite("public/user_images/#{image_url}",image.read)
      res = upload_file_sanitize("public/user_images/#{image_url}")
      if !res
        @user.image_url = image_url
        if @user.save
          flash[:notice] = "ユーザ登録しました"
          redirect_to("/users/#{@group}/index")
        else
          render("users/signup_form")
        end
      else
        flash[:notice] = res
        render("users/signup_form")
      end
    else
      if @user.save
        flash[:notice] = "ユーザ登録しました"
        redirect_to("/users/#{@group}/index")
      else
        render("users/signup_form")
      end
    end

  end

  def update_form
    @name = @user.name
    @group = @user.group
    @email = @user.email
    @password = @user.password
  end

  def update
    @user.name = @name
    @user.group = @group
    @user.email = @email
    @user.password = @password

    if params[:image]
      image = params[:image]
      image_url = "#{@user.id}.jpg"
      File.binwrite("public/user_images/#{image_url}",image.read)
      res = upload_file_sanitize("public/user_images/#{image_url}")
      if !res
        @user.image_url = image_url
        if @user.save
          flash[:notice] = "ユーザ登録しました"
          redirect_to("/users/#{@group}/index")
        else
          render("users/signup_form")
        end
      else
        flash[:notice] = res
        render("users/signup_form")
      end
    else
      if @user.save
        flash[:notice] = "ユーザ登録しました"
        redirect_to("/users/#{@group}/index")
      else
        render("users/signup_form")
      end
    end
    
  end

  def delete
    histories = History.where(user_id: [@user_id])
    group = @user.group
    if @user.image_url
      File.delete("public/user_images/#{@user.image_url}")
    end
    if @user.delete && histories.delete_all
      flash[:notice] = "ユーザを削除しました"
      redirect_to("/users/#{group}/index")
    else
      flash[:notice] = "ユーザを削除できませんでした"
      redirect_to("/users/#{group}/index")
    end
  end

  def book_status
    if @current_user.admin == true || @current_user.id == @user_id.to_i
      @histories = History.where(user_id: [@user_id],status: [@status])
    else
      flash[:notice] = "閲覧権限がありません"
      @histories = []
    end
  end

  def index
    @users = User.where(group: [@group])
  end

end
