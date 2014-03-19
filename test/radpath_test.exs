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
  import PathHelpers
  alias :file, as: F

  test :test_listing_of_files do
    files = Radpath.files(fixture_path, "txt") |> Enum.map(&Path.basename(&1))
    ["file1.txt", "file2.txt"] |> Enum.map&(assert Enum.member?(files, &1))
  end
  
  test :test_listing_of_dirs do
    dirs = Radpath.dirs(fixture_path) |> Enum.map(&Path.basename(&1))
    ["testdir3", "testdir2", "testdir1"] |> Enum.map&(assert Enum.member?(dirs, &1))
  end

  test :test_filtering_of_listing_files_listing do
    files = Radpath.files(fixture_path, "log") |> Enum.map(&Path.basename(&1))
    assert files == ["file3.log"]
  end

  test :test_symlink_of_existing_src_dir do
    src = Path.join(fixture_path, "testdir3")
    dest = Path.join(Path.expand("."), "testdir3")
    
    try do
      refute File.exists?(dest)
      Radpath.symlink(src, dest)
      assert elem(F.read_link(dest), 0) == :ok
      assert File.exists?(dest)
    after
      File.rm_rf dest
    end
  end
  
  test :test_symlink_of_non_existing_src_dir do
    src = Path.join(fixture_path, "testdir3xx")
    dest = Path.join(Path.expand("."), "testdir3")
    
    try do
      refute File.exists?(dest)
      Radpath.symlink(src, dest)
      assert F.read_link(dest) == {:error, :enoent}
      refute File.exists?(dest)
    after
      File.rm_rf dest
    end
  end

  test :test_mktempdir_with_argument_function do
    src = Path.join(fixture_path, "testdir3")
    tmpdirpath = Radpath.mktempdir(src)
    try do
      assert File.exists?(tmpdirpath)
    after 
      File.rm_rf tmpdirpath
    end
  end

  test :test_mktempdir_without_argument_function do
    tmpdirpath1 = Radpath.mktempdir
    assert File.exists?(tmpdirpath1)
    File.rm_rf tmpdirpath1
  end
end

