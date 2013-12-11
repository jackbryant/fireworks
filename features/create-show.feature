Feature:Create a show

Scenario: I can add multiple events to a show.
        Given there are "3" shows
        And I am on the shows page
        And I follow "edit" within "[data-show-id='3']"
        And I fill in "start" with "Fri Jan 01 2010 00:02:15 GMT+0000 (GMT)"
        And I fill in "content" with "Well hello there!!!"
        And I click "Save Event"

