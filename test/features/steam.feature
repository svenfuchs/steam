Feature: Steam
	Scenario: Cucumber integration
		When I go to the users index page
		Then I should see a list of users
		And jquery should have set the document title to "FOO"
