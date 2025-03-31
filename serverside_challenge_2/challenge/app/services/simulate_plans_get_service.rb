# frozen_string_literal: true

class SimulatePlansGetService
  class SimulatePlansGetServiceError < StandardError
    attr_reader :messages
    def initialize(messages = [])
      @messages = messages
      super
    end
  end

  ERROR_MESSAGES = {
    ampere_not_integer: '契約アンペア数は数値で入力してください',
    ampere_not_acceptable: '契約アンペア数は正しい値で入力してください',
    consumption_not_integer: '使用量は数値で入力してください',
    consumption_not_positive: '使用量は0以上の整数で入力してください',
  }

  def initialize(simulate_params:)
    @ampere = simulate_params[:ampere]
    @consumption = simulate_params[:consumption]

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

  attr_reader :ampere, :consumption, :errors

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
    unless consumption.is_a?(Integer)
      add_error(:consumption, ERROR_MESSAGES[:consumption_not_integer])
      return
    end

    add_error(:consumption, ERROR_MESSAGES[:consumption_not_positive]) if consumption.negative?
  end

  def validate_ampere
    unless ampere.is_a?(Integer)
      add_error(:ampere, ERROR_MESSAGES[:ampere_not_integer])
      return
    end

    add_error(:ampere, ERROR_MESSAGES[:ampere_not_acceptable]) unless ContractBasicFee.acceptable_ampere?(ampere)
  end

  def add_error(key, message)
    errors << { key => message }
  end
end
