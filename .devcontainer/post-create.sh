#!/bin/bash
# Update package list and install dependencies
sudo apt-get update
sudo apt-get install -y curl build-essential git

# Install Erlang (required for Elixir)
curl -fsSL https://packages.erlang-solutions.com/erlang/debian/erlang_solutions.asc | sudo apt-key add -
echo "deb https://packages.erlang-solutions.com/debian $(lsb_release -cs) contrib" | sudo tee /etc/apt/sources.list.d/erlang.list
sudo apt-get update
sudo apt-get install -y esl-erlang

# Install Elixir
curl -fsSL https://elixir-lang.org/install.sh | bash
source ~/.bashrc

# Install Node.js (for Livebook assets)
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install Hex and Rebar
mix local.hex --force
mix local.rebar --force

# Install Livebook
mix archive.install hex livebook --force