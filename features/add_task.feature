Feature: Add todo
  In order to be able to keep my in focus
  As a user
  I want to add tasks to lists

  Background:
    Given there's no file "/tmp/test-medo-tasks"

  Scenario: Add todo
    When I successfully run `medo --tasks-file=/tmp/test-medo-tasks new Hello World`
    And I successfully run `medo --tasks-file=/tmp/test-medo-tasks ls`
    Then the output should contain "Hello World"
