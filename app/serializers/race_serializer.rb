class RaceSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :title, :start_time, :end_time, :public
end
