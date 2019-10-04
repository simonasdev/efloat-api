class Track < ApplicationRecord
  belongs_to :race
  has_many :points, dependent: :delete_all

  enum kind: %i[speed passage limited]

  before_save :calculate_length, if: :route_changed?, on: :update

  def length_in_km
    "#{ (length / 1000).round(2) }km" if length
  end

  def identity
    points.map(&:coordinate)
  end

  private

  def calculate_length
    self.length = PolylineLength.for(route)
  end
end
