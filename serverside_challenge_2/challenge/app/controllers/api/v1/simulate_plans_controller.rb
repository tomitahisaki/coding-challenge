# frozen_string_literal: true

class Api::V1::SimulatePlansController < ApplicationController
  def index
    service = SimulatePlansGetService.new(simulate_params:)

    render json: service.execute, status: :ok
  rescue SimulatePlansGetService::SimulatePlansGetServiceError => e
    render json: { errors: e.messages }, status: :unprocessable_entity
  end

  private

  def simulate_params
    {
      ampere: params[:ampere].to_i,
      consumption: params[:consumption].to_i,
    }
  end
end
