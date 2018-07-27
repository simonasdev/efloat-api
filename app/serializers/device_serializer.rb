class DeviceSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name, :number, :comment, :online, :position, :car, :country, :state

  attribute :current_data_line do |object|
    DataLineSerializer.new(object.current_data_line)
  end
end
