class UsersController < ApplicationController
  before_filter :authorize_admin!
  respond_to :html

  # GET /users
  def index
    @users = User.where("users.id != ?", current_user.id).all
    respond_with @users
  end

  # GET /users/1
  def show
    @user = User.find(params[:id])
    respond_with @user
  end

  # GET /users/new
  def new
    @user = User.new
    prepare_permissions

    respond_with @user
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    prepare_permissions
  end

  # POST /users
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html do
          redirect_to @user, notice: 'User was successfully created.'
        end
      else
        format.html do
          prepare_permissions
          render action: 'new'
        end
      end
    end
  end

  # PUT /users/1
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html do
          redirect_to @user, notice: 'User was successfully updated.'
        end
      else
        format.html do
          prepare_permissions
          render action: 'edit'
        end
      end
    end
  end

  # DELETE /users/1
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    respond_with @user
  end

  private

  def prepare_permissions
    # Find out which users already have a permission for this repository.
    repository_ids_with_permission = @user.permissions.map { |p| p.repository_id }
    Repository.all.each do |repository|
      unless repository_ids_with_permission.include?(repository.id)
        @user.permissions.build(repository_id: repository.id)
      end
    end
  end
end
