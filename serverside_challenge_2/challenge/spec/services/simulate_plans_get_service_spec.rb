# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SimulatePlansGetService, type: :model do
  let(:service) { described_class.new(ampere:, consumption:) }
  let(:ampere) { 10 }
  let(:consumption) { 100 }

  describe '#execute' do
    subject { service.execute }

    context 'when ampere matches any electricity plans' do
      let(:ampere) { 10 }
      let(:consumption) { 100 }
      let(:electricity_plan) { create(:electricity_plan) }
      let!(:contract_basic_fee_10_ampere) do
        create(
          :contract_basic_fee,
          contract_ampere: ampere,
          basic_fee: 100.0,
          electricity_plan:,
        )
      end
      let!(:usage_rate) do
        create(
          :usage_rate,
          min_kwh: 0,
          max_kwh: 140,
          unit_price: 20.00,
          fix_rate: false,
          electricity_plan:,
        )
      end
      let(:another_electricity_plan) { create(:electricity_plan) }
      let!(:another_contract_basic_fee_10_ampere) do
        create(
          :contract_basic_fee,
          contract_ampere: ampere,
          basic_fee: 200.0,
          electricity_plan: another_electricity_plan,
        )
      end
      let!(:another_usage_rate) do
        create(
          :usage_rate,
          min_kwh: 0,
          max_kwh: 140,
          unit_price: 40.00,
          fix_rate: false,
          electricity_plan: another_electricity_plan,
        )
      end

      before do
        # 対象外のデータ
        other_eletricity_plan = create(:electricity_plan)
        create(:contract_basic_fee, contract_ampere: 15, electricity_plan: other_eletricity_plan)
        create(:usage_rate, min_kwh: 0, max_kwh: 140, unit_price: 30.00, fix_rate: false, electricity_plan: other_eletricity_plan)
      end

      let(:expected_result) do
        [
          {
            provider_name: electricity_plan.electricity_provider.provider_name,
            plan_name: electricity_plan.plan_name,
            price: 2100.0,
          },
          {
            provider_name: another_electricity_plan.electricity_provider.provider_name,
            plan_name: another_electricity_plan.plan_name,
            price: 4200.0,
          },
        ]
      end

      it 'returns matched electricity plans' do
        is_expected.to eq(expected_result)
      end
    end

    context 'when ampere do not match any electricity plan' do
      it 'returns empty array' do
        is_expected.to eq([])
      end
    end
  end
end
