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

  fact "Test listing: Files" do
    files = Radpath.files(fixture_path, "txt") |> Enum.map(&Path.basename(&1))
    Enum.each(["file1.txt", "file2.txt"], fn(x) -> files |> contains x end)
  end
  
  fact "Test listing: Directories" do
    dirs = Radpath.dirs(fixture_path) |> Enum.map(&Path.basename(&1))
    Enum.each(["testdir3", "testdir2", "testdir1"], fn(x) -> dirs |> contains x end)
  end

  fact "Test zip: List of directories" do
    dir1 = Path.join(fixture_path, "Testdir1")
    dir2 = Path.join(fixture_path, "Testdir2")
    File.exists?(Path.join(fixture_path, "Testdir1.zip")) |> false

    try do
      Radpath.zip([dir1, dir2], "Testdir1.zip")
      File.exists?("Testdir1.zip") |> true
    after
      File.rm_rf("Testdir1.zip")
    end
  end

  fact "Test zip: One path" do
    dir = Path.join(fixture_path, "Testdir1")
    File.exists?(Path.join(fixture_path, "Testdir1.zip")) |> false
    try do
      Radpath.zip([dir], "Testdir1.zip")
      File.exists?("Testdir1.zip") |> true
    after
      File.rm_rf("Testdir1.zip")
    end
  end

  fact "Test zip: One bitstring path" do
    dir = Path.join(fixture_path, "Testdir1")
    File.exists?(Path.join(fixture_path, "Testdir1.zip")) |> false
    try do
      Radpath.zip(dir, "Testdir1.zip")
      File.exists?("Testdir1.zip") |> true
    after
      File.rm_rf("Testdir1.zip")
    end
  end

  fact "Test filtering of files" do
    files = Radpath.files(fixture_path, "log") |> Enum.map(&Path.basename(&1))
    files |> ["file3.log"]
  end

  fact "Test multiple filter for files function" do
    files = Radpath.files(fixture_path, ["log", "txt"]) |> Enum.map(&Path.basename(&1))
    ["file1.txt", "file2.txt", "file3.log"] |> Enum.map&(assert Enum.member?(files, &1))
  end

  fact "Test symlink" do
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
  
  fact "Test symlink: For non existent src file" do
    src = Path.join(fixture_path, "testdir3xx")
    dest = Path.join(Path.expand("."), "testdir3")
    
    try do
      File.exists?(dest) |> false
      Radpath.symlink(src, dest)
      F.read_link(dest) |> equals {:error, :enoent}
      File.exists?(dest) |> false
    after
      File.rm_rf dest
    end
  end

  fact "Test mktempdir: With argument" do
    src = Path.join(fixture_path, "testdir3")
    tmpdirpath = Radpath.mktempdir(src)
    try do
      File.exists?(tmpdirpath) |> true
    after 
      File.rm_rf tmpdirpath
    end
  end

  fact "Test mkdtempdir: Without argument" do
    tmpdirpath1 = Radpath.mktempdir
    File.exists?(tmpdirpath1) |> true
    File.rm_rf tmpdirpath1
  end

  fact "Test Rename" do
    source_file = "/tmp/hoho.txt"
    dest_file = "/tmp/hehe.txt"
    File.touch!(source_file)
    try do
      File.exists?(source_file) |> true
      Radpath.rename(source_file, dest_file)
      File.exists?(source_file) |> false
      File.exists?(dest_file) |> true
    after
      File.rm_rf dest_file
    end
  end

  fact "Test Rename: Source file does not exist" do
    source_file = "/tmp/hoho.txt"
    dest_file = "/tmp/hehe.txt"
    File.exists?(source_file) |> false
    Radpath.rename(source_file, dest_file)
    File.exists?(dest_file) |> false
  end

  fact "Test relative_path" do
    Radpath.relative_path("/tmp/base", "/tmp/base/hoho.txt") |> equals "hoho.txt"
  end

  fact "Test relative_path: If same path is given empty string will result" do
    Radpath.relative_path("/tmp/base/", "/tmp/base/") |> equals ""
  end
end

