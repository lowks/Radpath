Amrita.start(formatter: Amrita.Formatter.Documentation)

defmodule PathHelpers do
  def tmp_path() do
    Path.expand("test_temp", __DIR__)
  end
  def fixture_path() do
    Path.expand("fixtures", __DIR__)
  end
end
