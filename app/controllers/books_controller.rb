class BooksController < ApplicationController
  
  before_action :authenticate_user
  before_action :book_params_sanitize,{only:[:update]}
  before_action :book_status_sanitize,{only:[:index]}
  before_action :book_id_sanitize,{only:[:show,:rental,:putback,:update_form,:update,:delete]}
  before_action :book_find_by_id,{only:[:show,:rental,:putback,:update_form,:update,:delete]}
  
  def index
    book_id_list = []
    histories = History.where(status: "rental")
    histories.each do |history|
      book_id_list.push(history.book_id)
    end
    if @status == "rental"
      @books = Book.where(id: [book_id_list])
    elsif @status == "putback"
      @books = Book.where.not(id: [book_id_list])
    end
  end
  
  def show
  end
  
  def rental
    if History.find_by(book_id: @book_id,status:"rental")
      flash[:notice] = "このほんは、かしだしちゅうです"
      redirect_to("/books/#{@book_id}")
    else
      history = History.new(user_id: @current_user.id,book_id: @book_id,status:"rental")
      history.save
      flash[:notice] = "このほんをかりました。かしだしきかんは１しゅうかんです"
      redirect_to("/users/#{@current_user.id}/rental")
    end
  end
  
  def putback
    history = History.find_by(user_id: @current_user.id,book_id: @book_id,status:"rental")
    if history
      history.status = "putback"
      history.save
      flash[:notice] = "ありがとう！ほんは、ほんだなにもどしておいてね"
      redirect_to("/users/#{@current_user.id}/putback")
    else
      flash[:notice] = "このほんは、かりていません"
      redirect_to("/books/#{@book_id}")
    end
  end
  
  def signup_form
    @book = Book.new
  end

  def signup
    @name = params[:name]
    @content = params[:content]
    @book = Book.new(name: @name,content: @content)
    if @book.save
      if params[:image]
        image = params[:image]
        image_url = "#{@book.id}.jpg"
        File.binwrite("public/book_images/#{image_url}",image.read)
        @book.image_url = image_url
        @book.save
      end
      flash[:notice] = "本を登録しました"
      redirect_to("/books/putback/index")
    else
      render("/books/signup_form")
    end
  end
  
  def update_form
    @name = @book.name
    @content = @book.content
  end
  
  def update
    @book.name = @name
    @book.content = @content
    if @book.save
      if params[:image]
        image = params[:image]
        image_url = "#{@book.id}.jpg"
        File.binwrite("public/book_images/#{image_url}",image.read)
      end
      flash[:notice] = "本の情報を更新しました"
      redirect_to("/books/putback/index")
    else
      render("books/update_form")
    end
  end
  
  def delete
    histories = History.where(book_id: [@book_id])
    if @book.image_url
      File.delete("public/book_images/#{@book.image_url}")
    end
    if @book.delete && histories.delete_all
      flash[:notice] = "本の情報を削除しました"
      redirect_to("/books/putback/index")
    else
      flash[:notice] = "本の情報を削除できませんでした"
      redirect_to("/books/putback/index")
    end
  end
  
end
