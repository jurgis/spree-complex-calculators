class Calculator::Base < Calculator
  has_many :complex_calculator_rates, :as => :calculator, :dependent => :destroy
  
  accepts_nested_attributes_for :complex_calculator_rates, :allow_destroy => true,
                                :reject_if => lambda {|attr| attr[:from_value].blank? && attr[:to_value].blank? && attr[:rate].blank?}
  
  before_save :set_is_complex

    
  # Register the calculator
  def self.register
    super
    ShippingMethod.register_calculator(self)
    
    # Not sure if I need to register all those calculators
    # Coupon.register_calculator(self)
    # ShippingRate.register_calculator(self)    
  end

  # Return calculator name
  def name
    calculable.respond_to?(:name) ? calculable.name : calculable.to_s
  end

  def unit
    self.class.unit
  end
  
  # supported types for the specified calculator (weight, count, ...)
  def supported_types
    ComplexCalculatorRate.all_types
  end
  
  def sorted_rates
    complex_calculator_rates.all(:order => "rate_type ASC, from_value ASC")
  end

  # Get the rate from the database or nil if could not find the rate for specified rate type
  def get_rate(value, rate_type = 0)
    rate = ComplexCalculatorRate.find(:first, :conditions => ["calculator_id = ? and rate_type = ? and from_value <= ? and ? <= to_value",
                                      self.id, rate_type, value, value])
    rate.nil? ? nil : rate.rate
  end
  
  private
  
  # Before saving the record set that this is a complex calculator
  def set_is_complex
    self.is_complex = true
  end
  
end