class ApplicationController < ActionController::Base
  require 'google_drive'
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token

  before_filter :cors_preflight_check
  after_filter :cors_set_access_control_headers

  def info
    session = GoogleDrive::Session.from_config('config.json')
    table = []
    (1..5).each do |index|
      ws = session.spreadsheet_by_key(Spreadsheet.all.first[:url]).worksheets[-index]
      table[index] = []
      (1..ws.num_rows).each do |row|
        table[index][row] = []
        (1..ws.num_cols).each do |col|
          table[index][row][col] = ws[row, col]
        end
      end
    end
    render json: { data: table }
  end

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token'
    headers['Access-Control-Max-Age'] = '1728000'
  end

  def cors_preflight_check
    if request.method == 'OPTIONS'
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version, Token'
      headers['Access-Control-Max-Age'] = '1728000'

      render :text => '', :content_type => 'text/plain'
    end
  end
end
