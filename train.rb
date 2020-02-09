class Train
  include ManufacturingCompany
  include InstanceCounter
  attr_reader :number, :carriage, :type, :current_route
  attr_accessor :current_station

  @@trains = []

  def self.find(number)
    @@trains.find { |train| train.number.include?(number) }
  end

  def initialize(number, type)
    register_instance
    @@trains << self
    @number = number
    @type = type
    @carriages = []
    @speed = 0
    @current_route = nil
  end

  def add_speed(plus_speed)
    @speed += plus_speed
  end

  def current_speed
    @speed
  end

  def stop
    @speed = 0
  end

  def add_carriage(carriage)
    @carriages << carriage if @speed == 0
  end

  def remove_carriage
    @carriages.pop if @speed == 0
  end

  def add_route(current_route)
    @current_route = current_route
    @current_route.stations.first.take_train(self)
  end

  def current_station
    @current_route.stations.find { |station| station.trains.include?(self) }
  end

  def prev_station
    @current_route.stations[current_station_index - 1] if current_station != @current_route.stations.first
  end

  def next_station
    @current_route.stations[current_station_index + 1] if current_station != @current_route.stations.last
  end

  def go_next
    return unless next_station
    departure_station = current_station
    next_station.take_train(self)
    departure_station.send_train(self)
  end

  def go_prev
    return unless prev_station
    departure_station = current_station
    prev_station.take_train(self)
    departure_station.send_train(self)
  end

  private #метод используется только объектом для получения индекса

  def current_station_index
    @current_route.stations.index(current_station)
  end


end
