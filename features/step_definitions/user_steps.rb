Given /^I am an authenticated admin$/ do
  authenticate_as_admin
end

Given /^I am at the users page$/ do
  visit users_path
end

When /^I create a new user with the email "([^"]*)"$/ do |email|
  click_on 'New User'
  fill_in 'Email', with: email
  click_on 'Create User'
end

Then /^I should see a message that the user has been created$/ do
  page.should have_content('successfully created')
end

Given /^a user with the email "([^"]*)" exists$/ do |email|
  create_user(:user, email)
end

Then /^I should see an error message$/ do
  detect_error_message
end

When /^I delete user "([^"]*)"$/ do |email|
  click_on email
  click_on 'Edit'
  click_on 'Delete'
end

Then /^I should not see user "([^"]*)" in the users page$/ do |email|
  visit users_path
  page.should_not have_content(email)
end

When /^I rename user "([^"]*)" to "([^"]*)"$/ do |current_email, new_email|
  unless current_path == edit_user_path(User.find_by_email(current_email))
    visit users_path
    click_on current_email
  end
  click_on 'Edit'
  fill_in 'Email', with: new_email
  click_on 'Done'
end

When /^I make the user "([^"]*)" an admin$/ do |email|
  unless current_path == edit_user_path(User.find_by_email(email))
    visit users_path
    click_on email
  end
  click_on 'Edit'
  check('user_admin')
  click_on 'Done'
end

Then /^I should see a message that the user has been updated$/ do
  page.should have_content('successfully updated')
end

Given /^I am at user's "([^"]*)" edit page$/ do |email|
  visit edit_user_path(User.find_by_email(email))
end
