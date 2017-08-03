defmodule PathHelpers do
  def tmp_path() do
    Path.expand("test_temp", __DIR__)
  end

  def fixture_path() do
    Path.expand("fixtures", __DIR__)
  end
end
ExUnit.start
# Amrita.start(formatters: [Amrita.Formatter.Documentation])
