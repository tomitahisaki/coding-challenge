# frozen_string_literal: true

class ElectricityPlan < ApplicationRecord
  belongs_to :electricity_provider
  has_many :contract_basic_fees
  has_many :usage_rates

  scope :by_ampere, ->(contract_ampere) { joins(:contract_basic_fees).merge(ContractBasicFee.by_ampere(contract_ampere)) }

  validates :plan_name, presence: true

  def caluculate_price(ampere:, consumption:)
    basic_fee = contract_basic_fees.find { |fee| fee.contract_ampere_before_type_cast == ampere }.basic_fee
    unit_price = ::UsageRate.find_unit_price(usage_rates:, consumption:)

    price = basic_fee.to_f + (unit_price.to_f * consumption)
    price.ceil
  end
end
