#!/bin/bash
set -e  # Exit on any error

# Update package list and install dependencies
sudo apt-get update
sudo apt-get install -y curl build-essential git wget

# Install Erlang
wget -q https://packages.erlang-solutions.com/erlang/debian/erlang_solutions.asc -O- | sudo apt-key add -
echo "deb https://packages.erlang-solutions.com/debian $(lsb_release -cs) contrib" | sudo tee /etc/apt/sources.list.d/erlang.list
sudo apt-get update
sudo apt-get install -y esl-erlang

# Install Elixir manually (specific version for reliability)
ELIXIR_VERSION="1.15.7"  # Adjust as needed
wget -q https://github.com/elixir-lang/elixir/releases/download/v${ELIXIR_VERSION}/elixir-otp-25.zip -O /tmp/elixir.zip
sudo unzip -q /tmp/elixir.zip -d /usr/local/elixir
sudo ln -sf /usr/local/elixir/bin/elixirc /usr/local/bin/elixirc
sudo ln -sf /usr/local/elixir/bin/elixir /usr/local/bin/elixir
sudo ln -sf /usr/local/elixir/bin/iex /usr/local/bin/iex
sudo ln -sf /usr/local/elixir/bin/mix /usr/local/bin/mix
rm /tmp/elixir.zip

# Install Node.js (LTS version, since v12 is outdated)
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install Hex and Rebar
mix local.hex --force
mix local.rebar --force

# Install Livebook
mix archive.install hex livebook --force

# Verify installations
echo "Erlang version:"
erl -eval 'erlang:display(erlang:system_info(otp_release)), halt().' -noshell
echo "Elixir version:"
elixir --version
echo "Node.js version:"
node --version