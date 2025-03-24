# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Api::V1::SimulatePlans", type: :request do
  describe "GET /index" do
    subject { get api_v1_simulate_plans_index_path, params: }

    let(:params) { { ampere:, consumption: } }
    let(:ampere) { 10 }
    let(:consumption) { 100 }

    context 'when params are valid' do
      let(:electricity_plan) { create(:electricity_plan) }
      let!(:contract_basic_fee_10_ampere) do
        create(
          :contract_basic_fee,
          contract_ampere: ampere,
          basic_fee: 100.0,
          electricity_plan: electricity_plan,
        )
      end
      let!(:usage_rate) do
        create(
          :usage_rate,
          min_kwh: 0,
          max_kwh: 140,
          unit_price: 20.00,
          fix_rate: false,
          electricity_plan: electricity_plan,
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

      it "returns 200" do
        subject
        expect(response).to have_http_status(200)
        expect(response.parsed_body.length).to eq(2)
      end
    end

    context 'when params are invalid' do
      let(:ampere) { 0 }
      let(:consumption) { -100 }

      it "returns 422" do
        subject
        expect(response).to have_http_status(422)
        expect(response.parsed_body['errors'].length).to eq(2)
      end
    end
  end
end
