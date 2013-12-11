Feature: Fireworks 
 
  Scenario: I can add a firework
        Given I am on the fireworks page
        And I fill in "Name" with "Blaster"
        And I fill in "Colour" with "256"
        And I fill in "Delay" with "2000"
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

    Scenario: I can delete a firework
        Given there are "3" fireworks
        And I am on the fireworks page
        And I follow "remove" within "[data-firework-id='3']"
        Then I should see "Firework removed"
        And I should not see "Firework 3"