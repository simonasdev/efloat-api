require 'googlemaps/services/client'
require 'googlemaps/services/directions'
require 'geo/coord'

module Import
  class Tracks
    include GoogleMaps::Services

    GEO_ATTRS = %i[latd latm lats lngd lngm lngs]

    attr_reader :race, :sheet, :directions

    def initialize race, file
      @race = race
      @sheet = RubyXL::Parser.parse(file)[0]

      @directions = Directions.new(GoogleClient.new(
        key: Rails.application.credentials.google_maps_api_key || Rails.application.secrets[:google_maps_api_key],
        response_format: :json
      ))
    end

    def run!
      track_data = []

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

        values = values.map.with_index do |value, i|
          if i < 3 && value.present?
            if i == 1
              value.to_s.split("\n").map(&parse_coords).join("\n")
            else
              parse_coords.call value
            end
          else
            value
          end
        end

        start_coords = values[0]
        waypoint_coords = values[1].to_s.split("\n").presence
        end_coords = values[2]

        track_data << {
          route: [start_coords, end_coords],
          kind: values[3],
          name: values[4],
          speed_limit: values[5],
          waypoints: waypoint_coords,
        }
      end

      race.transaction do
        race.tracks.destroy_all

        track_data.each do |attrs|
          options = {
            origin: attrs[:route].first,
            destination: attrs[:route].last,
          }
          options[:waypoints] = attrs.delete(:waypoints)

          next if options.values.all?(&:blank?)

          result = directions.query(options).first.with_indifferent_access

          coords = result[:legs].map do |hash|
            hash[:steps].map do |step|
              GoogleMaps::Services::Convert.decode_polyline(step[:polyline][:points])
            end
          end

          attrs[:route] = coords.flatten.map(&:values)
          attrs[:length] = result[:legs].sum do |hash|
            hash[:distance][:value]
          end

          race.tracks.create attrs
        end
      end
    end
  end
end
