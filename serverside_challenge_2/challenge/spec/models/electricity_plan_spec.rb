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
        binding.irb
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
end
