require 'spec_helper'

describe SearchesController do
  
  let (:search) { stub("search") }
  let (:search_attributes) { {'term' => "jschool"} }
  let (:brand) { stub("brand", :id => '1', :to_param => '1', :searches => stub("brand_search", :build => search)) }

  describe "#create" do
    before do 
      Brand.stubs(:find).returns(brand)
    end

    context "with any create" do
      before do
        search.stubs(:save)
        do_create
      end

      it 'should find the brand' do
        Brand.should have_received(:find).with(brand.id)
      end
      
      it { should assign_to(:brand).with(brand) }
    
      it 'should build a new search for brand' do
        brand.searches.should have_received(:build).with(search_attributes)
      end

      it "should save a search" do
        search.should have_received(:save)
      end

      it { should assign_to(:search).with(search) }
      it { should redirect_to(edit_brand_url(brand)) }
      it { should respond_with(:redirect) }
    end

    context "when the search saves successfully" do
      before do
        search.stubs(:save).returns(true)
        do_create
      end

      it { should set_the_flash.to(/added/) }
    end

    context "when the search fails to save" do
      before do
        search.stubs(:save).returns(false)
        do_create
      end

      it { should set_the_flash.to(/failed/) }
    end

    def do_create
      post :create, :brand_id => brand.id, :search => search_attributes
    end
  end

  context "#destroy" do
    before do 
      Brand.stubs(:find).returns(brand)
      brand.searches.stubs(:find).returns(search)
      search.stubs(:destroy)
      do_destroy
    end

    it 'should find the brand' do
      Brand.should have_received(:find).with(1)
    end

    it 'should find the search' do
      brand.searches.should have_received(:find).with(1)
    end

    it 'should destroy search' do
      search.should have_received(:destroy)
    end

    it { should redirect_to(edit_brand_url(brand)) }
    it { should set_the_flash.to(/deleted/) }

    def do_destroy
      delete :destroy, :brand_id => 1, :id => 1 
    end
  end

end
