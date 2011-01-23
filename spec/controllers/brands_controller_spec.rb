require 'spec_helper'

describe BrandsController do

  describe "#index" do
    let (:brands) { [Factory.build(:brand)] }

    before do
      Brand.stubs(:all).returns(brands)
      get :index 
    end

    it 'should find all the brands' do
      Brand.should have_received(:all)
    end

    it { should assign_to(:brands).with(brands) }

    it { should render_template(:index) }
  end
end
