class Driver < ApplicationRecord
  enum kind: %i[driver security ambulance other]

  store_accessor :data, :car, :country

  has_many :driver_devices, dependent: :destroy
  has_many :devices, through: :driver_devices
  has_many :races, through: :driver_devices

  accepts_nested_attributes_for :driver_devices, reject_if: ->(attributes) { attributes.values_at('device_id', 'race_id').any?(:blank?) }
end
