# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Api::V1::SimulatePlans", type: :request do
  describe "GET /index" do
    subject { get api_v1_simulate_plans_index_path, params: }
    
    let(:params) { { ampere:, consumption: } }
    let(:ampere) { 10 }
    let(:consumption) { 100 }

    it "returns 200" do
      subject
      expect(response).to have_http_status(200)
    end
  end
end
