FROM suldlss/rialto-webapp:assets-latest as assets

# This image's actual base image
FROM suldlss/rialto-webapp:ruby-latest

LABEL maintainer="Justin Coyne <jcoyne@justincoyne.com>"
# Set default RAILS environment
ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true

# Copy the application's source into the image.
# See .dockerignore for the files in the local directory not being copied.
COPY . /opt

# Copy Precompiled Assets
COPY --from=assets /opt/public /opt/public

# Start the server by default, listening for all connections
CMD puma -C config/puma.rb
