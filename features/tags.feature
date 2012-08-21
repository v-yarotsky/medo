Feature: Add todo
  In order to be able to filter tasks
  As a user
  I want to assign a tag to any task

  Background:
    Given there's no file "/tmp/test-medo-tasks"

  Scenario: Add task with tag
    When I successfully run `medo --tasks-file=/tmp/test-medo-tasks new "[the-tag] Hello World"`
    And I successfully run `medo --tasks-file=/tmp/test-medo-tasks new "[the-other-tag] Bye World"`
    And I successfully run `medo --tasks-file=/tmp/test-medo-tasks list --tag the-tag`
    Then the output should contain "Hello World"
    And the output should not contain "Bye World"

