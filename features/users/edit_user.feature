Feature: Edit User
  In order to keep the system up to date
  As an admin
  I want to be able to edit users

  Background:
    Given I am an authenticated admin
    And a user with the email "zoe@test.org" exists

  Scenario: Edit the email of an existing user
    When I rename user "zoe@test.org" to "zoe_foo@test.org"
    Then I should see a message that the user has been updated

  Scenario: Make a user an Admin
    When I make the user "zoe@test.org" an admin
    Then I should see a message that the user has been updated

  Scenario: Give a user permission to a repository
    Given the following repositories exist:
    | california_roll |
    | hawaiian_roll   |
    And I am at user's "zoe@test.org" edit page
    When I give "zoe@test.org" "read" permission to repository "california_roll"
    Then "zoe@test.org" should have "read" permission to repository "california_roll"

