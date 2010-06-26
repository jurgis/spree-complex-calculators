class ComplexCalculatorRate < ActiveRecord::Base
  WEIGHT = 0  # Total item weight
  QNTY = 1   # Total item quantity
  
  belongs_to :calculator
  
  named_scope :by_type, lambda {|type| { :conditions => ['rate_type = ?', type] } }
    
  validates_presence_of :calculator_id, :rate_type, :from_value, :to_value, :rate
  validates_numericality_of :from_value, :to_value, :rate, :allow_blank => true
  
  def validate
    errors.add(:base, "'From' value should be less than 'To' value") if from_value >= to_value #TODO: add to the yml file
  end

  # All complex calculator rate types
  def self.all_types
    [WEIGHT, QNTY]
  end

  # Find the rate for the specified value
  def self.find_rate(calculator_id, rate_type, value)
    # get the lowes rate if multiple rates are defined
    rate = find(:first,
                :conditions => ["calculator_id = ? and rate_type = ? and from_value <= ? and ? <= to_value", calculator_id, rate_type, value, value],
                :order => "rate ASC")
                
    rate.nil? ? nil : rate.rate
  end

  # Find the previous rate for the specified value
  def self.find_previous_rate(calculator_id, rate_type, value)
    rate = find(:first,
                :conditions => ["calculator_id = ? and rate_type = ? and to_value <= ?", calculator_id, rate_type, value],
                :order => "rate DESC")
    
    rate.nil? ? nil : rate.rate
  end
end
