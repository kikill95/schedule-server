class SpreadsheetsController < ApplicationController
  require 'google/api_client'
  require 'google_drive'

  http_basic_authenticate_with(
    name: Rails.application.secrets.admin_name,
    password: Rails.application.secrets.admin_pass
  )
  expose(:spreadsheet)

  def create
    Spreadsheet.create(strong_params).save!
  end

  def update
    Spreadsheet.all.first.update(strong_params)
  end

  def info
    session = GoogleDrive.saved_session('config.json')
    ws = session.spreadsheet_by_key(Spreadsheet.all.first[:url]).worksheets[0]
    # Dumps all cells.
    document = []
    (1..ws.num_rows).each do |row|
      document[row] = []
      (1..ws.num_cols).each do |col|
        document[row][col] = ws[row, col]
      end
    end

    render json: { data: document }
  end

  private

  def strong_params
    params.require(:spreadsheet).permit!
  end
end
