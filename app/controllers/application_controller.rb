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

  def authenticate_admin_user
    if @current_user.admin != true
      flash[:notice] = "閲覧権限がありません"
      redirect_to("/books/putback/index")
    end
  end

  def authenticate_correct_user
    if @current_user.admin != true && @current_user.id != @user_id.to_i
      flash[:notice] = "閲覧権限がありません"
      redirect_to("/books/putback/index")
    end
  end

  def forbid_login_user
    if @current_user != nil
      flash[:notice] = "すでにログインしています"
      redirect_to("/books/putback/index")
    end
  end

  def user_params_sanitize
    @name = view_context.sanitize(params[:name])
    @group = view_context.sanitize(params[:group])
    @email = view_context.sanitize(params[:email])
    @password = view_context.sanitize(params[:password])
  end

  def book_params_sanitize
    @name = view_context.sanitize(params[:name])
    @content = view_context.sanitize(params[:content])
  end

  def user_group_sanitize
    whitelist = ["taiyo","sora","umi","futaba","soyokaze","daichi"]
    if whitelist.grep(params[:group]).first
      @group = whitelist.grep(params[:group]).first
    else
      @group = "taiyo"
    end
  end

  def book_status_sanitize
    whitelist = ["rental","putback"]
    if whitelist.grep(params[:status]).first
      @status = whitelist.grep(params[:status]).first
    else
      @status = "rental"
    end
  end

  def user_id_sanitize
    if params[:user_id].match(/\A[0-9]+\z/)
      @user_id = params[:user_id]
    else
      @user_id = nil
    end
  end

  def book_id_sanitize
    if params[:book_id].match(/\A[0-9]+\z/)
      @book_id = params[:book_id]
    else
      @book_id = nil
    end
  end

  def upload_file_sanitize(path)
    if File.size(path) > 1000000
      res = "ファイルサイズが大きすぎます"
    else
      File.open(path, 'rb') do |f|
        begin
          header = f.read(8)
          f.seek(-12, IO::SEEK_END)
          footer = f.read(12)
        rescue
          res = "画像ファイルの登録に失敗しました"
        end

        if header[0, 2].unpack('H*') == %w(ffd8) && footer[-2, 2].unpack('H*') == %w(ffd9) ||\
          header[0, 3].unpack('A*') == %w(GIF) && footer[-1, 1].unpack('H*') == %w(3b) ||\
          header[0, 8].unpack('H*') == %w(89504e470d0a1a0a) && footer[-12,12].unpack('H*') == %w(0000000049454e44ae426082)
          return nil
        else
          res = "画像ファイルの登録に失敗しました"
        end
      end
    end
    return res
  end

  def book_find_by_id
    @book = Book.find_by(id: @book_id)
    if @book == nil
      flash[:notice] = "不正な値です"
      redirect_to("/")
    end
  end

  def user_find_by_id
    @user = User.find_by(id: @user_id)
    if @user == nil
      flash[:notice] = "不正な値です"
      redirect_to("/")
    end
  end

end
