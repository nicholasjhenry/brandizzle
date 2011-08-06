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

  describe "#remove_search" do
    before do
      @brand = Factory(:brand)
      @bar_search = @brand.add_search('bar')
    end
    
    it "removes the search from the brand" do
      @brand.remove_search(@bar_search)
      @brand.searches.map(&:term).should_not include('bar')
    end

    it "does not destroy the search if it is associated to any brand" do
      another_brand = Factory(:brand)
      search = another_brand.add_search('bar')
      lambda {
        @brand.remove_search(search)
      }.should_not change(Search, :count)
    end

    it "destroys the search if it is no longer associated to any brand" do
      lambda {
        @brand.remove_search(@bar_search)
      }.should change(Search, :count)
      Search.find_by_term('bar').should be_nil
    end

    it "does nothing for a search not associated with the brand" do
      another_brand = Factory(:brand)
      search = another_brand.add_search('foo')
      lambda {
        @brand.remove_search(search)
      }.should_not change(Search, :count)
    end
  end
end
