# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContractBasicFee, type: :model do
  let(:contract_basic_fee) { described_class.new(contract_ampere:, basic_fee:, electricity_plan:) }
  let(:contract_ampere) { 10 }
  let(:basic_fee) { "100.25" }
  let(:electricity_plan) { create(:electricity_plan) }

  describe 'scope' do
    context '.by_ampere' do
      subject { described_class.by_ampere(contract_ampere) }
      let(:contract_ampere) { 10 }

      let(:contract_basic_fee_10_ampere) do
        create(
          :contract_basic_fee,
          contract_ampere:,
          electricity_plan:
        )
      end
      let(:another_contract_basic_fee_10_ampere) do
        create(
          :contract_basic_fee,
          contract_ampere:,
          electricity_plan: another_electricity_plan
        )
      end
      let(:another_electricity_plan) { create(:electricity_plan) }

      before do
        # 対象外のデータ
        create(:contract_basic_fee, contract_ampere: 15, electricity_plan: electricity_plan)
        create(:contract_basic_fee, contract_ampere: 20, electricity_plan: electricity_plan)
        create(:contract_basic_fee, contract_ampere: 30, electricity_plan: electricity_plan)
      end

      let(:expected_result) { [contract_basic_fee_10_ampere, another_contract_basic_fee_10_ampere] }

      it 'returns contract_basic_fee by contract_ampere' do
        is_expected.to match_array(expected_result)
      end
    end
  end

  describe 'validations' do
    subject { contract_basic_fee.valid? }
    
    context 'success' do
      context 'contract_ampere' do
        context 'when contract_ampere is present' do
          it 'is valid' do
            is_expected.to eq(true)
          end
        end
      end

      context 'basic_fee' do
        context 'when basic_fee is present' do
          it 'is valid' do
            is_expected.to eq(true)
          end
        end
      end
    end

    context 'failure' do
      context 'contract_ampere' do
        context 'when contract_ampere is not present' do
          let(:contract_ampere) { nil }

          it 'is invalid' do
            is_expected.to eq(false)
          end
        end

        context 'when contract_ampere is not unique' do
          let(:contract_ampere) { 10 }
          let!(:existed_contract_basic_fee) do
            create(
              :contract_basic_fee,
              contract_ampere:,
              electricity_plan:
            )
          end

          it 'is invalid' do
            is_expected.to eq(false)
          end
        end
      end

      context 'basic_fee' do
        context 'when basic_fee is not present' do
          let(:basic_fee) { nil }

          it 'is invalid' do
            is_expected.to eq(false)
          end
        end

        context 'when basic_fee is not a number' do
          let(:basic_fee) { "abc" }

          it 'is invalid' do
            is_expected.to eq(false)
          end
        end

        context 'when basic_fee is less than 0' do
          let(:basic_fee) { -1 }

          it 'is invalid' do
            is_expected.to eq(false)
          end
        end
      end
    end
  end
end
