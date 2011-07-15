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

  it "does not create duplicate entiries for the same URL" do
    @search_result = Factory(:search_result)
    lambda {
      Factory.build(:search_result, :url => @search_result.url).save
    }.should_not change(SearchResult, :count)
  end
end
