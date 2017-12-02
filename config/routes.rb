Rails.application.routes.draw do
root 'users#index'

get '/users/new', to: 'users#new', as: 'new_user'
post '/user', to: 'users#create', as: 'sign_up'
get 'users/:id', to: 'users#show', as: 'user'

get '/login', to: 'sessions#new', as: 'login'
post '/login', to: 'sessions#create'
delete '/logout', to: 'sessions#destroy'
get '/about', to: 'sessions#index', as: 'about'

get '/documents/index', to: 'documents#index', as: 'document_index'
get '/documents/new', to: 'documents#new', as: 'document_new'
post '/documents/new', to: 'documents#create'
get '/documents/download', to: 'documents#download_origin'
get '/documents/download/fixed', to: 'documents#download_fixed'
delete '/documents/destroy/:id', to: 'documents#destroy', as: 'document_destroy'
get '/documents/:id', to: 'documents#show', as: 'document_show'
put '/documents/:id', to: 'documents#update'
put '/documents/fix/:id', to: 'documents#fix', as: 'document_fix'


end
