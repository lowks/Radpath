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
  alias :zip, as: Z

  defchecker path_exists(path) do
    File.exists?(path) |> truthy
  end

  facts "Test Listing" do
    fact "Test listing: Files" do
      files = Radpath.files(fixture_path, "txt") |> Enum.map(&Path.basename(&1))
      Enum.each(["file1.txt", "file2.txt"], fn(x) -> files |> contains x end)
    end
  
    fact "Test listing: Directories" do
      dirs = Radpath.dirs(fixture_path) |> Enum.map(&Path.basename(&1))
      Enum.each(["testdir3", "testdir2", "testdir1"], fn(x) -> dirs |> contains x end)
    end
  end

  facts "Test zipping" do
    fact "Test zip: List of directories" do

      Path.join(fixture_path, "Testdir1.zip") |> ! path_exists
      try do
        Radpath.zip([fixture_path], "Testdir1.zip")
        "Testdir1.zip" |> path_exists
        System.cmd("zip -T Testdir1.zip") |> String.strip |> equals "test of Testdir1.zip OK"
      after
        File.rm_rf("Testdir1.zip")
      end
    end

    fact "Test zip: One path" do
      
      Path.join(fixture_path, "Testdir2.zip") |> ! path_exists

      try do
        Radpath.zip([fixture_path], "Testdir2.zip")
        "Testdir2.zip" |> path_exists
        System.cmd("zip -T Testdir2.zip") |> String.strip |> equals "test of Testdir2.zip OK"
      after
        File.rm_rf("Testdir2.zip")
      end
  end
  
  fact "Test zip: One bitstring path" do
    dir = Path.join(fixture_path, "Testdir1")
    Path.join(fixture_path, "Testdir1.zip") |> ! path_exists
    try do
      Radpath.zip(dir, "Testdir1.zip")
      "Testdir1.zip" |> path_exists
    after
      File.rm_rf("Testdir1.zip")
    end
  end
  end

  facts "Test Filtering" do
    fact "Test Filtering: files" do
      files = Radpath.files(fixture_path, "log") |> Enum.map(&Path.basename(&1))
      files |> ["file3.log"]
    end

    fact "Test Filtering: Multiple filter for files function" do
      files = Radpath.files(fixture_path, ["log", "txt"]) |> Enum.map(&Path.basename(&1))
      ["file1.txt", "file2.txt", "file3.log"] |> for_all (&Enum.member?(files, &1))
    end
  end

  facts "Test symlink" do
    fact "Test symlink: Normal Usage" do
      src = Path.join(fixture_path, "testdir3")
      dest = Path.join(Path.expand("."), "testdir3")
    
      try do
        dest |> ! path_exists
        Radpath.symlink(src, dest)
        elem(F.read_link(dest), 0) |> equals :ok
        dest |> path_exists
      after
        File.rm_rf dest
      end
    end
  
    fact "Test symlink: For non existent src file" do
      src = Path.join(fixture_path, "testdir3xx")
      dest = Path.join(Path.expand("."), "testdir3")
      
      try do
        dest |> ! path_exists
        Radpath.symlink(src, dest)
        F.read_link(dest) |> equals {:error, :enoent}
        dest |> ! path_exists
      after
        File.rm_rf dest
      end
    end
  end

  facts "Test Tempfilefs" do
    fact "Test mktempdir: With argument" do
      src = Path.join(fixture_path, "testdir3")
      tmpdirpath = Radpath.mktempdir(src)
      try do
        tmpdirpath |> path_exists
      after 
        File.rm_rf tmpdirpath
      end
    end

    fact "Test mktempdir: Without argument" do
      tmpdirpath1 = Radpath.mktempdir
      tmpdirpath1 |> path_exists
      File.rm_rf tmpdirpath1
    end

    fact "Test mktempdir: Nonexistant parent path, error returned" do
      tmpdirpath = Radpath.mktempdir("/gogo/gaga/gigi")
      try do
        tmpdirpath |> ! path_exists
        elem(tmpdirpath, 0) == :error
      end
    end
  end

  facts "Test Rename" do
    fact "Test Rename: Normal Usage" do
      source_file = "/tmp/hoho.txt"
      dest_file = "/tmp/hehe.txt"
      File.touch!(source_file)
      try do
        source_file |> path_exists
        Radpath.rename(source_file, dest_file)
        source_file |> ! path_exists
        dest_file |> path_exists
      after
        File.rm_rf dest_file
      end
    end

    fact "Test Rename: Source file does not exist" do
      source_file = "/tmp/hoho.txt"
      dest_file = "/tmp/hehe.txt"
      source_file |> ! path_exists
      Radpath.rename(source_file, dest_file)
      dest_file |> ! path_exists
    end
  end

  facts "Test relative paths" do
    fact "Test relative_path: Normal Usage" do
      Radpath.relative_path("/tmp/base", "/tmp/base/hoho.txt") |> equals "hoho.txt"
    end

    fact "Test relative_path: If same path is given empty string will result" do
      Radpath.relative_path("/tmp/base/", "/tmp/base/") |> equals ""
    end
  end

  facts "Test ensure" do
    fact "Test ensure: Ensure Directory is created" do
      test_dir_path = Path.join(fixture_path, "gogo/gaga")
      test_dir_path |> ! path_exists
      try do
        Radpath.ensure(test_dir_path)
        test_dir_path |> path_exists
      after
        File.rm_rf(test_dir_path)
      end
    end

    fact "Test ensure: Ensure File is created" do
      test_file_path = Path.join(fixture_path, "gogo/gaga.txt")
      test_file_path |> ! path_exists
      try do
        Radpath.ensure(test_file_path)
        test_file_path |> path_exists
      after
        File.rm_rf(test_file_path)
      end
    end
  end

end

