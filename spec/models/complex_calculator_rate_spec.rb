require File.dirname(__FILE__) + '/../spec_helper'

describe ComplexCalculatorRate do
  before(:each) do
    @complex_calculator_rate = ComplexCalculatorRate.new
  end

  it "should be valid" do
    @complex_calculator_rate.should be_valid
  end
end
