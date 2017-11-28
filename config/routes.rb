Rails.application.routes.draw do
root 'users#index'

get '/users/new', to: 'users#new', as: 'new_user'
post '/users', to: 'users#create'
get 'users/:id', to: 'users#show', as: 'user'

get '/login', to: 'sessions#new'
post '/sessions', to: 'sessions#create'
end
