require 'spec_helper'

describe BrandsController do

  describe "#index" do
    let (:brands) { [stub("brand")] }

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
    let (:brand) { stub("brand") }

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
    let (:brand) { stub("brand", :save => nil) }
    let (:brand_attributes) { {'name' => "Brand"} }

    before { Brand.stubs(:new).returns(brand) }

    context "with any create" do
      before { do_create }

      it 'should create a new brand' do
        Brand.should have_received(:new).with(brand_attributes)
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
end
