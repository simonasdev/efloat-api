class MarkerSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id,
             :latitude,
             :longitude,
             :number,
             :track_id,
             :kind
end
