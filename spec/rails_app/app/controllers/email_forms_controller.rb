class EmailFormsController < ApplicationController
  before_filter :build_resource, only: [:new, :create]

  private

  def build_resource
    @resource = EmailForm.new(params[:email_form] || {})
  end
end
