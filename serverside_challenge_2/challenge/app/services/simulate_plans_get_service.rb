# frozen_string_literal: true

class SimulatePlansGetService
  class SimulatePlansGetServiceError < StandardError
    attr_reader :messages
    def initialize(messages = [])
      @messages = messages
      super
    end
  end

  def initialize(ampere:, consumption:)
    @ampere = ampere
    @consumption = consumption

    @errors = []
  end

  def execute
    raise SimulatePlansGetServiceError.new(errors) unless valid?

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

  def valid?
    validate_ampere
    validate_consumption

    errors.empty?
  end

  def validate_consumption
    return errors << { consumption: '使用量は数値で入力してください' } unless consumption.is_a?(Integer)
    return errors << { consumption: '使用量は0以上の整数で入力してください' } unless consumption.positive?
  end

  def validate_ampere
    return errors << { ampere: '契約アンペア数は数値で入力してください' } unless ampere.is_a?(Integer)
    return errors << { ampere: '契約アンペア数は正しい値で入力してください' } unless ContractBasicFee.acceptable_ampere?(ampere)
  end
end
