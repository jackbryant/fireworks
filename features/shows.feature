Feature: Shows 
 
  Scenario: I can add a show
        Given I am on the shows page
        And I fill in "Show name" with "Show 1"
        And I press "Save show"
        Then I should see "New show created"

  Scenario: I can see a list of shows 
        Given there are "3" shows
        And I am on the shows page
        Then I should see "Show list"
        And I should see "Show 1"
        And I should see "Show 2"

  Scenario: I can navigate to adding a new firework
        Given I am on the shows page
        And I click "Add firework"
        Then I should see "The fireworks"

  Scenario: I can delete a show
        Given there are "3" shows
        And I am on the shows page
        And I follow "remove" within "[data-show-id='3']"
        Then I should see "Show removed"
        And I should not see "Show 3"

  Scenario: I can navigate to edit show
        Given there are "3" shows
        And I am on the shows page
        And I follow "edit" within "[data-show-id='3']"
        Then I should see "Edit Show 3"
   

