module UIAutomation
  ### Repositories
  def create_repository(name)
    click_link 'New Repository'
    fill_in 'Name', with: name
    click_on 'Create Repository'
  end

  def delete_repository(name)
    edit_repository(name)
    click_on 'Delete'
  end

  def edit_repository(name)
    within("div#repository-#{name}") do
      click_on 'Edit'
    end
  end

  def rename_repository(current_name, new_name)
    edit_repository(current_name)
    fill_in 'Name', with: new_name
    click_on 'Done'
  end

  ### Permissions
  def give_permission(repository, permission, user)
    # Different action depending on where we are.
    if current_path == edit_user_path(User.find_by_email(user))
      path = "//*[contains(.,'#{repository}')]/../td[contains(@class, 'row-value')]/select"
    else
      visit repositories_path
      click_on "#{repository}"
      click_on 'Edit'
      path = "//*[contains(.,'#{user}')]/../td[contains(@class, 'row-value')]/select"
    end
    find(:xpath, path).select(permission.downcase.capitalize)
    click_on 'Done'
  end

  def check_permission(repository, permission, user)
    visit repositories_path
    click_on repository
    path = "//*[contains(.,'#{user}')]/../td[text()='#{permission.downcase.capitalize}']"
    page.should have_xpath(path)
  end

  ### Authentication
  def create_user(user_type, email='testing@test.org')
    FactoryGirl.create(:user, admin: (user_type == :admin), email: email)
  end

  def authenticate_as_user
    @user = create_user(:user)
    login(@user)
  end

  def authenticate_as_admin
    @admin = create_user(:admin)
    login(@admin)
  end

  def login(user)
    visit '/users/sign_in'
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_button 'Sign in'
  end
end

### Errors
def detect_error_message
  page.should have_css('div#error_explanation')
end

World(UIAutomation)
