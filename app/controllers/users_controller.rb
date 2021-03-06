class UsersController < ApplicationController

  before_action :authenticate_user,{only:[:logout,:update_form,:update,:delete,:book_status,:index,:signup,:signup_form]}
  before_action :authenticate_admin_user,{only:[:index,:update_form,:update,:delete,:signup,:signup_form]}
  before_action :forbid_login_user,{only:[:login,:login_form]}
  before_action :user_params_sanitize,{only:[:login,:signup,:update]}
  before_action :user_id_sanitize,{only:[:update_form,:update,:delete,:book_status]}
  before_action :user_group_sanitize,{only:[:signup,:update,:index]}
  before_action :book_status_sanitize,{only:[:book_status]}
  before_action :user_find_by_id,{only:[:update_form,:update,:delete]}
  before_action :authenticate_correct_user,{only:[:book_status]}


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

    if @user.save
      if params[:image]
        image = params[:image]
        image_url = "#{@user.id}.jpg"
        path = "app/assets/images/temporary/user_images/#{image_url}"
        File.binwrite(path,image.read)
        res = upload_file_sanitize(path)
        if !res
          @user.image_url = image_url
          if @user.save
            FileUtils.mv(path,"app/assets/images/user_images/#{image_url}")
            flash[:notice] = "ユーザ登録しました"
            if @current_user == nil
              session[:user_id] = @user.id
              redirect_to("/books/putback/index")
            elsif @current_user.admin == true
              redirect_to("/users/#{@group}/index")
            end
          else
            File.delete(path)
            render("users/signup_form")
          end
        else
          flash[:notice] = res
          File.delete(path)
          render("users/signup_form")
        end
      else
        flash[:notice] = "ユーザ登録しました"
        if @current_user == nil
          session[:user_id] = @user.id
          redirect_to("/books/putback/index")
        elsif @current_user.admin == true
          redirect_to("/users/#{@group}/index")
        end
      end
    else
      render("users/signup_form")
    end

  end

  def update_form
    @name = @user.name
    @group = @user.group
    @email = @user.email
    @password = @user.password
  end

  def update
    if params[:btn] == "削除"
      delete
    else
      @user.name = @name
      @user.group = @group
      @user.email = @email
      @user.password = @password

      if @user.save
        if params[:image]
          image = params[:image]
          image_url = "#{@user.id}.jpg"
          path = "app/assets/images/temporary/user_images/#{image_url}"
          File.binwrite(path,image.read)
          res = upload_file_sanitize(path)
          if !res
            @user.image_url = image_url
            if @user.save
              FileUtils.mv(path,"app/assets/images/user_images/#{image_url}")
              flash[:notice] = "ユーザ情報を更新しました"
              if @current_user.admin != true
                render("users/update_form")
              else
                redirect_to("/users/#{@group}/index")
              end
            else
              File.delete(path)
              render("users/update_form")
            end
          else
            flash[:notice] = res
            File.delete(path)
            render("users/update_form")
          end
        else
          flash[:notice] = "ユーザ情報を更新しました"
          if @current_user.admin != true
            render("users/update_form")
          else
            redirect_to("/users/#{@group}/index")
          end
        end
      end
    end

  end

  def delete
    histories = History.where(user_id: [@user_id])
    group = @user.group
    if @user.image_url
      File.delete("app/assets/images/user_images/#{@user.image_url}")
    end
    if @user.delete && histories.delete_all
      flash[:notice] = "ユーザを削除しました"
      if @current_user.admin == true
        redirect_to("/users/#{group}/index")
      else
        session[:user_id] = nil
        redirect_to("/login")
      end
    else
      flash[:notice] = "ユーザを削除できませんでした"
      if @current_user.admin == true
        redirect_to("/users/#{group}/index")
      else
        render("users/update_form")
      end
    end
  end

  def book_status
    @histories = History.where(user_id: [@user_id],status: [@status])
  end

  def index
    @users = User.where(group: [@group])
  end

  def terms
  end

end
