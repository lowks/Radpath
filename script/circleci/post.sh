#!/bin/bash
export MIX_ENV="docs"
export PATH="$HOME/dependencies/erlang/bin:$HOME/dependencies/elixir/bin:$PATH"
mix local.hex --force
mix deps.get --only docs
mix inch.report
