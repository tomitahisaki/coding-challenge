# frozen_string_literal: true

require 'csv'

# 電力会社データの読み込み
CSV.foreach(Rails.root.join('db', 'csv', 'providers.csv'), headers: true) do |row|
  provider = ElectricityProvider.find_or_initialize_by(provider_name: row['provider_name'])
  provider.save! if provider.changed?
end

# プランデータの読み込み
CSV.foreach(Rails.root.join('db', 'csv', 'plans.csv'), headers: true) do |row|
  provider = ElectricityProvider.find_by(provider_name: row['provider_name'])
  next unless provider

  plan = ElectricityPlan.find_or_initialize_by(
    plan_name: row['plan_name'],
    electricity_provider: provider
  )
  plan.save! if plan.changed?
end

# 基本料金データの読み込み
CSV.foreach(Rails.root.join('db', 'csv', 'basic_fees.csv'), headers: true) do |row|
  plan = ElectricityPlan.find_by(
    plan_name: row['plan_name'],
    electricity_provider: ElectricityProvider.find_by(provider_name: row['provider_name'])
  )
  next unless plan

  contract_basic_fee = ContractBasicFee.find_or_initialize_by(
    contract_ampere: row['ampere'].to_i,
    basic_fee: row['price'].to_f,
    electricity_plan: plan
  )
  contract_basic_fee.save! if contract_basic_fee.changed?
end

# 使用料金データの読み込み
CSV.foreach(Rails.root.join('db', 'csv', 'usage_rates.csv'), headers: true) do |row|
  plan = ElectricityPlan.find_by(
    plan_name: row['plan_name'],
    electricity_provider: ElectricityProvider.find_by(provider_name: row['provider_name'])
  )
  next unless plan

  usage_rate = UsageRate.find_or_initialize_by(
    min_kwh: row['min_kwh'].to_i,
    max_kwh: row['max_kwh']&.to_i,
    unit_price: row['unit_price'].to_f,
    fix_rate: row['fix_rate'],
    electricity_plan: plan
  )
  usage_rate.save! if usage_rate.changed?
end
