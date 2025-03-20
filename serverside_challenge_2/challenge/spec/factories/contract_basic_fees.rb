# frozen_string_literal: true

FactoryBot.define do
  factory :contract_basic_fee do
    contract_ampere { 10 }
    basic_fee { "100.25" }
    association :electricity_plan
  end
end
