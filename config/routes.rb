Rails.application.routes.draw do
  
  get '/login' => 'users#login_form'
  post '/login' => 'users#login'
  post '/logout' => 'users#logout'
  
  get '/books/rent' => 'books#index_rent'
  get '/books/putback' => 'books#index_putback'
  
  get '/books/:book_id' => 'books#show'
  post '/books/:book_id/rent' => 'books#rent'
  post '/books/:book_id/putback' => 'books#putback'
  
  get 'users/:user_id/rent' => 'users#index_rent'
  get 'users/:user_id/putback' => 'users#index_putback'
  
  
  get '' => "home#top"
  
end
