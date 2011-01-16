require 'spec_helper'

describe PagesController do

  describe "#show" do
    %w(about).each  do |page|
      context page do
        before { get :show, :id => page}
        it { should render_template("pages/show/#{page}") }
        it { should respond_with(:success) }
      end
    end

    context "page not found" do
      before { get :show, :id => 'does-not-exist' }
      it { should respond_with(:missing) }
    end
  end
end
