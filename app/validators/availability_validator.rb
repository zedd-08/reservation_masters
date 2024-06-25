class AvailabilityValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    reservations = Reservation.where(["stay_id=?", record.stay_id])
    date_ranges = reservations.map { |res| res.check_in..res.check_out }

    date_ranges.each do |range|
      if range.include? value
        record.errors.add(:base, "Dates not available")
        break
      end
    end
  end
end
