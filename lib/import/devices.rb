require 'csv'

module Import
  class Devices
    def initialize(file)
      @data = CSV.read(file.path, encoding: 'UTF-8')
    end

    def run!
      ApplicationRecord.transaction do
        @data.each do |arr|
          next unless device = Device.find_by(index: arr[5].presence || arr[1])

          device.update!(
            state: :enabled,
            kind: arr[0],
            name: arr[2],
            position: arr[1],
            crew_data: {
              car: arr[4],
              country: arr[3]
            }
          )
        end
      end
    end
  end
end
