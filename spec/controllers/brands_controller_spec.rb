require 'spec_helper'

describe BrandsController do

  describe "#index" do
    let (:brands) do
      [Factory.build(:brand)]
    end

    before do
      Brand.stubs(:all).returns(brands)
      get :index 
    end

    it 'should find all the brands' do
      Brand.should have_received(:all)
    end

    it 'should assign them for the view' do
      should assign_to(:brands).with(brands)
    end

    it 'should render the index template' do
      should render_template(:index) 
    end
  end
end
