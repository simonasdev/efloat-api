class DriverDevice < ApplicationRecord
  belongs_to :driver
  belongs_to :device
  belongs_to :race
end
