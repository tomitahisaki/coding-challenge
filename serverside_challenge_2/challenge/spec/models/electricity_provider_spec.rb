# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ElectricityProvider, type: :model do
  describe 'validations' do
    subject { build(:electricity_provider, provider_name:) }

    let(:provider_name) { 'テスト電力会社' }

    context 'success' do
      context 'provider_name' do
        context 'when provider_name is present' do
          it 'is valid' do
            expect(subject).to be_valid
          end
        end
      end
    end

    context 'failure' do
      context 'provider_name' do
        context 'when provider_name is nil' do
          let(:provider_name) { nil }

          it 'is invalid' do
            expect(subject).to be_invalid
          end
        end

        context 'when provider_name is empty' do
          let(:provider_name) { '' }

          it 'is invalid' do
            expect(subject).to be_invalid
          end
        end
      end
    end
  end
end
