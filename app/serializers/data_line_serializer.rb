class DataLineSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id,
             :device_id,
             :timestamp,
             :latitude,
             :longitude,
             :speed,
             :speed_exceeded,
             :cardinal_direction,
             :altitude,
             :sos,
             :ok,
             :check,
             :orientation

  attribute :timestamp do |object|
    object.timestamp.strftime("%Y-%d-%m %H:%M")
  end

  attribute :battery do |object|
    "#{ object.battery_percentage }%"
  end

  attribute :sos do |object|
    object.sos_count
  end

  attribute :ok do |object|
    object.ok_count
  end
end
