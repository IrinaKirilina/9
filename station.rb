# frozen_string_literal: true

require './instance_counter'
require './valid'

class Station
  include InstanceCounter

  attr_accessor :name
  attr_reader :trains, :all

  NAME_FORMATE = /^[a-zа-я]{3}/i.freeze

  def initialize(name)
    @name = name
    @trains = []
    @all = []

    validate!

    register_instance
  end

  def arrival(train)
    @trains << train
  end

  def departure(train)
    @trains.delete(train)
  end

  def trains_by_type(type)
    @trains.select { |train| train.type == type }
  end

  def validate!
    raise 'Необходимо ввести наименование станции' if name.nil?
    raise 'Наименование должно содержать не менее 3 символов' if name.length < 3
    raise 'Неверный формат наименования станции' if name !~ NAME_FORMATE

    true
  end

  def each_train(&block)
    @trains.each(&block) if block_given?
  end
end
