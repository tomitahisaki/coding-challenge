# frozen_string_literal: true

class ElectricityPlan < ApplicationRecord
  belongs_to :electricity_provider
  has_many :contract_basic_fees

  scope :by_ampere, ->(contract_ampere) { joins(:contract_basic_fees).merge(ContractBasicFee.by_ampere(contract_ampere)) }

  validates :plan_name, presence: true
end
