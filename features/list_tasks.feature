Feature: List tasks
  In order to keep myseld focused
  As a user
  I want to be able to view my current tasks

  Scenario: List tasks
    Given I have the following tasks in "/tmp/test-medo-tasks"
    """
    [
      {"done": false, "description": "Buy Milk", "created_at": "2012-01-05 12:36:00 +0300", "completed_at": null, "notes": ["at least 6% fat"]},
      {"done": true, "description": "Buy Butter", "created_at": "2012-01-05 12:40:00 +0300", "completed_at": "2012-01-05 13:00:00 +0300", "notes": []}
    ]

    """
    When I successfully run `medo --no-color --tasks-file="/tmp/test-medo-tasks"`
    Then the output should contain "Buy Milk"
    And the output should contain "Buy Butter"

  Scenario: There are no tasks
    Given I have the following tasks in "/tmp/test-medo-tasks"
    """

    """
    When I successfully run `medo --no-color --tasks-file="/tmp/test-medo-tasks"`
    Then the output should contain "no tasks"
