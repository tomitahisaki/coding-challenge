# frozen_string_literal: true

class CreateElectricityProviders < ActiveRecord::Migration[7.0]
  def change
    create_table :electricity_providers, comment: '電力会社' do |t|
      t.string :provider_name, null: false, comment: '電力会社名'

      t.timestamps
    end
  end
end
