require 'spec_helper'

describe BrandsController do

  let (:brand) { stub('brand') }
  
  describe "#index" do
    let (:brands) { [brand] }

    before do
      Brand.stubs(:all).returns(brands)
      get :index 
    end

    it 'should find all the brands' do
      Brand.should have_received(:all)
    end

    it { should assign_to(:brands).with(brands) }
    it { should respond_with(:success) }
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
    let (:brand_attributes) { {'name' => "Brand"} }

    before { Brand.stubs(:new).returns(brand) }

    context "with any create" do
      before do
        brand.stubs(:save)
        do_create
      end

      it 'should create a new brand' do
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

    before do 
      Brand.stubs(:find).returns(brand)
      do_edit
    end

    it "should find the brand" do
      Brand.should have_received(:find).with('1')
    end

    it { should assign_to(:brand).with(brand) }
    it { should respond_with(:success) }
    it { should render_template(:edit) }

    def do_edit
      put :edit, :id => '1'
    end
  end
end
