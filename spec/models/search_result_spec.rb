require 'spec_helper'

describe SearchResult do
  it { should belong_to :search }

  it "should find the latest" do
    result_1 = Factory(:search_result, :created_at => 1.hour.ago)
    result_2 = Factory(:search_result, :created_at => 3.hour.ago)
    result_3 = Factory(:search_result, :created_at => 2.hour.ago)

    SearchResult.latest.should == [result_1, result_3, result_2]
  end
end
