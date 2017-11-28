Rails.application.routes.draw do
root 'users#index'

get '/users/new', to: 'users#new', as: 'new_user'
post '/user', to: 'users#create', as: 'sign_up'
get 'users/:id', to: 'users#show', as: 'user'

get '/login', to: 'sessions#new'
get '/logout', to: 'sessions#destroy'
post '/sessions', to: 'sessions#create'
end
