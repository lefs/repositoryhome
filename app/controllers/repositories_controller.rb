class RepositoriesController < ApplicationController
  respond_to :html

  # GET /repositories
  def index
    @host = request.host
    @user_has_searched = params[:search] ? true : false
    if current_user.admin?
      @repositories = Repository.search(params[:search])
    else
      @repositories =
        current_user.repositories.with_permission.search(params[:search])
    end
    @number_of_repositories = @repositories.length
    respond_with @repositories
  end

  # GET /repositories/1
  def show
    @host = request.host
    @repository = find_repository(params[:id])
    unless current_user.admin?
      @permission = @repository.permissions.find_by_user_id(current_user).name
    end
    respond_with @repository
  end

  # GET /repositories/new
  def new
    @repository = Repository.new
    prepare_permissions

    respond_with @repository
  end

  # GET /repositories/1/edit
  def edit
    @host = request.host
    @repository = find_repository(params[:id])
    authorize_edit!
    prepare_permissions
  end

  # POST /repositories
  def create
    @repository = Repository.new(params[:repository])

    # Add full permission for the current user (if not an admin).
    unless current_user.admin?
      @repository.permissions.build(user_id: current_user.id, name: 'f')
    end

    respond_to do |format|
      if @repository.save
        format.html do
          redirect_to @repository, notice: 'Repository was successfully created.'
        end
      else
        format.html do
          prepare_permissions
          render action: 'new'
        end
      end
    end
  end

  # PUT /repositories/1
  def update
    @repository = find_repository(params[:id])
    authorize_edit!

    respond_to do |format|
      if @repository.update_attributes(params[:repository])
        format.html do
          redirect_to @repository, notice: 'Repository was successfully updated.'
        end
      else
        format.html do
          prepare_permissions
          render action: 'edit'
        end
      end
    end
  end

  # DELETE /repositories/1
  def destroy
    @repository = find_repository(params[:id])
    authorize_edit!

    @repository.destroy
    respond_with @repository
  end

  private

  def find_repository(id)
    current_user.admin? ? Repository.find(id) : current_user.repositories.find(id)
  end

  def prepare_permissions
    # Find out which users already have a permission for this repository.
    user_ids_with_permission = @repository.permissions.map { |p| p.user_id }
    User.non_admins.each do |user|
      unless user_ids_with_permission.include?(user.id)
        @repository.permissions.build(user_id: user.id)
      end
    end
  end

  def authorize_edit!
    authenticate_user!

    if current_user.admin?
      user_has_sufficient_permission = true
    else
      permission =
        current_user.permissions.where(repository_id: @repository).first
      if permission
        user_has_sufficient_permission = permission.name == 'f'
      else
        user_has_sufficient_permission = false
      end
    end

    return if user_has_sufficient_permission

    flash[:alert] =
      'You do not have sufficient permissions to edit this repository.'
    redirect_to @repository
  end
end
