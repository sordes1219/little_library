class BooksController < ApplicationController
  
  def index_rent
    book_id_list = []
    histories = History.where(status:"rental")
    histories.each do |history|
      book_id_list.push(history.book_id)
    end
    @books = Book.where(id: book_id_list)
  end
  
  def index_putback
    book_id_list = []
    histories = History.where(status:"rental")
    histories.each do |history|
      book_id_list.push(history.book_id)
    end
    @books = Book.where.not(id: book_id_list)
  end
  
  def show
    @book = Book.find_by(id: params[:book_id])
  end
  
  def rent
    if History.find_by(book_id: params[:book_id],status:"rental")
      flash[:notice] = "このほんは、かしだしちゅうです"
      redirect_to("/books/#{params[:book_id]}")
    else
      history = History.new(user_id: @current_user.id,book_id: params[:book_id],status:"rental")
      history.save
      flash[:notice] = "このほんをかりました。かしだしきかんは１しゅうかんです"
      redirect_to("/books/#{params[:book_id]}")
    end
  end
  
  def putback
    history = History.find_by(user_id: @current_user.id,book_id: params[:book_id],status:"rental")
    if history
      history.status = "putback"
      history.save
      flash[:notice] = "ありがとう！ほんは、ほんだなにもどしておいてね"
      redirect_to("/books/#{params[:book_id]}")
    else
      flash[:notice] = "このほんは、かりていません"
      redirect_to("/books/#{params[:book_id]}")
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
        File.binwirte("public/book_images/#{image_url}",image.read)
        @book.image_url = image_url
        @book.save
      end
      flash[:notice] = "本を登録しました"
      redirect_to("/books/putback")
    else
      render("/books/signup_form")
    end
  end
  
  def update_form
    @book = Book.find_by(id: params[:book_id])
    @name = @book.name
    @content = @book.content
  end
  
  def update
    @name = params[:name]
    @content = params[:content]
    @book = Book.find_by(id:params[:book_id])
    @book.name = @name
    @book.content = @content
    if @book.save
      if params[:image]
        image = params[:image]
        image_url = "#{@book.id}.jpg"
        File.binwirte("public/book_images/#{image_url}",image.read)
      end
      flash[:notice] = "本の情報を更新しました"
      redirect_to("/books/putback")
    else
      render("books/update_form")
    end
  end
  
  def delete
    book = Book.find_by(id: params[:book_id])
    histories = History.where(book_id: params[:book_id])
    if book.delete && histories.delete_all
      flash[:notice] = "本の情報を削除しました"
      redirect_to("/books/putback")
    else
      flash[:notice] = "本の情報を削除できませんでした"
      redirect_to("/books/putback")
    end
  end
  
end
