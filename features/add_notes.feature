Feature: Add note to task
  In order to be able to sketch some ideas
  As a user
  I want to add notes to my tasks

  Background:
    Given there's no file "/tmp/test-medo-tasks"

  Scenario: Add todo
    When I successfully run `medo --tasks-file=/tmp/test-medo-tasks new Hello World`
    And I successfully run `medo --tasks-file=/tmp/test-medo-tasks new Goodbye Windows`
    And I successfully run `medo --tasks-file=/tmp/test-medo-tasks note 1 "Trash the PC"`
    And I successfully run `medo --tasks-file=/tmp/test-medo-tasks note 2 The Note`
    And I successfully run `medo --tasks-file=/tmp/test-medo-tasks show 1`
    Then the output should contain "Trash the PC"
    And the output should not contain "The Note"
    When I successfully run `medo --tasks-file=/tmp/test-medo-tasks show 2`
    Then the output should contain "The Note"
