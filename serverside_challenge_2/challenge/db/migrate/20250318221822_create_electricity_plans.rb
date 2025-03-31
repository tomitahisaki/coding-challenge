# frozen_string_literal: true

class CreateElectricityPlans < ActiveRecord::Migration[7.0]
  def change
    create_table :electricity_plans, comment: '電力プラン' do |t|
      t.string :plan_name, comment: 'プラン名'
      t.references :electricity_provider, null: false, foreign_key: true

      t.timestamps
    end
  end
end
