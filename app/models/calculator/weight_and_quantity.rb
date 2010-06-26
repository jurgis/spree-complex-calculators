class Calculator::WeightAndQuantity < Calculator::Base
  
  # The description of the calculator
  def self.description
    I18n.t('calculator_names.weight_and_quantity')
  end

  def self.unit
    I18n.t('weight_unit')
  end

  # as order_or_line_items we always get line items, as calculable we have Coupon, ShippingMethod or ShippingRate
  def compute(order_or_line_items)
    line_items = order_or_line_items.is_a?(Order) ? order_or_line_items.line_items : order_or_line_items
    total_weight = line_items.map {|li| li.variant.weight * li.quantity}.sum
    get_rate(total_weight) || 9.99 # Just for testing - returns 9.99 if nothing found in the table
  end
  
end
