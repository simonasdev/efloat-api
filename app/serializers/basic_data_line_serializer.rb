class BasicDataLineSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id,
             :timestamp,
             :latitude,
             :longitude,
             :speed
end
