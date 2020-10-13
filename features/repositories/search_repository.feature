Feature: Search Repository
  In order to find the repository I am looking for
  As a user
  I want to be able to search through the list of repositories.

  Background:
    Given I am an authenticated user

  Scenario: Filter for a repository by name
    Given I have access to the following repositories:
      | uramaki      |
      | oshizushi    |
      | seattle_roll |
      | tampa_roll   |
    And I am at the repositories page
    When I search for a repository using the query "roll"
    Then I should see the following repositories:
      | seattle_roll |
      | tampa_roll   |
    And I should not see these repositories:
      | uramaki   |
      | oshizushi |
