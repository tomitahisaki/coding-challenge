# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SimulatePlansGetService, type: :model do
  let(:service) { described_class.new(ampere:, consumption:) }
  let(:ampere) { 10 }
  let(:consumption) { 100 }

  describe '#execute' do
    subject { service.execute }

    context 'success' do
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

    context 'failure' do
      context 'when consumption is not an integer' do
        let(:consumption) { '100' }

        let(:expected_error) { [{consumption: '使用量は数値で入力してください'}] }

        it 'raises error' do
          expect { subject }.to raise_error do |error|
            expect(error.class).to eq(SimulatePlansGetService::SimulatePlansGetServiceError)
            expect(error.messages).to eq(expected_error)
          end
        end
      end

      context 'when consumption is not positive' do
        let(:consumption) { 0 }

        let(:expected_error) { [{consumption: '使用量は0以上の整数で入力してください'}] }

        it 'raises error' do
          expect { subject }.to raise_error do |error|
            expect(error.class).to eq(SimulatePlansGetService::SimulatePlansGetServiceError)
            expect(error.messages).to eq(expected_error)
          end
        end
      end

      context 'when ampere is not an integer' do
        let(:ampere) { '10' }

        let(:expected_error) { [{ampere: '契約アンペア数は数値で入力してください'}] }

        it 'raises error' do
          expect { subject }.to raise_error do |error|
            expect(error.class).to eq(SimulatePlansGetService::SimulatePlansGetServiceError)
            expect(error.messages).to eq(expected_error)
          end
        end
      end

      context 'when ampere is not acceptable_ampere' do
        let(:ampere) { 5 }

        let(:expected_error) { [{ampere: '契約アンペア数は正しい値で入力してください'}] }

        it 'raises error' do
          expect { subject }.to raise_error do |error|
            expect(error.class).to eq(SimulatePlansGetService::SimulatePlansGetServiceError)
            expect(error.messages).to eq(expected_error)
          end
        end
      end


      context 'when ampere and consumption are invalid' do
        let(:ampere) { '10' }
        let(:consumption) { '100' }

        let(:expected_error) do
          [
            {ampere: '契約アンペア数は数値で入力してください'},
            {consumption: '使用量は数値で入力してください'},
          ]
        end

        it 'raises error' do
          expect { subject }.to raise_error do |error|
            expect(error.class).to eq(SimulatePlansGetService::SimulatePlansGetServiceError)
            expect(error.messages).to eq(expected_error)
          end
        end
      end
    end
  end
end
