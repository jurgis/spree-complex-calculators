class ComplexCalculatorRate < ActiveRecord::Base
  WEIGHT = 0  # Total item weight
  COUNT = 1   # Total item count
  
  belongs_to :calculator
  
  named_scope :by_type, lambda {|type| { :conditions => ['rate_type = ?', type] } }
    
  validates_presence_of :calculator_id, :rate_type, :from_value, :to_value, :rate
  validates_numericality_of :from_value, :to_value, :rate, :allow_blank => true
  
  def validate
    errors.add(:base, "'From' value should be less than 'To' value") if from_value >= to_value #TODO: add to the yml file
  end
  
  # All complex calculator rate types
  def self.all_types
    [WEIGHT, COUNT]
  end
end
