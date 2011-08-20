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

  Scenario: Paginating search results
    Given "bdd screencast" has 20 search results
    When I am on the dashboard
    Then I should see "Search result #1"
    And I should see "Search result #15"
    And I should not see "Search result #16"
    When I follow "2"
    Then I should see "Search result #16"
    And I should not see "Search result #15"

  Scenario: Fitler dashboard results by Brand
    Given there is a search "foo" for "Bar"
    And "bdd screencast" has the following search results:
      | source  | body                                  | url                         | created_at        |
      | twitter | Does anyone know any bdd screencasts? | http://twitter/statuses/123 | 09 Jul 2009 13:28 |
    And "foo" has the following search results:
      | source  | body                                       | url                         | created_at        |
      | twitter | Isn't foo the awesomest variable name evar | http://twitter/statuses/456 | 09 Jul 2009 13:28 |
    When I am on the dashboard
    And I select "BDDCast" from "Brand"
    And I press "Filter"
    Then I should see "Does anyone know any bdd screencasts?"
    And I should not see "Isn't foo the awesomest variable name evar"

  Scenario: Fitler dashboard results by Source
    Given "bdd screencast" has the following search results:
      | source  | body                                  | url                         | created_at        |
      | twitter | Does anyone know any bdd screencasts? | http://twitter/statuses/123 | 09 Jul 2009 13:28 |
      | blog    | This blog is the stuff                | http://blog/123             | 10 Jul 2009 13:28 |
    And I am on the dashboard
    When I select "twitter" from "Source"
    And I press "Filter"
    Then I should see "Does anyone know any bdd screencasts?"
    And I should not see "This blog is the stuff"
