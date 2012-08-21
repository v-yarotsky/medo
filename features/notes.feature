Feature: Manage task notes
  In order to be able to sketch some ideas
  As a user
  I want to add and edit notes to my tasks

  Background:
    Given there's no file "/tmp/test-medo-tasks"

  Scenario: Add todo note
    When I successfully run `medo --tasks-file=/tmp/test-medo-tasks new Hello World`
    And I successfully run `medo --tasks-file=/tmp/test-medo-tasks new Goodbye Windows`
    And I successfully run `medo --tasks-file=/tmp/test-medo-tasks note add -n 1 "Trash the PC"`
    And I successfully run `medo --tasks-file=/tmp/test-medo-tasks note add -n 2 The Note`
    And I successfully run `medo --tasks-file=/tmp/test-medo-tasks show`
    Then the output should contain "Trash the PC"
    And the output should not contain "The Note"
    When I successfully run `medo --tasks-file=/tmp/test-medo-tasks show -n 2`
    Then the output should contain "The Note"

  Scenario: Edit todo note
    When I successfully run `medo --tasks-file=/tmp/test-medo-tasks new Hello World`
    And I successfully run `medo --tasks-file=/tmp/test-medo-tasks note add "Trash the PC"`
    When I successfully run `medo --tasks-file=/tmp/test-medo-tasks note edit boom`
    And I successfully run `medo --tasks-file=/tmp/test-medo-tasks show`
    Then the output should not contain "Trash the PC"
    And the output should contain "boom"

  Scenario: Parse inline notes
    When I successfully run `medo --tasks-file=/tmp/test-medo-tasks new "Hello\nWorld\n\nThe Notes"`
    And I successfully run `medo --tasks-file=/tmp/test-medo-tasks show`
    Then the output should contain exactly:
    """
    Task added
    Hello
      World

      The Notes


    """

