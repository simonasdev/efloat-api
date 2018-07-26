require 'geo/coord'

module Import
  class Markers
    attr_reader :race, :sheet

    GEO_ATTRS = %i[latd latm lats lngd lngm lngs]

    def initialize race, file
      @race = race
      @sheet = RubyXL::Parser.parse(file)[0]
    end

    def run!
      marker_data = []

      race.transaction do
        race.markers.destroy_all

        sheet.each_with_index do |row, index|
          next if index.zero?

          values = row.cells.map { |cell| cell && cell.value }

          parse_coords = -> value do
            coords = value.split(',').map { |c| c.split('.', 3) }

            if coords.first.size === 3 && coords.last.size === 3
              Geo::Coord.new(GEO_ATTRS.zip(coords.flatten.map(&:to_i)).to_h).to_s(dms: false)
            else
              value
            end
          end

          values.map.with_index do |value, i|
            if i == 1 && value.present?
              parse_coords.call value.to_s
            else
              value
            end
          end

          lat, lon = values[2].split(',').map(&:strip)
          race.markers.create(
            track: Track.speed.find_by(name: values[0]),
            latitude: lat,
            longitude: lon,
            number: values[1].to_i.to_s,
          )
        end
      end

    end
  end
end
