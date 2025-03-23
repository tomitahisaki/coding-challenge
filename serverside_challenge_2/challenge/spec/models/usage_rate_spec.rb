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

  describe '#find_unit_price' do
    subject { described_class.find_unit_price(usage_rates: [usage_rate], consumption: consumption) }

    let(:consumption) { 100 }
    let(:usage_rate) do
      create(
        :usage_rate,
        min_kwh: min_kwh,
        max_kwh: max_kwh,
        unit_price: unit_price,
        fix_rate: fix_rate,
        electricity_plan: electricity_plan
      )
    end

    context 'when fixed_rate is true' do
      let(:fix_rate) { true }
      let(:min_kwh) { 0 }
      let(:max_kwh) { nil }
      let(:unit_price) { 20.25 }

      it 'returns fixed unit_price' do
        is_expected.to eq(unit_price)
      end
    end

    context 'when fixed_rate is false' do
      let(:fix_rate) { false }
      let(:min_kwh) { 0 }
      let(:max_kwh) { 140 }
      let(:unit_price) { 15.50 }

      before do
        # 対象外のデータ
        create(
          :usage_rate,
          min_kwh: 141,
          max_kwh: 200,
          unit_price: 25.25,
          fix_rate: false,
          electricity_plan: electricity_plan
        )
      end

      it 'returns unit_price based on consumption' do
        is_expected.to eq(unit_price)
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
