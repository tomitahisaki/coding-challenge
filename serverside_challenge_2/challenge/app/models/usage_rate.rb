# frozen_string_literal: true

class UsageRate < ApplicationRecord
  belongs_to :electricity_plan

  before_validation :check_min_kwh_nil

  validates :min_kwh, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :max_kwh, numericality: { greater_than: :min_kwh, only_integer: true }, allow_nil: true
  validates :unit_price, presence: true
  validate :validate_fix_rate_conditions, if: -> { fix_rate == true }

  def self.calculate_total_price(usage_rates:, consumption:)
    fixed_rate = usage_rates.find(&:fix_rate)
    return fixed_rate.unit_price.to_f * consumption if fixed_rate

    total_price = 0
    remaining_consumption = consumption

    usage_rates.sort_by(&:min_kwh).each do |usage_rate|
      next if remaining_consumption <= 0
      
      if usage_rate.max_kwh.nil?
        total_price += usage_rate.unit_price.to_f * remaining_consumption
        remaining_consumption = 0
      else
        # range_kwh は、min_kwh が 0 の場合は、max_kwh から min_kwh を引いた値になる
        # それ以外の場合は、max_kwh から min_kwh を引いた値に 1 を足した値になる
        range_kwh = usage_rate.min_kwh.zero? ? usage_rate.max_kwh - usage_rate.min_kwh : usage_rate.max_kwh - usage_rate.min_kwh + 1

        kwh = [range_kwh, remaining_consumption].min
        total_price += usage_rate.unit_price.to_f * kwh
        remaining_consumption -= kwh
      end
    end
    total_price
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
