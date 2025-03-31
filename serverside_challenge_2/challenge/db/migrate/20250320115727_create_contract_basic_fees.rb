class CreateContractBasicFees < ActiveRecord::Migration[7.0]
  def change
    create_table :contract_basic_fees, comment: '契約料金' do |t|
      t.integer :contract_ampere, null: false ,comment: '契約アンペア'
      t.decimal :basic_fee, null: false ,precision: 10, scale: 2, comment: '基本料金'
      t.references :electricity_plan, null: false, foreign_key: true

      t.timestamps
    end
    add_index :contract_basic_fees, [:contract_ampere, :electricity_plan_id], unique: true, name: 'index_contract_fees_on_plan_id_and_ampere'
  end
end
