Feature: Dashboard
  In order to get a quick snapshot view of what is going on with by brand 
  I want to see search results in a dashboard

  Background:
    Given  an existing brand "BDDCasts"
    And there is a search "bdd screencast" for "BDDCasts"

  Scenario: Looking at the dasboard
    Given "bdd screencast" has the following search results:
      | source  | body                                  | url                         | created_at        |
      | twitter | does anyone know any bdd screencasts? | http://twitter/statuses/123 | 09 Jul 2009 13:28 |
      | twitter | bdd screencasts anyone?               | http://twitter/statuses/456 | 09 Jul 2009 15:16 |
      | twitter | awesome bdd screencast blah blah      | http://twitter/statuses/789 | 09 Jul 2009 18:25 |
    When I am on the dashboard
    Then I should see the following search results:
      | message                               | created_at          |
      | does anyone know any bdd screencasts? | July 09, 2009 13:28 |
      | bdd screencasts anyone?               | July 09, 2009 15:16 |
      | awesome bdd screencast blah blah      | July 09, 2009 18:25 |

  Scenario: Looking at the dashboard with no search results
    When I am on the dashboard
    Then  I should see "No results."
