require 'spec_helper'

describe Brand do
  it { should validate_presence_of(:name) }
  it { should have_and_belong_to_many(:searches) }

  describe "#add_search" do
    before do
      @brand = Factory(:brand)
    end

    it "creates a new search associated if it does not exist yet" do
      lambda {
        @brand.add_search('foo')
      }.should change(Search, :count)
      @brand.searches.map(&:term).should include('foo')
    end

    it "for an existing search it associats it with the brand and does not create a new search" do
      @search = Factory(:search, :term => :foo)

      lambda {
        @brand.add_search('foo')
      }.should_not change(Search, :count)
      @brand.searches.map(&:term).should include('foo')
    end
  end
end
