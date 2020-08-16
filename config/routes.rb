Rails.application.routes.draw do
  
  get '/login' => 'users#login_form'
  post '/login' => 'users#login'
  post '/logout' => 'users#logout'
  
  post '/books/signup' => 'books#signup'
  get '/books/signup' => 'books#signup_form'
  post '/books/:book_id/update' => 'books#update'
  get '/books/:book_id/update' => 'books#update_form'
  post '/books/:book_id/delete' => 'books#delete'
  get '/books/rent' => 'books#index_rent'
  get '/books/putback' => 'books#index_putback'
  get '/books/:book_id' => 'books#show'
  post '/books/:book_id/rent' => 'books#rent'
  post '/books/:book_id/putback' => 'books#putback'
  
  post '/users/signup' => 'users#signup'
  get '/users/signup' => 'users#signup_form'
  post '/users/:user_id/update' => 'users#update'
  get '/users/:user_id/update' => 'users#update_form'
  post '/users/:user_id/delete' => 'users#delete'
  get '/users/:group/index' => 'users#index'
  get '/users/:user_id/rent' => 'users#index_rent'
  get '/users/:user_id/putback' => 'users#index_putback'

  get '' => "home#top"
  
end
