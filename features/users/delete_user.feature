Feature: Delete User
  In order to maintain the system
  As an admin
  I want to be able to delete existing users

  Background:
    Given I am an authenticated admin

  Scenario: Delete an existing user
    Given a user with the email "zoe@test.org" exists
    And I am at the users page
    When I delete user "zoe@test.org"
    Then I should not see user "zoe@test.org" in the users page
