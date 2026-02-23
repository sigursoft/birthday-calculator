# frozen_string_literal: true

require 'dotenv/load'
require 'sequel'
require 'date'

class Person
  attr_reader :name, :birthday, :days_remaining

  def initialize(name, birthday, days_remaining)
    @name = name
    @birthday = birthday
    @days_remaining = days_remaining
  end

  def to_h
    { name: @name, birthday: @birthday, days_remaining: @days_remaining }
  end
end

# Birthday Calculator
class BirthdayCalculator
  attr_reader :persons

  def initialize(db_config = {})
    @db = Sequel.connect(
      adapter: 'mysql2',
      host: db_config[:host] || ENV['DB_HOST'] || '127.0.0.1',
      user: db_config[:username] || ENV['DB_USERNAME'] || raise('DB_USERNAME required'),
      password: db_config[:password] || ENV['DB_PASSWORD'] || raise('DB_PASSWORD required'),
      database: db_config[:database] || ENV['DB_NAME'] || 'birthdays'
    )
    @persons = []
    @today = Date.today
    @days_until_end_of_the_year = Date.new(@today.year, 12, 31).yday - @today.yday
  end

  def load_data
    @db[:birthdays].select(:name, :day, :month).each do |row|
      birthday = Date.parse("#{row[:day]} #{row[:month]}")
      days_remaining = calculate_days_remaining(birthday)
      @persons << Person.new(row[:name], birthday, days_remaining)
    end
    @persons.sort_by!(&:days_remaining)
  end

  def print_days_remaining
    @persons.each do |person|
      puts "#{person.name}: #{person.birthday.strftime('%-d %B')} - #{person.days_remaining} days remaining"
    end
  end

  private

  def calculate_days_remaining(birthday)
    if birthday.yday > @today.yday
      birthday.yday - @today.yday
    else
      birthday.yday + @days_until_end_of_the_year
    end
  end
end
