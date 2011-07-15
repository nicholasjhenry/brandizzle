Given /^there is a search "([^"]*)" for "([^"]*)"$/ do |term, brand_name|
  brand = Brand.find_by_name(brand_name)
  brand.searches.create!(:term => term)
end

When /^I delete search term for "([^"]*)"$/ do |search_term|
  search = Search.find_by_term(search_term)
  click_button("delete_search_#{search.id}")
end

Given /^"([^"]*)" has the following search results:$/ do |search_term, table|
  search = Search.find_by_term(search_term)
  table.hashes.each do |result|
    search.results.create!(result)
  end
end

Then /^I should see the following search results:$/ do |table|
  # TODO: Better scoping
  within('#results') do
    table.hashes.each do |result|
      page.should have_content(result["message"])
      page.should have_content(result["created_at"])
    end
  end
end

Given /^"([^"]*)" has (\d+) search results$/ do |search_term, number_of_results|
  search = Search.find_by_term(search_term)
  1.upto(number_of_results.to_i) do |index|
    search.results.create!(:body => "Search result ##{index}", :url => "http://example#{index}", :created_at => index.hours.ago )
  end
end
