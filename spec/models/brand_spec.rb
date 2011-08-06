require 'spec_helper'

describe Brand do
  it { should validate_presence_of(:name) }
  it { should have_and_belong_to_many(:searches) }

  describe "#add_search" do
    let (:brand) { Factory(:brand) }

    context "when search does not exist" do
      it "creates a new search" do
        lambda {
          brand.add_search('foo')
        }.should change(Search, :count)
      end

      it "associates the search with brand" do
        brand.add_search('foo')

        brand.searches.map(&:term).should include('foo')
      end
    end

    context "with an existing search" do
      before do
        Factory(:search, :term => :foo)
      end

      it "should not create a new search" do
        lambda {
          brand.add_search('foo')
        }.should_not change(Search, :count)
      end

      it "associates it with the brand" do
        brand.add_search('foo')

        brand.searches.map(&:term).should include('foo')
      end
    end
  end

  describe "#remove_search" do
    let (:brand) { Factory(:brand) }
    let (:another_brand) { Factory(:brand) }

    before do
      @bar_search =  brand.add_search('bar')
    end
    
    context "when a search exists is not associated with another brand" do
      it "removes the search from the brand" do
        brand.remove_search(@bar_search)
        brand.searches.map(&:term).should_not include('bar')
      end
    end

    context "when a search term is associated with another brand" do
      before do
        @another_bar_search = another_brand.add_search('bar')
      end

      it "does not destroy the search" do
        lambda {
          brand.remove_search(@bar_search)
        }.should_not change(Search, :count)
      end
    end

    context "when search term is not associated with the brand" do
      before do
        @foo_search = another_brand.add_search('foo')
      end

      it "does nothing" do
        lambda {
          brand.remove_search(@foo_search)
        }.should_not change(Search, :count)
      end
    end
  end
end
