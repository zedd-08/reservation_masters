json.extract! reservation, :id, :stay_id, :check_in, :check_out, :status, :created_at, :updated_at
json.url reservation_url(reservation, format: :json)
