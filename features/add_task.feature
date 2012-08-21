Feature: Add todo
  In order to be able to keep myself focused
  As a user
  I want to add tasks to lists

  Background:
    Given there's no file "/tmp/test-medo-tasks"

  Scenario: Add todo
    When I successfully run `medo --tasks-file=/tmp/test-medo-tasks new Hello World`
    Then the output should contain "Task added"
