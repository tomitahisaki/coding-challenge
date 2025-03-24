# frozen_string_literal: true

class UsageRate < ApplicationRecord
  belongs_to :electricity_plan

  before_validation :check_min_kwh_nil

  validates :min_kwh, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :max_kwh, numericality: { greater_than: :min_kwh, only_integer: true }, allow_nil: true
  validates :unit_price, presence: true
  validate :validate_fix_rate_conditions, if: -> { fix_rate == true }

  def self.find_unit_price(usage_rates:, consumption:)
    fixed_rate = usage_rates.find(&:fix_rate)

    if fixed_rate
      fixed_rate.unit_price
    else
      usage_rates.find { |rate| rate.min_kwh <= consumption && rate.max_kwh >= consumption }.unit_price
    end
  end

  private

  def check_min_kwh_nil
    # numercality validation は、nil は許容しないので、ここで nil チェックを行う
    if min_kwh.nil?
      errors.add(:min_kwh, :blank)
      throw(:abort)
    end
  end

  def validate_fix_rate_conditions
    errors.add(:min_kwh, 'must be 0 when fix_rate is true') unless min_kwh.zero?
    errors.add(:max_kwh, 'must be nil when fix_rate is true') if max_kwh.present?
  end
end
