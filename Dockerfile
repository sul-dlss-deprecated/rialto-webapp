FROM starefossen/ruby-node:alpine

RUN apk update && apk add build-base sqlite-dev tzdata git

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install
RUN yarn install

COPY . .

LABEL maintainer="Justin Coyne <jcoyne@justincoyne.com>"

CMD puma -C config/puma.rb
