require 'spec_helper'

describe Search do
  it { should validate_presence_of :term }
  it { should belong_to :brand }
end
