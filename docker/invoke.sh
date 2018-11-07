#!/bin/bash

set -e
echo "Waiting for db"
/app-setup/wait-for db:5432 -t 45 -- echo "Db is up"

set +e
echo "Setting up db. OK to ignore errors about test db."
# https://github.com/rails/rails/issues/27299
rails db:create

set -e
echo "Migrating db"
rails db:migrate

echo "Running webpack"
./bin/webpack-dev-server &

echo "Running server"
exec puma -C config/puma.rb config.ru