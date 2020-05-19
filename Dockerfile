FROM ruby:2.7.1-alpine

LABEL maintainer="Aaron Collier <aaron.collier@stanford.edu>"

RUN apk add --update --no-cache \
  build-base \
  libxml2-dev \
  libxslt-dev \
  postgresql-dev \
  postgresql-client \
  tzdata \
  yarn

WORKDIR /app

RUN gem update --system && \
  gem install bundler

COPY Gemfile Gemfile.lock ./
RUN bundle config build.nokogiri --use-system-libraries && \
  bundle config set without 'production' && \
  bundle install

COPY package.json yarn.lock ./
RUN yarn install

COPY . .

CMD ["bin/puma", "-C", "config/puma.rb", "config.ru"]
