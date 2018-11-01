FROM alpine:3.8

# Create and set the working directory as /opt
RUN mkdir /opt
WORKDIR /opt

# Expose port 3000
EXPOSE 3000

# Build argument for injecting native packages at build time via docker-compose
RUN apk --no-cache add \
    git \
    ruby \
    ruby-bundler \
    ruby-irb \
    tzdata \
    postgresql-dev \
    build-base \
    ruby-dev \
    libxml2-dev \
    libxslt-dev

# Copy the Gemfile and Gemfile.lock, and run bundle install prior to copying all source files
# This is an optimization that will prevent the need to re-run bundle install when only source
# code is changed and not dependencies.
COPY Gemfile /opt
COPY Gemfile.lock /opt
RUN bundle install --without development test && rm -rfv ~/.bundle/cache
