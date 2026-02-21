# frozen_string_literal: true

require 'sinatra'
require 'json'
require './birthday_calculator'

BIRTHDAY_FILE = 'birthday.json'

birthday_calculator = BirthdayCalculator.new(BIRTHDAY_FILE)
birthday_calculator.load_data

before do
  content_type :json
end

get '/' do
  birthday_calculator.persons.map(&:to_h).to_json
end
