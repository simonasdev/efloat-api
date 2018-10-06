require 'csv'

namespace :devices do
  desc 'Set track times'
  task tracks: :environment do
    {
      'GR 0': [Time.parse('8:30'), Time.parse('10:00')],
      'GR 5': [Time.parse('9:00'), Time.parse('13:30')],
      'GR 4/6': [Time.parse('9:00'), Time.parse('13:30')],
      'GR 1/3': [Time.parse('12:00'), Time.parse('15:30')],
      'GR 3': [Time.parse('12:00'), Time.parse('15:30')],
      'GR 2': [Time.parse('12:00'), Time.parse('15:30')],
      'GR 7/9': [Time.parse('14:00'), Time.parse('18:30')],
      'GR 8/10': [Time.parse('14:00'), Time.parse('18:30')],
    }.each do |name, times|
      Track.find_by(name: name).update start_time: times.first, end_time: times.last
    end
  end

  desc 'Import devices'
  task import: :environment do
    data = File.read('devices.txt')

    Device.transaction do
      data.each_line.with_index do |line, index|
        if line.present?
          d = Device.driver.find_or_initialize_by(index: index + 1)
          d.update! number: line.strip
        end
      end
    end
  end

  desc 'Populate'
  task populate: :environment do
    Import::Devices.new(File.open('drivers.csv')).run!
  end

  desc 'Calibrate devices'
  task calibrate: :environment do
    Device.all.each do |device|
      CommandService.new(device, 'calibrate').send!
    end
  end

  desc 'Calibrate tilted devices'
  task calibrate_tilted: :environment do
    Device.all.each do |device|
      if line = device.current_data_line
        CommandService.new(device, 'calibrate').send! if line.orientation > 0
      end
    end
  end

  desc 'Dump report'
  task report: :environment do
    data = JSON.load(File.open('data.json'))

    CSV.open("report.csv", "wb") do |csv|
      data.each do |track_id, data_line_ids|
        track = Track.find(track_id)
        csv << track.slice(:name, :speed_limit).values
        lines = DataLine.preload(:device).where(id: data_line_ids).group_by { |line| "#{line.name}-#{line.timestamp.hour}"}

        lines.each do |key, data_lines|
          timestamps = data_lines.map(&:timestamp).sort
          min, max = timestamps.min, timestamps.max
          diff = (max - min).abs

          next if diff < 30

          data_line = data_lines.max_by(&:speed)
          csv << [data_line.slice(:name, :latitude, :longitude, :timestamp, :speed).values, data_line.speed - track.speed_limit, timestamps.join(', ')].flatten if data_line.speed - track.speed_limit > 20
        end
      end
    end
  end

  desc 'Dump time report'
  task time_report: :environment do
    data = JSON.load(File.open('more-data.json'))

    CSV.open("time-report.csv", "wb") do |csv|
      data.each do |track_id, data_line_ids|
        track = Track.find(track_id)
        csv << track.slice(:name, :start_time, :end_time).values
        lines = DataLine.preload(:device).where(id: data_line_ids).group_by(&:name)

        lines.each do |name, data_lines|
          data_line = data_lines.first

          csv << [name, data_line.slice(:latitude, :longitude, :speed, :timestamp).values].flatten if data_line
        end
      end
    end
  end
end
