# frozen_string_literal: true

provider_names = [
  { provider_name: '東京電力エナジーパートナー' },
  { provider_name: '東京ガス' },
  { provider_name: 'Looopでんき' },
]

provider_names.each do |provider_name|
  ElectricityProvider.find_or_create_by!(provider_name)
end

plans = [
  { plan_name: '従量電灯B', provider_name: '東京電力エナジーパートナー' },
  { plan_name: 'スタンダードS', provider_name: '東京電力エナジーパートナー' },
  { plan_name: 'ずっとも電気1', provider_name: '東京ガス' },
  { plan_name: 'おうちプラン', provider_name: 'Looopでんき' },
]

plans.each do |plan|
  ElectricityPlan.find_or_create_by!(
    plan_name: plan[:plan_name],
    electricity_provider: ElectricityProvider.find_by(provider_name: plan[:provider_name])
  )
end

basic_fees = [
  # 東京電力エナジーパートナー:従量電灯B
  { ampere: 10, price: 286.00, plan: '従量電灯B' },
  { ampere: 15, price: 429.00, plan: '従量電灯B' },
  { ampere: 20, price: 572.00, plan: '従量電灯B' },
  { ampere: 30, price: 858.00, plan: '従量電灯B' },
  { ampere: 40, price: 1144.00, plan: '従量電灯B' },
  { ampere: 50, price: 1430.00, plan: '従量電灯B' },
  { ampere: 60, price: 1716.00, plan: '従量電灯B' },
  # 東京電力エナジーパートナー:スタンダードS
  { ampere: 10, price: 311.75, plan: 'スタンダードS' },
  { ampere: 15, price: 467.63, plan: 'スタンダードS' },
  { ampere: 20, price: 623.50, plan: 'スタンダードS' },
  { ampere: 30, price: 935.25, plan: 'スタンダードS' },
  { ampere: 40, price: 1247.00, plan: 'スタンダードS' },
  { ampere: 50, price: 1558.75, plan: 'スタンダードS' },
  { ampere: 60, price: 1870.50, plan: 'スタンダードS' },
  # 東京ガス:ずっとも電気1
  { ampere: 30, price: 858.00, plan: 'ずっとも電気1' },
  { ampere: 40, price: 1144.00, plan: 'ずっとも電気1' },
  { ampere: 50, price: 1430.00, plan: 'ずっとも電気1' },
  { ampere: 60, price: 1716.00, plan: 'ずっとも電気1' },
  # Looopでんき:おうちプラン
  { ampere: 10, price: 0.00, plan: 'おうちプラン' },
  { ampere: 15, price: 0.00, plan: 'おうちプラン' },
  { ampere: 20, price: 0.00, plan: 'おうちプラン' },
  { ampere: 30, price: 0.00, plan: 'おうちプラン' },
  { ampere: 40, price: 0.00, plan: 'おうちプラン' },
  { ampere: 50, price: 0.00, plan: 'おうちプラン' },
  { ampere: 60, price: 0.00, plan: 'おうちプラン' },
]

basic_fees.each do |basic_fee|
  ContractBasicFee.find_or_create_by!(
    contract_ampere: basic_fee[:ampere],
    basic_fee: basic_fee[:price],
    electricity_plan: ElectricityPlan.find_by(plan_name: basic_fee[:plan])
  )
end

usage_rates = [
  # 東京電力エナジーパートナー:従量電灯B
  { min_kwh: 0, max_kwh: 120, unit_price: 19.88, fix_rate: false, plan: '従量電灯B' },
  { min_kwh: 121, max_kwh: 300, unit_price: 26.48, fix_rate: false, plan: '従量電灯B' },
  { min_kwh: 301, max_kwh: nil, unit_price: 30.57, fix_rate: false, plan: '従量電灯B' },
  # 東京電力エナジーパートナー:スタンダードS
  { min_kwh: 0, max_kwh: 120, unit_price: 29.80, fix_rate: false, plan: 'スタンダードS' },
  { min_kwh: 121, max_kwh: 300, unit_price: 36.40, fix_rate: false, plan: 'スタンダードS' },
  { min_kwh: 301, max_kwh: nil, unit_price: 40.49, fix_rate: false, plan: 'スタンダードS' },
  # 東京ガス:ずっとも電気1
  { min_kwh: 0, max_kwh: 140, unit_price: 23.67, fix_rate: false, plan: 'ずっとも電気1' },
  { min_kwh: 141, max_kwh: 350, unit_price: 23.88, fix_rate: false, plan: 'ずっとも電気1' },
  { min_kwh: 351, max_kwh: nil, unit_price: 26.41, fix_rate: false, plan: 'ずっとも電気1' },
  # Looopでんき:おうちプラン
  { min_kwh: 0, max_kwh: nil, unit_price: 28.8, fix_rate: true, plan: 'おうちプラン' },
]

usage_rates.each do |usage_rate|
  UsageRate.find_or_create_by!(
    min_kwh: usage_rate[:min_kwh],
    max_kwh: usage_rate[:max_kwh],
    unit_price: usage_rate[:unit_price],
    fix_rate: usage_rate[:fix_rate],
    electricity_plan: ElectricityPlan.find_by(plan_name: usage_rate[:plan])
  )
end

