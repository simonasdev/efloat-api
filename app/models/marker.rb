class Marker < ApplicationRecord
  belongs_to :race
  belongs_to :track, optional: true

  enum kind: %i[safety]
end
