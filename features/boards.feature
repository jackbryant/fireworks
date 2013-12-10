Feature: Boards 
 
  Scenario: I can add a new board
        Given I am on the shows page
        And I fill in "Board name" with "Board 1"
        And I press "Save board"
        Then I should see "New board added"

  Scenario: I can see a list of boards 
        Given there are "4" boards
        And I am on the shows page
        Then I should see "Your Boards"
        And I should see "Board 1"
        And I should see "Board 4"