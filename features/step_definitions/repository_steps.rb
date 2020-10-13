Given /^I am an authenticated user$/ do
  authenticate_as_user
end

Given /^I am at the repositories page$/ do
  visit repositories_path
end

When /^I create a new repository with the name "([^"]*)"$/ do |name|
  create_repository(name)
end

Then /^I should see a repository with the name "([^"]*)"$/ do |name|
  page.should have_content(name)
end

Then /^its repository url should end with "([^"]*)"$/ do |git_name|
  repo_url = find('.repository-url').find('input').value
  repo_url.should match /#{Regexp.escape(git_name)}$/
end

Then /^I should have full permissions to repository "([^"]*)"$/ do |name|
  within('.repository') do
    within('.repository-main-info') do
      page.should have_content(name)
    end
    within('.repository-meta') do
      page.should have_content('Edit')
    end
  end
end

Given /^the following repositories exist:$/ do |table|
  table.raw.each do |row|
    FactoryGirl.create(:repository, name: row[0])
  end
end

Then /^I should get an error message$/ do
  detect_error_message
end

Given /^I have full permission for repository "([^"]*)"$/ do |name|
  r = FactoryGirl.create(:repository, name: name)
  FactoryGirl.create(:permission,
                     repository_id: r.id,
                     user_id: @user.id,
                     name: 'f')
end

When /^I delete repository "([^"]*)"$/ do |name|
  delete_repository(name)
end

Then /^I should not see these repositories:$/ do |table|
  table.raw.each do |row|
    within('div#repositories') do
      page.should_not have_content(row[0])
    end
  end
end

Then /^I should see the following repositories:$/ do |table|
  table.raw.each do |row|
    within('div#repositories') do
      page.should have_content(row[0])
    end
  end
end

When /^I rename the repository "([^"]*)" to "([^"]*)"$/ do |current_name, new_name|
  rename_repository(current_name, new_name)
end

Given /^there is a user with email "([^"]*)"$/ do |email|
  user = create_user(:user, email)
end

When /^I give "([^"]*)" "([^"]*)" permission to repository "([^"]*)"$/ do |user, permission, repository|
  give_permission(repository, permission, user)
end

Then /^"([^"]*)" should have "([^"]*)" permission to repository "([^"]*)"$/ do |user, permission, repository|
  check_permission(repository, permission, user)
end

Given /^I have access to the following repositories:$/ do |table|
  permissions = ['f', 'w', 'r']
  table.raw.each do |row|
    r = FactoryGirl.create(:repository, name: row[0])
    FactoryGirl.create(
      :permission,
      repository_id: r.id,
      user_id: @user.id,
      name: permissions.sample
    )
  end
end

When /^I search for a repository using the query "([^"]*)"$/ do |query|
  fill_in 'search', with: query
  click_on 'Search'
end
