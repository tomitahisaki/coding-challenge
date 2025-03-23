# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ElectricityPlan, type: :model do

  describe 'scope' do
    context '.by_ampere' do
      subject { described_class.by_ampere(contract_ampere) }
      let(:contract_ampere) { 10 }

      let(:electricity_plan) { create(:electricity_plan) }
      let!(:contract_basic_fee_10_ampere) { create(:contract_basic_fee, contract_ampere: contract_ampere, electricity_plan: electricity_plan) }
      let!(:another_contract_basic_fee_10_ampere) { create(:contract_basic_fee, contract_ampere: contract_ampere, electricity_plan: another_electricity_plan) }
      let(:another_electricity_plan) { create(:electricity_plan) }

      before do
        # 対象外のデータ
        other_eletricity_plan = create(:electricity_plan)
        create(:contract_basic_fee, contract_ampere: 15, electricity_plan: other_eletricity_plan)        
      end

      let(:expected_result) { [electricity_plan, another_electricity_plan] }

      it 'returns contract_basic_fee by contract_ampere' do
        is_expected.to match_array(expected_result)
      end
    end
  end

  describe 'validations' do
    subject { build(:electricity_plan, plan_name:) }

    let(:plan_name) { 'テスト電気プラン' }

    context 'success' do
      context 'plan_name' do
        context 'when plan_name is present' do
          it 'is valid' do
            is_expected.to be_valid
          end
        end
      end
    end

    context 'failure' do
      context 'plan_name' do
        context 'when plan_name is nil' do
          let(:plan_name) { nil }

          it 'is invalid' do
            is_expected.to be_invalid
          end
        end
      end
    end
  end

  describe '#caluculate_price' do
    context 'when electricity_plan has contract_basic_fee and usage_rate' do
      subject { electricity_plan.caluculate_price(ampere:, consumption:) }

      let(:electricity_plan) { create(:electricity_plan) }
      let!(:contract_ampere) do
         create(
          :contract_basic_fee,
          contract_ampere: ampere,
          basic_fee:,
          electricity_plan: electricity_plan
        )
      end
      let!(:usage_rate) do
        create(
          :usage_rate,
          min_kwh:,
          max_kwh:,
          unit_price:,
          fix_rate:,
          electricity_plan: electricity_plan
        )
      end
      let(:ampere) { 10 }
      let(:consumption) { 100 }

      context 'when unit_price is not fixed' do
        let(:min_kwh) { 0 }
        let(:max_kwh) { 140 }
        let(:fix_rate) { false }

        context 'when basic_fee and unit_price are integers' do
          let(:basic_fee) { 100 }
          let(:unit_price) { 20 }

          it 'returns price' do
            is_expected.to eq(2100)
          end
        end
        
        context 'when basic_fee and unit_price are floats' do
          let(:basic_fee) { 100.25 }
          let(:unit_price) { 20.25 }

          it 'returns price' do
            is_expected.to eq(2126) # 2125.25
          end
        end
      end
    end
  end
end
