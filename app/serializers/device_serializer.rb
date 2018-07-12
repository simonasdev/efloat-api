class DeviceSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name, :number, :comment, :online, :position, :car, :country

  attribute :status do |object|
    object.online? ? 'online' : 'offline'
  end

  attribute :current_data_line do |object|
    DataLineSerializer.new(object.current_data_line)
  end
end
