# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsageRate, type: :model do
  let(:usage_rate) {
    described_class.new(
      min_kwh:,
      max_kwh:,
      unit_price:,
      fix_rate:,
      electricity_plan:,
    )
  }
  let(:min_kwh) { 0 }
  let(:max_kwh) { 140 }
  let(:unit_price) { 20.25 }
  let(:fix_rate) { false }
  let(:electricity_plan) { create(:electricity_plan) }

  describe '#calculate_total_price' do
    subject { described_class.calculate_total_price(usage_rates:, consumption:) }

    let(:consumption) { 300 }

    context 'when fixed_rate is true' do
      let(:usage_rates) { [usage_rate] }
      let(:usage_rate) do
        create(
          :usage_rate,
          min_kwh: 0,
          max_kwh: nil,
          unit_price: 20.25,
          fix_rate: true,
          electricity_plan: electricity_plan
        )
      end

      it 'returns total price' do
        is_expected.to eq(6075.0)
      end
    end

    context 'when fixed_rate is false' do
      let(:usage_rates) { [first_usage_rate, second_usage_rate, third_usage_rate] }
      let(:first_usage_rate) do
        create(
          :usage_rate,
          min_kwh: 0,
          max_kwh: 120,
          unit_price: 20.25,
          fix_rate: false,
          electricity_plan: electricity_plan
        )
      end
      let(:second_usage_rate) do
        create(
          :usage_rate,
          min_kwh: 121,
          max_kwh: 200,
          unit_price: 25.25,
          fix_rate: false,
          electricity_plan: electricity_plan
        )
      end
      let(:third_usage_rate) do
        create(
          :usage_rate,
          min_kwh: 201,
          max_kwh: nil,
          unit_price: 30.25,
          fix_rate: false,
          electricity_plan: electricity_plan
        )
      end

      it 'returns total price' do
        is_expected.to eq(7475.0)
      end
    end
  end

  describe 'validations' do
    subject { usage_rate.valid? }

    context 'success' do
      context 'min_kwh' do
        context 'when min_kwh is present' do
          it 'is valid' do
            is_expected.to eq(true)
          end
        end

        context 'when min_kwh is greater_than or equal 0' do
          it 'is valid' do
            is_expected.to eq(true)
          end
        end
      end

      context 'max_kwh' do
        context 'when max_kwh is nil' do
          let(:max_kwh) { nil }

          it 'is valid' do
            is_expected.to eq(true)
          end
        end

        context 'when max_kwh is greater_than min_kwh' do
          let(:max_kwh) { 141 }
          let(:min_kwh) { 140 }

          it 'is valid' do
            is_expected.to eq(true)
          end
        end
      end

      context 'unit_price' do
        context 'when unit_price is present' do
          it 'is valid' do
            is_expected.to eq(true)
          end
        end
      end

      context 'fix_rate' do
        context 'when max_kwh and min_kwh are appropriate values' do
          let(:fix_rate) { true }
          let(:min_kwh) { 0 }
          let(:max_kwh) { nil }

          it 'is valid' do
            is_expected.to eq(true)
          end
        end
      end
    end

    context 'failure' do
      context 'min_kwh' do
        context 'when min_kwh is nil' do
          let(:min_kwh) { nil }

          it 'is invalid' do
            is_expected.to eq(false)
          end
        end

        context 'when min_kwh is less than 0' do
          let(:min_kwh) { -1 }

          it 'is invalid' do
            is_expected.to eq(false)
          end
        end

        context 'when min_kwh is float' do
          let(:min_kwh) { 0.5 }

          it 'is invalid' do
            is_expected.to eq(false)
          end
        end

        context 'when min_kwh is string' do
          let(:min_kwh) { 'string' }

          it 'is invalid' do
            is_expected.to eq(false)
          end
        end
      end

      context 'max_kwh' do
        context 'when max_kwh is less than min_kwh' do
          let(:max_kwh) { 139 }
          let(:min_kwh) { 140 }

          it 'is invalid' do
            is_expected.to eq(false)
          end
        end

        context 'when max_kwh is float' do
          let(:max_kwh) { 140.5 }

          it 'is invalid' do
            is_expected.to eq(false)
          end
        end

        context 'when max_kwh is string' do
          let(:max_kwh) { 'string' }

          it 'is invalid' do
            is_expected.to eq(false)
          end
        end
      end

      context 'unit_price' do
        context 'when unit_price is nil' do
          let(:unit_price) { nil }

          it 'is invalid' do
            is_expected.to eq(false)
          end
        end
      end

      context 'fix_rate' do
        context 'when min_kwh is not 0' do
          let(:fix_rate) { true }
          let(:min_kwh) { 1 }

          it 'is invalid' do
            is_expected.to eq(false)
          end
        end

        context 'when max_kwh is present' do
          let(:fix_rate) { true }
          let(:max_kwh) { 140 }

          it 'is invalid' do
            is_expected.to eq(false)
          end
        end
      end
    end
  end
end
