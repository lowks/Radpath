Code.require_file "test_helper.exs", __DIR__

defmodule RadpathTestInit do
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

defmodule RadpathTests do
  use Amrita.Sweet
  
  import PathHelpers
  alias :file, as: F

  fact "Test listing of files" do
    files = Radpath.files(fixture_path, "txt") |> Enum.map(&Path.basename(&1))
    Enum.each(["file1.txt", "file2.txt"], fn(x) -> files |> contains x end)
  end
  
  fact "Test listing of directories" do
    dirs = Radpath.dirs(fixture_path) |> Enum.map(&Path.basename(&1))
    Enum.each(["testdir3", "testdir2", "testdir1"], fn(x) -> dirs |> contains x end)
  end

  fact "Test zipping of directories" do
    dir1 = Radpath.dirs(Path.join(fixture_path, "Testdir1"))
    dir2 = Radpath.dirs(Path.join(fixture_path, "Testdir2"))
    File.exists?(Path.join(fixture_path, "Testdir1.zip")) |> false

    try do
      Radpath.zip("Testdir1.zip", [dir1, dir2])
      File.exists?("Testdir1.zip") |> true
    after
      File.rm_rf("Testdir1.zip")
    end
  end

  fact "Test zipping of directories with str path arg" do
    dir = Radpath.dirs(Path.join(fixture_path, "Testdir1"))
    refute File.exists?(Path.join(fixture_path, "Testdir1.zip"))
    try do
      Radpath.zip("Testdir1.zip", dir)
      #assert File.exists?("Testdir1.zip")
      File.exists?("Testdir1.zip") |> true
    after
      File.rm_rf("Testdir1.zip")
    end
  end

  fact "Test filtering of files" do
    files = Radpath.files(fixture_path, "log") |> Enum.map(&Path.basename(&1))
    #assert files == ["file3.log"]
    files |> ["file3.log"]
  end

  fact "Test multiple filter for files function" do
    files = Radpath.files(fixture_path, ["log", "txt"]) |> Enum.map(&Path.basename(&1))
    ["file1.txt", "file2.txt", "file3.log"] |> Enum.map&(assert Enum.member?(files, &1))
  end

  fact "Test symlink for src file that exists" do
    src = Path.join(fixture_path, "testdir3")
    dest = Path.join(Path.expand("."), "testdir3")
    
    try do
      File.exists?(dest) |> false
      Radpath.symlink(src, dest)
      elem(F.read_link(dest), 0) |> equals :ok
      File.exists?(dest) |> true
    after
      File.rm_rf dest
    end
  end
  
  fact "Test symlink for non existent src file" do
    src = Path.join(fixture_path, "testdir3xx")
    dest = Path.join(Path.expand("."), "testdir3")
    
    try do
      #refute File.exists?(dest)
      File.exists?(dest) |> false
      Radpath.symlink(src, dest)
      F.read_link(dest) |> equals {:error, :enoent}
      File.exists?(dest) |> false
    after
      File.rm_rf dest
    end
  end

  fact "Test mktempdir with argument" do
    src = Path.join(fixture_path, "testdir3")
    tmpdirpath = Radpath.mktempdir(src)
    try do
      File.exists?(tmpdirpath) |> true
    after 
      File.rm_rf tmpdirpath
    end
  end

  fact "Test mkdtempdir without argument" do
    tmpdirpath1 = Radpath.mktempdir
    File.exists?(tmpdirpath1) |> true
    File.rm_rf tmpdirpath1
  end
end

