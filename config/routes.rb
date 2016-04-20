Rails.application.routes.draw do
  root 'spreadsheets#index'
  resources :spreadsheets
  get 'info' => 'spreadsheets#info'
end
