class Track < ApplicationRecord
  belongs_to :race
  has_many :points

  enum kind: %i[speed passage limited]

  def length_in_km
    "#{ (length / 1000).round(2) }km" if length
  end

  def identity
    points.map(&:coordinate)
  end
end
