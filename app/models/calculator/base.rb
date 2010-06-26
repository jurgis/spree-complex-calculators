class Calculator::Base < Calculator
  has_many :complex_calculator_rates, :as => :calculator, :dependent => :destroy
  
  accepts_nested_attributes_for :complex_calculator_rates, :allow_destroy => true,
                                :reject_if => lambda {|attr| attr[:from_value].blank? && attr[:to_value].blank? && attr[:rate].blank?}
  
  before_save :set_is_complex

  # Register the calculator
  def self.register
    super
    Coupon.register_calculator(self)
    ShippingMethod.register_calculator(self)
    ShippingRate.register_calculator(self)
  end

  # Return calculator name
  def name
    calculable.respond_to?(:name) ? calculable.name : calculable.to_s
  end

  # supported types for the specified calculator (weight, qnty, ...)
  def supported_types
    ComplexCalculatorRate.all_types
  end
  
  def sorted_rates
    complex_calculator_rates.all(:order => "rate_type ASC, from_value ASC")
  end
  
  protected  

  # Get the rate from the database or nil if could not find the rate for specified rate type
  def get_rate(value, rate_type)
    ComplexCalculatorRate.find_rate(self.id, rate_type, value)
  end
  
  # Get the previous rate if rate for the specified value does not exist, return nil if no previous rate can be find
  def get_previous_rate(value, rate_type)
    ComplexCalculatorRate.find_previous_rate(self.id, rate_type, value)
  end
  
  # Before saving the record set that this is a complex calculator
  def set_is_complex
    self.is_complex = true
  end
  
  # get line items
  def order_to_line_items(order_or_line_items)
    order_or_line_items.is_a?(Order) ? order_or_line_items.line_items : order_or_line_items
  end
end