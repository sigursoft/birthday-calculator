# frozen_string_literal: true

require 'json'
require 'date'

class Person
  attr_reader :name, :birthday, :days_remaining

  def initialize(name, birthday, days_remaining)
    @name = name
    @birthday = birthday
    @days_remaining = days_remaining
  end
end

# Birthday Calculator
class BirthdayCalculator
  attr_reader :persons

  BIRTHDAY_FILE = 'birthday.json'

  def initialize
    @persons = []
    @today = Date.today
    @days_until_end_of_the_year = Date.new(@today.year, 12, 31).yday - @today.yday
  end

  def parse_data
    file = File.read(BIRTHDAY_FILE)
    JSON.parse(file).map! do |person|
      birthday = Date.parse("#{person['day']} #{person['month']}")
      days_remaining = calculate_days_remaining(birthday)
      @persons << Person.new(person['name'], birthday, days_remaining)
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
