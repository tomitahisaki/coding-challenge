# frozen_string_literal: true

FactoryBot.define do
  factory :electricity_plan do
    plan_name { "プランA" }
    association :electricity_provider
  end
end
