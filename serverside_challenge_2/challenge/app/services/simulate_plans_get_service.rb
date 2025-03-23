# frozen_string_literal: true

class SimulatePlansGetService
  def initialize(ampere:, consumption:)
    @ampere = ampere
    @consumption = consumption
  end

  def execute
    electricity_plans.map do |plan|
      {
        provider_name: plan.electricity_provider.provider_name,
        plan_name: plan.plan_name,
        price: plan.caluculate_price(ampere:, consumption:)
      }
    end
  end

  private

  attr_reader :ampere, :consumption

  def electricity_plans
    @electricity_plans ||= 
      ElectricityPlan.preload(:electricity_provider, :contract_basic_fees, :usage_rates).by_ampere(ampere)
  end
end
