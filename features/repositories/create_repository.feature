Feature: Create Repository
  In order to collaborate on a project
  As a user
  I want to be able to create new repositories.

  Background:
    Given I am an authenticated user
    And I am at the repositories page

  Scenario: Create a repository and have full permissions
    When I create a new repository with the name "fukusazushi"
    Then I should see a repository with the name "fukusazushi"
    And its repository url should end with "fukusazushi.git"
    And I should have full permissions to repository "fukusazushi"

  Scenario: Not allowed to create a repository with a taken name
    Given the following repositories exist:
    | nori |
    | neta |
    When I create a new repository with the name "neta"
    Then I should get an error message
