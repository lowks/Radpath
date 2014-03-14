Code.require_file "test_helper.exs", __DIR__

defmodule RadpathTest do
  use ExUnit.CaseTemplate
  import PathHelpers

  using do
    quote do
      import PathHelpers
    end
  end

  setup do
    File.mkdir_p!(tmp_path)
    :ok
  end
  
  teardown do
    File.rm_rf(tmp_path)
    :ok
  end
end

defmodule RadpathTestReal do
  use ExUnit.Case

  import Radpath
  test :test_listing_of_files do
    files = Radpath.files(".", "exs") |> Enum.map(&Path.basename(&1))
    assert files == ["mix.exs"]
  end
  
  test :test_listing_of_dirs do
    dirs = Radpath.dirs("lib") |> Enum.map(&Path.basename(&1))
    assert dirs == []
  end
end

