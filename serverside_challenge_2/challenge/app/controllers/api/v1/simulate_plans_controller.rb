# frozen_string_literal: true

class Api::V1::SimulatePlansController < ApplicationController
  def index
    # service = SimulatePlansService.new(simulate_params).execute

    expect_response = [
      { provider_name: '東京ガス', plan_name: 'ガスプラン', price: 1000 },
      { provider_name: '東京電力', plan_name: '電気プラン', price: 2000 },
    ]

    render json: expect_response, status: :ok
  end

  private
  
  def simulate_params
    params.permit(:ampere, :consumption)
  end
end
