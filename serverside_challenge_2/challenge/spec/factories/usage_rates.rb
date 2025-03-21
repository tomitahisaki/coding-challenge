# frozen_string_literal: true

FactoryBot.define do
  factory :usage_rate do
    min_kwh { 0 }
    max_kwh { 140 }
    unit_price { 20.25 }
    fix_rate { false }
    association :electricity_plan
  end
end
