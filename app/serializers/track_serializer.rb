class TrackSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id,
             :race_id,
             :speed_limit,
             :route,
             :name,
             :kind,
             :length_in_km
end
