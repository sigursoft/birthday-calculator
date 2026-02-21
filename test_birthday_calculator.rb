# frozen_string_literal: true

require 'minitest/autorun'
require 'date'
require_relative 'birthday_calculator'

class TestPerson < Minitest::Test
  def test_person_initialization
    person = Person.new('John', Date.new(2026, 5, 15), 85)
    assert_equal 'John', person.name
    assert_equal Date.new(2026, 5, 15), person.birthday
    assert_equal 85, person.days_remaining
  end
end

class TestBirthdayCalculator < Minitest::Test
  def setup
    @db_config = {
      host: ENV['DB_HOST'] || '127.0.0.1',
      username: ENV['DB_USERNAME'] || 'root',
      password: ENV['DB_PASSWORD'] || 'root',
      database: ENV['DB_NAME'] || 'birthdays'
    }
    @calculator = nil
  end

  def test_initialization_with_config
    skip_db_connection do
      @calculator = BirthdayCalculator.new(@db_config)
      assert_instance_of BirthdayCalculator, @calculator
      assert_empty @calculator.persons
    end
  end

  def test_initialization_without_credentials_raises_error
    ENV.delete('DB_USERNAME')
    ENV.delete('DB_PASSWORD')
    assert_raises(RuntimeError) do
      BirthdayCalculator.new({})
    end
  ensure
    ENV['DB_USERNAME'] = @db_config[:username]
    ENV['DB_PASSWORD'] = @db_config[:password]
  end

  def test_calculate_days_remaining_future_birthday
    skip_db_connection do
      @calculator = BirthdayCalculator.new(@db_config)
      today = Date.today
      future_birthday = Date.new(today.year, today.month, today.day) + 30
      days = @calculator.send(:calculate_days_remaining, future_birthday)
      assert_equal 30, days
    end
  end

  def test_calculate_days_remaining_past_birthday
    skip_db_connection do
      @calculator = BirthdayCalculator.new(@db_config)
      today = Date.today
      past_birthday = Date.new(today.year, today.month, today.day) - 30
      days = @calculator.send(:calculate_days_remaining, past_birthday)
      days_until_end = Date.new(today.year, 12, 31).yday - today.yday
      expected = past_birthday.yday + days_until_end
      assert_equal expected, days
    end
  end

  private

  def skip_db_connection
    original_connect = Sequel.method(:connect)
    Sequel.define_singleton_method(:connect) { |*| Object.new }
    yield
  ensure
    Sequel.define_singleton_method(:connect, original_connect)
  end
end
