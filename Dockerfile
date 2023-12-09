# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.2.2
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim

# Rails app lives here
RUN mkdir /app
WORKDIR /app

# Install packages needed to build gems and node modules
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential curl git libpq-dev libvips postgresql-client

# Install node modules
RUN curl -sL https://deb.nodesource.com/setup_current.x | bash - && \
    apt-get install -y nodejs && \
    npm install --global yarn

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN gem install bundler
RUN bundle install
RUN bundle exec bootsnap precompile --gemfile app/ lib/

# Copy application code
COPY . .

# Entrypoint prepares the database.
ENTRYPOINT ["/app/bin/docker-entrypoint"]
# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]
