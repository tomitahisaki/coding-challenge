# frozen_string_literal: true

class ContractBasicFee < ApplicationRecord
  belongs_to :electricity_plan

  scope :by_ampere, ->(contract_ampere) { where(contract_ampere: contract_ampere) }

  validates :contract_ampere, presence: true, uniqueness: { scope: :electricity_plan_id }
  validates :basic_fee, presence: true, numericality: { greater_than_or_equal_to: 0 }

  enum contract_ampere: {
    ten: 10,
    fifteen: 15,
    twenty: 20,
    thirty: 30,
    forty: 40,
    fifty: 50,
    sixty: 60
  }


  def self.acceptable_ampere?(ampere)
    self.contract_amperes.value?(ampere)
  end
end
