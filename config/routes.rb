Rails.application.routes.draw do
  root 'spreadsheets#index'
  resources :spreadsheets
end
