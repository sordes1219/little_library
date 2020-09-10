Rails.application.routes.draw do
  
  get '/login' => 'users#login_form'
  post '/login' => 'users#login'
  post '/logout' => 'users#logout'
  
  post '/books/signup' => 'books#signup'
  get '/books/signup' => 'books#signup_form'
  post '/books/:book_id/update' => 'books#update'
  get '/books/:book_id/update' => 'books#update_form'
  post '/books/:book_id/delete' => 'books#delete'
  get '/books/:status/index' => 'books#index'
  get '/books/:book_id' => 'books#show'
  post '/books/:book_id/rental' => 'books#rental'
  post '/books/:book_id/putback' => 'books#putback'
  
  post '/users/signup' => 'users#signup'
  get '/users/signup' => 'users#signup_form'
  post '/users/:user_id/update' => 'users#update'
  get '/users/:user_id/update' => 'users#update_form'
  post '/users/:user_id/delete' => 'users#delete'
  get '/users/:group/index' => 'users#index'
  get '/users/:user_id/:status' => 'users#book_status'
  
  get '/' => "home#top"
  get '/terms' => "users#terms"
  
end
