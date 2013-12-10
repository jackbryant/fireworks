Feature: Fireworks 
 
  Scenario: I can add a firework
        Given I am on the fireworks page
        And I fill in "Firework name" with "Blaster"
        And I fill in "Firework colour" with "256"
        And I fill in "Firework delay" with "2000"
        And I press "Save firework"
        Then I should see "New firework added"

  Scenario: I can see a list of fireworks 
        Given there are "3" fireworks
        And I am on the fireworks page
        Then I should see "Fireworks list"
        And I should see "Firework 1"
        And I should see "Firework 2"

   Scenario: I can navigate back to the shows page
        Given I am on the fireworks page
        And I click "Your shows"
        Then I should see "Show list"