#!/bin/bash
set -e  # Exit on error
set -x  # Print commands for debugging

# Update package list and install basic tools
sudo apt-get update
sudo apt-get install -y curl build-essential git wget unzip

# Install Erlang from Ubuntu repositories
echo "Installing Erlang from Ubuntu repos..."
sudo apt-get install -y erlang
# Verify Erlang
if ! command -v erl >/dev/null; then
  echo "Erlang installation failed!"
  exit 1
fi

# Install Elixir manually
echo "Installing Elixir..."
ELIXIR_VERSION="1.15.7"
wget -q https://github.com/elixir-lang/elixir/releases/download/v${ELIXIR_VERSION}/elixir-otp-25.zip -O /tmp/elixir.zip
sudo unzip -q /tmp/elixir.zip -d /usr/local/elixir
sudo ln -sf /usr/local/elixir/bin/elixirc /usr/local/bin/elixirc
sudo ln -sf /usr/local/elixir/bin/elixir /usr/local/bin/elixir
sudo ln -sf /usr/local/elixir/bin/iex /usr/local/bin/iex
sudo ln -sf /usr/local/elixir/bin/mix /usr/local/bin/mix
rm /tmp/elixir.zip
# Verify Elixir
if ! command -v elixir >/dev/null; then
  echo "Elixir installation failed!"
  exit 1
fi

# Install Node.js (LTS version)
echo "Installing Node.js..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
# Verify Node.js
if ! command -v node >/dev/null; then
  echo "Node.js installation failed!"
  exit 1
fi

# Install Hex and Rebar
echo "Installing Hex and Rebar..."
mix local.hex --force
mix local.rebar --force

# Install Livebook
echo "Installing Livebook..."
mix archive.install hex livebook --force

# Final verification
echo "Verification:"
echo "Erlang version:"
erl -eval 'erlang:display(erlang:system_info(otp_release)), halt().' -noshell
echo "Elixir version:"
elixir --version
echo "Node.js version:"
node --version