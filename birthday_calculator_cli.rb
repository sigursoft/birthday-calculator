# frozen_string_literal: true

require './birthday_calculator'

# Use the BirthdayCalculator with MariaDB
birthday_calculator = BirthdayCalculator.new
birthday_calculator.load_data
birthday_calculator.print_days_remaining
