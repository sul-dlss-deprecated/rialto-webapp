FROM ruby:2.5-alpine3.8

# Create and set the working directory as /opt
RUN mkdir /opt
WORKDIR /opt

# Expose port 3000
EXPOSE 3000

# Copy the Gemfile and Gemfile.lock, and run bundle install prior to copying all source files
# This is an optimization that will prevent the need to re-run bundle install when only source
# code is changed and not dependencies.
COPY Gemfile /opt
COPY Gemfile.lock /opt

ENV BUNDLER_VERSION 2.0.1

RUN apk --no-cache add \
  libpq \
  tzdata


# Build argument for injecting native packages at build time via docker-compose
RUN apk --no-cache add --virtual build-dependencies \
  build-base \
  postgresql-dev && \
  gem install bundler && \
  bundle install --without development test \
  && apk del build-dependencies
