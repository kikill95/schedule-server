Rails.application.routes.draw do
  root 'spreadsheets#index'
  resources :spreadsheets
  get 'info' => 'application#info'
end
