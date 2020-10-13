Feature: Create User
  In order to collaborate on a project
  As an admin
  I want to be able to create new users

  Background:
    Given I am an authenticated admin

  Scenario: Create a new user
    Given I am at the users page
    When I create a new user with the email "zoe@test.org"
    Then I should see a message that the user has been created

  Scenario: Can not create a new user with the email of an existing user
    Given a user with the email "zoe@test.org" exists
    And I am at the users page
    When I create a new user with the email "zoe@test.org"
    Then I should see an error message

