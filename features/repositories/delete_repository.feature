Feature: Delete Repository
  In order to get rid of a repository I no longer need
  As a user
  I want to be able to delete it.

  Admins have access to all repositories in the system. Simple users
  can have Read, Read/Write, or Full permission. Full permission lets
  a user to rename or delete a repository.

  Scenario: Delete a repository as a simple user
    Given I am an authenticated user
    And I have full permission for repository "temaki"
    And I am at the repositories page
    When I delete repository "temaki"
    Then I should not see these repositories:
      | temaki  |
