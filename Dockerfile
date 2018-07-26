FROM starefossen/ruby-node:alpine

RUN apk update && apk add build-base sqlite-dev tzdata git

RUN mkdir /app
WORKDIR /app

ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true
COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test --deployment
COPY . .
RUN npm install
RUN bundle exec rake assets:precompile

LABEL maintainer="Justin Coyne <jcoyne@justincoyne.com>"

CMD puma -C config/puma.rb
