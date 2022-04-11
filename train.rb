# frozen_string_literal: true

require './manufacturer'
require './instance_counter'
require './valid'

class Train
  include Manufacturer
  include InstanceCounter

  attr_reader :cars, :speed, :route, :current_station_index
  attr_accessor :number, :type

  NUMBER_FORMAT = /^[а-яa-z\d]{3}-?[а-яa-z\d]{2}$/i.freeze

  def initialize(number)
    @number = number
    @speed = 0
    @route = route
    @current_station_index = current_station_index
    @cars = []
    @trains = []

    validate_train!

    register_instance
  end

  def accelerate
    speed + 1
  end

  def deccelerate
    speed - 1 unless train_stopped?
  end

  def add_car(car)
    cars << car if train_stopped? && type == car.type
  end

  def remove_car
    cars.delete(car) if train_stopped? && cars.count.positive?
  end

  def assign_route(route)
    @route = route
    @current_station_index = 1
  end

  def move_forward
    @current_station_index += 1 if route && !last_staion?
  end

  def move_backward
    @current_station_index -= 1 if route && !first_station?
  end

  def first_station?
    current_station_index == 1
  end

  def last_station?
    current_station_index == route.stations.count
  end

  def train_stopped?
    speed.zero?
  end

  def previous_station
    route.stations[current_station_index - 2].name unless first_station?
  end

  def current_station
    route.stations[current_station_index - 1].name
  end

  def next_station
    route.stations[current_station_index].name unless last_station?
  end

  def find(number)
    @trains.find { |train| train.number == number }
  end

  def validate_train!
    raise 'Необходимо ввести номер поезда' if number.nil?
    raise 'Номер должен содержать не менее 5 символов' if number.length < 5
    raise 'Неверный формат номера' if number !~ NUMBER_FORMAT

    true
  end

  def each_car(&block)
    @cars.each(&block) if block_given?
  end

  def find_car(number)
    @cars.find { |car| car.number == number }
  end
end
