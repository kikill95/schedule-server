class ApplicationController < ActionController::Base
  require 'remote_table'
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token

  def info
    table = RemoteTable.new(
      "https://spreadsheets.google.com/pub?key=#{Spreadsheet.all.first[:url]}&output=csv",
      :headers => false).rows
    render json: { data: table }
  end
end
