# frozen_string_literal: true

require './birthday_calculator'

birthday_calculator = BirthdayCalculator.new
birthday_calculator.parse_data
birthday_calculator.print_days_remaining
