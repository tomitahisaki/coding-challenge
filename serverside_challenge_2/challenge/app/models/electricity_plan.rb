# frozen_string_literal: true

class ElectricityPlan < ApplicationRecord
  belongs_to :electricity_provider

  validates :plan_name, presence: true
end
