#!/bin/sh
set -e
rm -f Gemfile.lock
bundle install --path "${HOME}/bundles/${JOB_NAME}"
bundle exec rake
publishing of the gem disabled for the moment, gem is taken from github directly by bundler
bundle exec rake publish_gem
