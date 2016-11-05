#!/bin/bash
export MIX_ENV="test"
export PATH="$HOME/dependencies/erlang/bin:$HOME/dependencies/elixir/bin:$PATH"
# mix amrita --trace
mix test
export MIX_ENV="docs"
mix deps.get --only docs
mix inch.report
