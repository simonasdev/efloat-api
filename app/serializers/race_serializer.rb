class RaceSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :title, :start_time, :end_time
  has_many :tracks
  has_many :markers
end
