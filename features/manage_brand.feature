Feature: Manage Brands
  In order to track what everyone is saying about my brands
  As a user
  I want to manage my brands
  
  Scenario: A user sees the dashboard
    Given an existing brand "BDDCasts"
    When I am on the dashboard
    Then I should see "BDDCasts"
  
  Scenario: Add a new brand
    Given  I am on the dashboard
    When  I follow "Add brand"
    And I fill in "Name" with "BDDCasts"
    And I press "Create"
    Then I should see "Brand successfully created"
    And I should see "BDDCasts"
  
  Scenario: Update a brand
    Given an existing brand "BDDCasts"
    And I am on the dashboard
    When I follow "BDDCasts"
    And I fill in "Name" with "DDDCasts"
    And I press "Update"
    Then  I should see "Brand updated"
    And I should see "DDDCasts"

  Scenario: Delete a brand
    Given an existing brand "BDDCasts" 
    And I am on the dashboard
    When I follow "BDDCasts" 
    And I press "Delete"
    Then I should see "Brand deleted"
    And I should be on the dashboard
    And I should not see "BDDCasts"
 
  @wip
  Scenario: Add a search
    Given an existing brand "BDDCasts" 
    And I am on the dashboard
    And I follow "BDDCasts" 
    When I fill in "search_term" with "jschoolcraft"
    And I press "Add term"
    Then I should see "Search term added"
    And I should see "jschoolcraft"
 
