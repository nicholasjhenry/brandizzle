require 'spec_helper'

describe SearchResult do

  context "validation" do
    before { Factory(:search_result) }

    it { should belong_to :search }
    it { should validate_uniqueness_of :url }
  end

  it "should find the latest" do
    result_1 = Factory(:search_result, :created_at => 1.hour.ago)
    result_2 = Factory(:search_result, :created_at => 3.hour.ago)
    result_3 = Factory(:search_result, :created_at => 2.hour.ago)

    SearchResult.latest.should == [result_1, result_3, result_2]
  end

  it "should find by brand" do
    brand_1 = Factory(:brand)
    search_1 = Factory.build(:search)
    brand_1.searches << search_1
    result_1 = Factory.build(:search_result)
    result1 = search_1.results << result_1

    brand_2 = Factory(:brand)
    search_2 = Factory.build(:search)
    brand_2.searches << search_2
    result_2 = Factory.build(:search_result)
    search_2.results << result_2

    SearchResult.by_brand(brand_2.id).should == [result_2]
  end

  it "should find the latest by brand" do
    search_results = stub("search results", :by_brand => nil)
    SearchResult.stubs(:latest).returns(search_results)

    SearchResult.latest_by_brand(1)

    SearchResult.should have_received(:latest)
    search_results.should have_received(:by_brand).with(1)
  end

  it "does not create duplicate entries for the same URL" do
    @search_result = Factory(:search_result)
    lambda {
      Factory.build(:search_result, :url => @search_result.url).save
    }.should_not change(SearchResult, :count)
  end

end
