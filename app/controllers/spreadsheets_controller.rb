class SpreadsheetsController < ApplicationController
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

  private

  def strong_params
    params.require(:spreadsheet).permit!
  end
end
