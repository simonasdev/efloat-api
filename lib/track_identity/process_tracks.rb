# module TrackIdentity::ProcessTracks
#   module_function

#   def run(force = false)
#     unless force || TrackIdentity.current_data_stale?
#       puts("Track identities up to date, skipping")
#       return
#     end

#     # Clear identity cache

#     ApplicationRecord.transaction do
#       puts 'delete'
#       Point.delete_all

#       Track.limited.order(:id).each do |track|
#         puts("Generating identity for track #{track.name} ##{track.id}...")

#         points = points_for_insert(track)
#         Point.import points

#         puts("#{track.name} ID##{track.id} done with #{points.size} points!")
#         puts
#       end
#     end

#     # Fill identity cache

#     TrackIdentity.log_successful_generation
#   end

#   def points_for_insert(track)
#     points = TrackIdentity::ProcessCoordinates.new(track.route).run

#     points.map { |point| track.points.new(x: point[0], y: point[1]) }
#   end
# end
