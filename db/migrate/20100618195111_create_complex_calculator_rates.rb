class CreateComplexCalculatorRates < ActiveRecord::Migration
  def self.up
    create_table :complex_calculator_rates do |t|
      t.integer :calculator_id,   :null => false
      t.string  :calculator_type, :null => false, :limit => 50
      t.integer :rate_type,       :null => false,                               :default => 0
      t.decimal :from_value,      :null => false, :precision => 8, :scale => 3, :default => 0.0
      t.decimal :to_value,        :null => false, :precision => 8, :scale => 3, :default => 0.0
      t.decimal :rate,            :null => false, :precision => 8, :scale => 2, :default => 0.0

      t.timestamps
    end
    
    add_index(:complex_calculator_rates, :calculator_id)
    add_index(:complex_calculator_rates, :calculator_type)
    add_index(:complex_calculator_rates, :rate_type)
    add_index(:complex_calculator_rates, :from_value)
    add_index(:complex_calculator_rates, :to_value)

    add_column :calculators, :is_complex, :boolean, :default => false    
    add_index(:calculators, :is_complex)
  end

  def self.down
    remove_index(:complex_calculator_rates, :calculator_id)
    remove_index(:complex_calculator_rates, :calculator_type)
    remove_index(:complex_calculator_rates, :rate_type)
    remove_index(:complex_calculator_rates, :from_value)
    remove_index(:complex_calculator_rates, :to_value)
    drop_table :complex_calculator_rates
    
    remove_index(:calculators, :is_complex)
    remove_column :calculators, :is_complex
  end
end
