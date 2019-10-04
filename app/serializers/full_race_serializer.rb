class FullRaceSerializer < RaceSerializer
  set_type :race

  has_many :tracks do |object, params|
    object.tracks.where(kind: params[:kind])
  end

  has_many :markers
end
