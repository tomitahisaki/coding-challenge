# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ElectricityPlan, type: :model do
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
