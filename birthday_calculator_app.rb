# frozen_string_literal: true

require 'sinatra'
require 'json'
require './birthday_calculator'

birthday_calculator = BirthdayCalculator.new
birthday_calculator.parse_data

before do
  content_type :json
end

get '/' do
  birthday_calculator.persons.map(&:to_h).to_json
end
