FROM ruby:3.0.0-alpine
RUN apk update && apk add git build-base
WORKDIR /app
COPY . .
RUN bundle install
CMD bundle exec rake
