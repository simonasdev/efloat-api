class RaceSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :title, :start_time, :end_time

  has_many :tracks do |object, params|
    object.tracks.where(kind: params[:kind])
  end

  has_many :markers

end
