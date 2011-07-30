require 'spec_helper'

describe BrandsController do

  let (:brand) { stub('brand', :to_param => "1") }
  let (:brand_attributes) { {'name' => "Brand"} }
  let (:results) { (1..10).map { stub('search_result') } }
  
  describe "#index" do
    let (:brands) { [brand] }

    before do
      Brand.stubs(:all).returns(brands)
      SearchResult.stubs(:latest => stub(:page => results))
    end

    shared_examples_for "any #index" do

      it 'should find all the brands' do
        Brand.should have_received(:all)
      end
      it { should assign_to(:brands).with(brands) }
      it { should assign_to(:results).with(results) }

      it { should respond_with(:success) }
    end

    context "without filter" do

      before do
        get :index
      end

      it_behaves_like "any #index"

      it 'should find latest search results' do
        SearchResult.should have_received(:latest)
      end
    end

    context "with filter" do
      before do
        get :index, 'search'=> {'brand_id' => '1'}
      end

      it_behaves_like "any #index"

      it 'should find latest search results' do
        SearchResult.should have_received(:latest).with('brand_id' => '1')
      end
    end
  end

  describe "#new" do
    before do
      Brand.stubs(:new).returns(brand)
      get :new
    end

    it 'should build a new brand' do
      Brand.should have_received(:new)
    end
    
    it { should assign_to(:brand) }
    it { should respond_with(:success) }
  end

  describe "#create" do
    before { Brand.stubs(:new).returns(brand) }

    context "with any create" do
      before do
        brand.stubs(:save)
        do_create
      end

      it 'should build a new brand' do
        Brand.should have_received(:new).with(brand_attributes)
      end

      it "should save a brand" do
        brand.should have_received(:save)
      end

      it { should assign_to(:brand).with(brand) }
    end

    context "when the brand saves successfully" do
      before do
        brand.stubs(:save).returns(true)
        do_create
      end

      it { should respond_with(:redirect) }
      it { should set_the_flash.to(/created/) }
      it { should redirect_to(edit_brand_url(brand)) }
    end

    context "when the brand fails to save" do
      before do
        brand.stubs(:save).returns(false)
        do_create
      end

      it { should respond_with(:success) } 
      it { should render_template(:new) }
    end

    def do_create
      post :create, :brand => brand_attributes
    end
  end

  describe "#edit" do

    let (:search) { stub('search') }

    before do 
      Brand.stubs(:find).returns(brand)
      Search.stubs(:new).returns(search)
      do_edit
    end

    it "should find the brand" do
      Brand.should have_received(:find).with('1')
    end

    it "should build a new search" do
      Search.should have_received(:new)
    end

    it { should assign_to(:brand).with(brand) }
    it { should respond_with(:success) }
    it { should render_template(:edit) }

    def do_edit
      get :edit, :id => '1'
    end
  end

  describe "#update" do
    before do
      Brand.stubs(:find).returns(brand)
      brand.stubs(:update_attributes)
    end

    context "any update" do
      before { do_update }

      it "should find the brand" do
        Brand.should have_received(:find).returns(brand)
      end

      it "should update the brand" do
        brand.should have_received(:update_attributes).with(brand_attributes)
      end
    end

    context "when the brand successfully updates" do
      before do
        brand.stubs(:update_attributes).returns(true)
        do_update
      end

      it { should assign_to(:brand).with(brand) }
      it { should redirect_to(edit_brand_url(brand)) }
      it { should set_the_flash.to(/updated/) }
    end

    context "when the brand fails to update" do
      before do
        brand.stubs(:udpate_attributes).returns(false)
        do_update
      end

      it { should respond_with(:success) }
      it { should render_template(:edit) }
    end

    def do_update
      put :update, :id => '1', :brand => brand_attributes 
    end
  end

  describe "#destroy" do
    before do
      Brand.stubs(:find).returns(brand)
      brand.stubs(:destroy)
      do_destroy
    end

    it "should find the brand" do
      Brand.should have_received(:find).with(1)
    end

    it "should destroy the brand" do
      brand.should have_received(:destroy)
    end
    
    it { should redirect_to(brands_path) }
    it { should set_the_flash.to(/deleted/) }

    def do_destroy
      delete :destroy, :id => 1 
    end
  end
end
