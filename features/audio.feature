Feature: Audio
	
	Scenario: Adding a Song
  	Given I am on the shows page
  	And I have created a show and added a track URL to "Show 1"

	Scenario: Adding a song should make a timeline
  	Given I am on the shows page
    And I have created a show and added a track URL to "Show 1"
    And I visit the shows page
    And I follow "edit" within "[data-show-id='1']"
    Then I should see a timeline with the show id of 1

  @javascript
  Scenario: Song controls should not be visible if there is no song
  	Given I am on the shows page
  	And I fill in "Show name" with "Show 1"
    And I press "Save show"
    And I follow "edit" within "[data-show-id='1']"
    Then the controls should not be visible on the page
