Feature: Edit Repository
  In order to keep my repositories up to date
  As a user
  I want to be able to edit them.

  Background:
    Given I am an authenticated user
    And I have full permission for repository "makizushi"
    And I have full permission for repository "narezushi"
    And I am at the repositories page

  Scenario: I should be able to change a repository name
    When I rename the repository "makizushi" to "hosomaki"
    And I am at the repositories page
    Then I should see the following repositories:
      | narezushi  |
      | hosomaki   |
    And I should not see these repositories:
      | makizushi  |

  Scenario: I should not be able to have two repositories with the same name
    When I rename the repository "makizushi" to "narezushi"
    Then I should get an error message

  Scenario: I should be able to change permissions to a repository I have full permission for
    Given there is a user with email "jim@test.org"
    When I give "jim@test.org" "full" permission to repository "narezushi"
    Then "jim@test.org" should have "full" permission to repository "narezushi"
