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

   Scenario: I can delete a board
        Given there are "3" boards
        And I am on the shows page
        And I follow "remove" within "[data-board-id='3']"
        Then I should see "Board removed"
        And I should not see "Board 3"