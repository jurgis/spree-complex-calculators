# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class ComplexCalculatorsExtension < Spree::Extension
  version "0.0.1"
  description "A set of complex calculators"
  url "http://github.com/jurgis/spree-complex-calculators/tree/master"

  # Please use complex_calculators/config/routes.rb instead for extension routes.

  # def self.require_gems(config)
  #   config.gem "gemname-goes-here", :version => '1.2.3'
  # end
  
  def activate
    # Register all the calculators
    [
      Calculator::WeightAndQuantity
    ].each(&:register)
  end
  
end
