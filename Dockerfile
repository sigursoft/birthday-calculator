FROM docker.io/ruby:4.0.1

WORKDIR /app

COPY Gemfile Gemfile.lock birthday_calculator.gemspec ./
RUN bundle install

COPY birthday_calculator.rb birthday_calculator_app.rb ./

EXPOSE 4567

CMD ["ruby", "birthday_calculator_app.rb", "-o", "0.0.0.0"]
