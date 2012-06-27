Feature: Edit todo
  In order to be able to correct a mistake
  As a user
  I want to be able to edit task description

  Background:
    Given there's no file "/tmp/test-medo-tasks"

  Scenario: Add todo
    When I successfully run `medo --tasks-file=/tmp/test-medo-tasks new Hello World`
    When I successfully run `medo --tasks-file=/tmp/test-medo-tasks edit Goodbye World`
    And I successfully run `medo --tasks-file=/tmp/test-medo-tasks ls`
    Then the output should contain "Goodbye World"
    And the output should not contain "Hello World"
