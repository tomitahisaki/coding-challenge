# froze_string_literal: true

class CreateUsageRates < ActiveRecord::Migration[7.0]
  def change
    create_table :usage_rates, comment: '従量料金単価' do |t|
      t.integer :min_kwh, null: false, comment: '最小使用量'
      t.integer :max_kwh, comment: '最大使用量'
      t.decimal :unit_price, null: false, precision: 10, scale: 2, comment: '従量料金単価'
      t.boolean :fix_rate, null: false, default: false, comment: '固定料金フラグ'
      t.references :electricity_plan, null: false, foreign_key: true

      t.timestamps
    end
  end
end
