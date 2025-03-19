# frozen_string_literal: true

class ElectricityProvider < ApplicationRecord
  validates :provider_name, presence: true
end
