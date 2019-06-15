class Driver < ApplicationRecord
  enum kind: %i[driver security ambulance other]

  store_accessor :data, :car, :country
end
