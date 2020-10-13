class SettingsController < ApplicationController
  def index
    @user = current_user
    @key = Key.new
    @keys = current_user.keys
  end

  def update_user_details
    @user = current_user

    # If either :password or :confirm_password are submitted we go for the
    # full update. Otherwise it's just an email change.
    unless params[:user][:password].empty? && params[:user][:password_confirmation].empty?
      attrs = params[:user]
    else
      attrs = params[:user].except(:password, :password_confirmation)
    end

    respond_to do |format|
      if @user.update_attributes(attrs)
        format.html do
          sign_in @user, bypass: true
          redirect_to settings_url, notice: 'Account details successfully updated.'
        end
      else
        format.html do
          @key = Key.new
          @keys = current_user.keys

          render action: 'index'
        end
      end
    end
  end

  def new_key
    @key = Key.new
    respond_to { |format| format.html }
  end

  def create_key
    @key = Key.new(params[:key])
    @key.user_id = current_user.id

    respond_to do |format|
      if @key.save
        format.html do
          redirect_to settings_url, notice: 'The SSH key was successfully added.'
        end
      else
        format.html do
          @user = current_user
          @keys = current_user.keys

          render action: 'new_key'
        end
      end
    end
  end

  def edit_key
    @key = current_user.keys.find(params[:id])
  end

  def update_key
    @key = current_user.keys.find(params[:id])

    respond_to do |format|
      if @key.update_attributes(params[:key])
        format.html do
          redirect_to settings_url, notice: 'The SSH key was updated.'
        end
      else
        format.html do
          @user = current_user
          @keys = current_user.keys

          render action: 'edit_key'
        end
      end
    end
  end

  def destroy_key
    @key = current_user.keys.find(params[:id])
    @key.destroy
    respond_to do |format|
      format.html { redirect_to settings_url }
    end
  end
end
