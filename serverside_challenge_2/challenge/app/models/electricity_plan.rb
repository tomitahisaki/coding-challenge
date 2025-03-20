# frozen_string_literal: true

class ElectricityPlan < ApplicationRecord
  belongs_to :electricity_provider
  has_many :contract_basic_fees

  validates :plan_name, presence: true
end
