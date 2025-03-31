# frozen_string_literal: true

class ElectricityProvider < ApplicationRecord
  has_many :electricity_plans, dependent: :destroy
  
  validates :provider_name, presence: true
end
