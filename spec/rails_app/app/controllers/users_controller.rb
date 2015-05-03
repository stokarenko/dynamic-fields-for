class UsersController < ApplicationController
  before_action :build_resource, only: [:new, :create]
  before_action :load_resource, only: [:edit_without_fields, :edit, :update]

  def new
    3.times{ @resource.roles.build }
  end

  def create
    @resource.update_attributes!(resource_params)
    redirect_to edit_user_path(@resource)
  end

  def update
    @resource.update_attributes!(resource_params)
    redirect_to edit_user_path(@resource)
  end

  private

  def scope
    User
  end

  def build_resource
    @resource = scope.new
  end

  def load_resource
    @resource = scope.find(params[:id])
  end

  def resource_params
    params.require(:user).permit(:user_name, roles_attributes: [:id, :role_name, :_destroy])
  end
end
