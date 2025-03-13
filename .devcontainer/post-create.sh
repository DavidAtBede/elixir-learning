#!/bin/bash
# Install Livebook
mix local.hex --force
mix local.rebar --force
mix archive.install hex livebook --force

# Start Livebook (optional, can be run manually later)
# livebook server --port 8080