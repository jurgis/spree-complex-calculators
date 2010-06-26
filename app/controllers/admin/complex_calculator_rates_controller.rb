class Admin::ComplexCalculatorRatesController < Admin::BaseController
  # resource_controller - not using because too much customization required
  layout 'admin'
  helper Admin::ComplexCalculatorsHelper
  
  before_filter :load_calculator, :only => [:edit, :update]
  
  def index
    @calculators = Calculator.all(:conditions => {:is_complex => true}, :order => 'created_at DESC')
  end
  
  def edit
    @rates_by_type = get_rates_by_type(@calculator)
  end
  
  def update
    if @calculator.update_attributes(params[:calculator_weight_and_quantity])
      flash[:notice] = t('resource_controller.successfully_updated')
      redirect_to edit_admin_complex_calculator_rate_url(@calculator)
    else
      @rates_by_type = get_rates_by_type(@calculator, false) # set @rates_by_type before rendering the view
      render :action => 'edit'
    end
  end
  
  private
  
  def load_calculator
    @calculator = Calculator.find(params[:id])
  end
  
  def get_rates_by_type(calculator, load_from_db = true)
    rates_by_type = {}
    calculator.supported_types.each { |type| rates_by_type[type] = [] }
    rates = load_from_db ? calculator.sorted_rates : calculator.complex_calculator_rates
    rates.each { |rate| rates_by_type[rate.rate_type] << rate }
    rates_by_type
  end
end
