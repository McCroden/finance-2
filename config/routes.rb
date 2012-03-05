Finance::Application.routes.draw do

  devise_for :users

  root :to => 'portfolio#show'

  resource :portfolio, only: [:show], controller: 'Portfolio' do
    resources :stocks, except: [:index, :show]
  end

end
