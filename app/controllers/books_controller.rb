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

end
