#!/bin/bash
set -e  # Exit on error
set -x  # Print commands for debugging

# Update package list and install basic tools
sudo apt-get update
sudo apt-get install -y curl build-essential git wget unzip gnupg software-properties-common

# Add RabbitMQ Erlang PPA (OTP 26 by default)
echo "Adding RabbitMQ Erlang PPA..."
sudo add-apt-repository -y ppa:rabbitmq/rabbitmq-erlang
sudo apt-get update

# Install Erlang OTP 26
echo "Installing Erlang OTP 26..."
sudo apt-get install -y erlang-base erlang-nox erlang-dev
if ! command -v erl >/dev/null; then
  echo "Erlang installation failed!"
  exit 1
fi
ERL_VERSION=$(erl -eval 'erlang:display(erlang:system_info(otp_release)), halt().' -noshell | tr -d '"')
echo "Installed Erlang version: $ERL_VERSION"

# Install Elixir 1.18.2 (match OTP 26)
echo "Installing Elixir 1.18.2..."
ELIXIR_VERSION="1.18.2"
wget -v https://github.com/elixir-lang/elixir/releases/download/v${ELIXIR_VERSION}/elixir-otp-26.zip -O /tmp/elixir.zip || {
  echo "Failed to download Elixir $ELIXIR_VERSION for OTP 26! Check URL or network."
  exit 1
}
sudo unzip -q /tmp/elixir.zip -d /usr/local/elixir || {
  echo "Failed to unzip Elixir!"
  exit 1
}
sudo ln -sf /usr/local/elixir/bin/elixirc /usr/local/bin/elixirc
sudo ln -sf /usr/local/elixir/bin/elixir /usr/local/bin/elixir
sudo ln -sf /usr/local/elixir/bin/iex /usr/local/bin/iex
sudo ln -sf /usr/local/elixir/bin/mix /usr/local/bin/mix
rm /tmp/elixir.zip
if ! command -v elixir >/dev/null; then
  echo "Elixir installation failed!"
  exit 1
fi

# Install Node.js
echo "Installing Node.js..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
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