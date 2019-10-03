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

          next if values.empty?

          parse_coords = -> value do
            coords = value.to_s.strip.chomp(',').squeeze(', ').gsub(', ', ',').split(',').map { |c| c.split('.', 3) }

            if coords.first.size === 3 && coords.last.size === 3
              Geo::Coord.new(GEO_ATTRS.zip(coords.flatten.map(&:to_i)).to_h).to_s(dms: false)
            else
              value
            end
          end

          values = values.map.with_index do |value, i|
            if i == 2 && value.present?
              parse_coords.call(value.gsub(', ', ',').gsub(' ', ','))
            else
              value
            end
          end

          if values[2]
            lat, lon = values[2].split(',').map(&:strip)
            number = values[1]

            race.markers.create(
              track: Track.speed.find_by(name: values[0]),
              latitude: lat,
              longitude: lon,
              number: number.is_a?(Float) ? number.to_i : number,
            )
          end
        end
      end

    end
  end
end
