Code.require_file "../test_helper.exs", __ENV__.file

defmodule RadpathTests.RadpathFacts do

  # use Amrita.Sweet
  # use ExUnit.Case, async: true
  use ExUnit.Case
  use PatternTap

  import PathHelpers
    import Path, only: [basename: 1]
  import Enum, only: [map: 2]

  alias :file, as: F

  defmodule ZippingTest do

    use ExUnit.Case
    def path_exists(path) do
        assert File.exists?(path)
    end

    defmodule ZipTest do
      use ExUnit.Case
      try do
        Path.join(fixture_path, "Testdir1.zip") |> File.exists? |> refute
        Radpath.zip([fixture_path], "Testdir1.zip")
        # "Testdir1.zip" |> File.exists?
        "Testdir1.zip" |> File.exists?
        # System.cmd("zip",["-T","Testdir1.zip"])
        # |> {"test of Testdir1.zip OK\n", 0}
        # System.cmd("zipinfo",["-1","Testdir1.zip"])
        # |> tap({result_str, _} ~> result_str)
        # |> contains "testdir1"
      after
        File.rm_rf("Testdir1.zip")
      end
    end

    defmodule TestZipOnePath  do
       use ExUnit.Case

      dir = Path.join(fixture_path, "testdir2")

      try do
        Path.join(fixture_path, "Testdir2.zip") |> File.exists? |> refute
        Radpath.zip([dir], "Testdir2.zip")
        # "Testdir2.zip" |> File.exists? |> assert
        assert File.exists? "Testdir2.zip"
        # System.cmd("zip",["-T","Testdir2.zip"])
        # |> tap({result_str, _} ~> result_str)
        # |> String.strip |> "test of Testdir2.zip OK"
        # System.cmd("zipinfo",["-1","Testdir2.zip"])
        # |> tap({result_str2, _} ~> result_str2)
        # |> contains "testdir2"
      after
        File.rm_rf("Testdir2.zip")
      end
    end
  end

  defmodule TestZipOneBitstringPath do
    use ExUnit.Case
    dir = Path.join(fixture_path, "testdir1")
    try do
      Path.join(fixture_path, "Testdir3.zip") |> File.exists? |> refute
      Radpath.zip(dir, "Testdir3.zip")
      # "Testdir3.zip" |> File.exists?
      assert File.exists? "Testdir3.zip"
      # System.cmd("zip",["-T","Testdir3.zip"]) |>
      #           {"test of Testdir3.zip OK\n", 0}
      # System.cmd("zipinfo",["-1","Testdir3.zip"])
      # |> tap({result_str, _} ~> result_str)
      # |> contains "testdir1"
    after
      File.rm_rf("Testdir3.zip")
    end
  end

  defmodule TestUnzipOneBitstringPathInCWD do
    
    use ExUnit.Case
    try do
      Path.join(fixture_path, "dome.csv") |> File.exists? |> refute
      Radpath.unzip(Path.join(fixture_path, "dome.zip"), fixture_path)
      # Path.join(fixture_path, "dome.csv") |> File.exists?
      assert File.exists? Path.join(fixture_path, "dome.csv")
    after
      File.rm_rf(Path.join(fixture_path, "dome.csv"))
    end
  end

  defmodule TestunzipOnebitstringPathIntmp do
  use ExUnit.Case
    try do
      Path.join(fixture_path, "dome.csv") |> File.exists? |> refute
      Radpath.unzip(Path.join(fixture_path, "dome.zip"), "/tmp")
    after
      # Path.join("/tmp", "dome.csv") |> File.exists?
      assert File.exists? Path.join("/tmp", "dome.csv")
  end
  defmodule TestZipPathThatDoesNotExist do
  use ExUnit.Case
    try do
        Path.join(fixture_path, "Testdir-dont-exist.zip") |>
                   File.exists? |> refute 
        Radpath.zip(["/gogo/I/don/exist"], "Testdir-dont-exist.zip")
            after
        "Testdir-dont-exist.zip" |> File.exists? |> refute
      rescue
        e in RuntimeError -> e
      end
    end
  end

  defmodule FilteringTest do
  use ExUnit.Case

    @dud_files ["testfile1.dud, file3.dud"]
    @test_files ["testdir3", "testdir2", "testdir1"]
    @file_list ["file1.txt", "file2.txt", "file3.log"]
    @file_ext ["txt", "log"]
    @long_file_list @file_list ++ ["testfile1.txt",
                                   "testfile2.txt",
                                   "testfile3.txt"]

    test "File Filtering" do
       files = Radpath.files(fixture_path, "txt") |> Enum.map(&Path.basename(&1))
       Enum.map(@dud_files, fn(x) -> refute Enum.member?(files, x) end)
       Enum.all?(@dud_files -- ["file3.log"], fn(x) -> files |> Enum.member? x end)
    end

    test "File Filtering returns empty if path does not exist" do
      assert Radpath.files("/this/path/does/not/exist") == []
    end

    test "Directory filtering" do
       dirs = Radpath.dirs(fixture_path) |> Enum.map(&Path.basename(&1))
       map(["testfile1.dud, file3.dud"], fn(x) -> refute Enum.member?(dirs, x) end)
       Enum.all?(["testdir3", "testdir2", "testdir1"], fn(x) -> Enum.member?(dirs, x) end)
    end

    test "Directory Filter: List" do
        expected = @test_files ++ ["fixtures"] |> Enum.sort
        actual = Radpath.dirs(["test", "lib"]) |> map(&basename(&1))
        assert actual == expected ++ ["Radpath"]
    end

    test "Directory Filtering: Regex" do
        actual = Radpath.dirs("test", "fixtures") |> map(&basename(&1))
	assert actual == ["fixtures"]
    end

    test "Filtering Files" do
        Radpath.files(fixture_path, "log") |> map(&basename(&1)) |> (&(assert &1 == ["file3.log"])).()
    end

    test "Filtering Files with Lists" do
       Radpath.files(["test", "lib"], @file_ext) |> map(&basename(&1)) |> Enum.sort |> (&(assert &1 == @long_file_list)).()
    end

    test "Filtering with Expanded Paths" do
       Radpath.files("test/fixtures", "log") |> map(&basename(&1)) |> (&(assert &1 == ["file3.log"])).() 
    end

    test "Filtering Multiple filter for Files" do
       files = Radpath.files(fixture_path, @file_ext) |> map(&basename(&1))
       files |> Enum.sort |> (&(assert &1 == @long_file_list)).()
       Enum.all?(@file_list, fn(x) -> Enum.member?(files, x) end)
    end

    test "Filtering long file list" do
       files = Radpath.files(fixture_path, @file_ext) |> Enum.map(&Path.basename(&1))
       files |> Enum.sort |> (&(assert &1 == @long_file_list)).()
       Enum.all?(@file_list, fn(x) -> Enum.member?(files, x) end)
    end

    test "Filtering Multiple Filter for Files" do
      files = Radpath.files(['lib'], @file_ext) |> Enum.map(&Path.basename(&1))
      Enum.all?(@file_list, fn(x) -> Enum.member?(files, x) end)
    end
  end

  defmodule Testsymlink do

   use ExUnit.Case
   import Radpath, only: [symlink: 2, islink?: 1]
   @src Path.join(fixture_path, "testdir3")
   @dest Path.join(Path.expand("."), "testdir3")

    test "Symlink Normal Usage" do
       try do
         refute File.exists? @dest
         symlink(@src, @dest)
         {result, link} = F.read_link(@dest)
         assert {result, basename(link)} == {:ok, "testdir3"}
         assert islink?(@dest)
       after
         File.rm_rf @dest
       end
    end

    test "Symlink for Non Existent" do
      src = Path.join(fixture_path, "testdir3xx")
      try do
        Path.join(Path.expand("."), "testdir3") |> File.exists? |> refute 
        symlink(src, @dest)
        assert {:error, :enoent} == F.read_link(@dest)
	# {error, enoent} = F.read_link(@dest) == {:error, :enoent}
	# assert error == :error
	# assert enoent == :enoent
        Path.join(Path.expand("."), "testdir3") |> File.exists? |> refute
      after
        File.rm_rf Path.join(Path.expand("."), "testdir3")
      end  
    end

    test "Test symlink: islink? Return true if path is symlink" do
      test_dest = Path.join(fixture_path, "test_symlink")
      try do
        test_dest |> File.exists? |> refute
        symlink(fixture_path, test_dest)
        assert islink?(test_dest)
        {result, link} = F.read_link(test_dest)
        # {result, basename(to_string(link))} |> {:ok, "fixtures"}
      after
        File.rm_rf test_dest
      end
    end

    test "Test symlink: islink? Return false if path is not symlink or if does not exist" do
      islink?(fixture_path) |> refute
      islink?("/I/wiLL/neveR/exist") |> refute
    end
   end

  defmodule TestTempfilefs do
    use ExUnit.Case
    test "Test Tempfilefs: Without Argument" do
            tmpdirpath1 = Radpath.mktempdir

        try do
          Radpath.mktempdir |> File.exists?
        after
          File.rm_rf tmpdirpath1
        end
    end

    test "Test mktempdir: With argument" do
      src = Path.join(fixture_path, "testdir3")
            tmpdirpath = Radpath.mktempdir(src)

      try do
        assert File.exists?(tmpdirpath)
      after
        File.rm_rf tmpdirpath
      end
    end

    # test "Test mktempdir: Nonexistant parent path, error returned" do
    #   tmpdirpath = Radpath.mktempdir("/gogo/gaga/gigi")
    #   try do
    #     tmpdirpath |> :enoent
    #   rescue
    #     e in RuntimeError -> e
    #   end
    # end

    test "Test mktempfile: No argument" do
      {_, fd, filepath} = Radpath.mktempfile
      IO.write fd, "hulahoop"
      try do
        assert File.exists? filepath
        read_content = File.read! filepath
        assert read_content == "hulahoop"
      after
        File.close filepath
        File.rm_rf filepath
      end
    end

    test "Test mktempfile: With arguments" do
      {_, fd, filepath} = Radpath.mktempfile(".log", "/tmp")
      IO.write fd, "hulahoop with args"
      try do
        read_content = File.read! filepath
        assert Path.extname(filepath) == ".log"
        assert read_content == "hulahoop with args"
      after
        File.close filepath
        File.rm_rf filepath
      end
    end

  end

  defmodule TestRenameandMv do
  use ExUnit.Case

    @source_file "/tmp/hoho.txt"
    @dest_file "/tmp/hehe.txt"

    test "Test rename: Normal Usage" do
        File.write(@source_file, "test rename")
      try do
        @source_file |> File.exists?
        md5sum_source = Radpath.md5sum(@source_file)
	File.cp(@source_file, "/tmp/hihi")
        Radpath.rename(@source_file, @dest_file)
        refute @source_file |> File.exists?
        @dest_file |> File.exists?
        assert Radpath.md5sum(@dest_file) == Radpath.md5sum("/tmp/hihi")
      after
        File.rm_rf @dest_file
      end
    end

    test "Test mv: Normal Usage" do
      File.write("/tmp/hoho.txt", "test mv")
      try do
        "/tmp/hoho.txt" |> File.exists?
        # md5sum_source = Radpath.md5sum(@source_file)
        # original_md5sum = Radpath.md5sum("/tmp/hoho.txt")
	File.cp("/tmp/hoho.txt", "/tmp/hihi.txt")
        Radpath.mv("/tmp/hoho.txt", "/tmp/hehe.txt")
        refute "/tmp/hoho.txt" |> File.exists?
        "/tmp/hehe.txt" |> File.exists?
        assert Radpath.md5sum("/tmp/hehe.txt") == Radpath.md5sum("/tmp/hihi.txt")
      after
        File.rm_rf @dest_file
      end
    end

    test "Test rename: Source file does not exist" do
        refute @source_file |> File.exists?
        # Radpath.rename("/tmp/hoho.txt", "/tmp/hehe.txt")
        Radpath.rename(@source_file, @dest_file)
        refute @source_file |> File.exists?
    end

    test "Test mv: Source file does not exist" do
        refute @source_file |> File.exists?
        Radpath.mv(@source_file, @dest_file)
        refute @dest_file |> File.exists?
    end

    test "Test mv: Destination folder does not exist" do
      source_file = "mix.exs"
      dest_file = "/tmp/xxxyyyzzz/mix.exs"
      assert Radpath.mv(source_file, dest_file) == {:error, :enoent}
    end

  end

  defmodule TestRelativePaths do
  use ExUnit.Case
        import Radpath, only: [relative_path: 2]

    test "Test relative_path: Normal Usage" do
      assert relative_path("/tmp/base", "/tmp/base/hoho.txt") == "hoho.txt"
    end

    test "Test relative_path: If same path is given empty string will result" do
      assert relative_path("/tmp/base/", "/tmp/base/") == ""
    end
  end

  defmodule TestEnsure do
  use ExUnit.Case

    test "Test ensure: Ensure Directory is created" do
      test_dir_path = Path.join(fixture_path, "gogo/gaga")
      refute test_dir_path |> File.exists?
      try do
        Radpath.ensure(test_dir_path)
        test_dir_path |> File.exists?
      after
            assert test_dir_path |> Radpath.parent_path |> Radpath.erusne
      end
    end

    test "Test ensure: Ensure File is created" do
      test_file_path = Path.join(fixture_path, "gogo/gaga.txt")
      refute test_file_path |> File.exists?
      try do
        Radpath.ensure(test_file_path)
        test_file_path |> File.exists?
      after
        assert test_file_path |> Radpath.parent_path |> Radpath.erusne
      end
    end
  end

  defmodule TestOtherfunctions do
  use ExUnit.Case
        import Radpath, only: [md5sum: 1, sha1sum: 1, parent_path: 1]
    test "Test md5sum: md5sum function" do
      [h | _]= String.split(to_string(:os.cmd('md5sum mix.exs')))
            assert md5sum("mix.exs") == h
    end
    test "Test sha1sumsha1sum function" do
      [h | _]= String.split(to_string(:os.cmd('sha1sum mix.exs')))
      assert sha1sum("mix.exs") ==  h
    end
    test "Test sha1sum: sha1sum on directory" do
      assert sha1sum("/tmp") == :error
    end
    test "Test md5sum: md5sum on directory" do
      assert md5sum("/tmp") == :error
    end
    test "Test md5sum: md5sum on non existent directory" do
      assert md5sum("xxx") == :error
    end
    test "Test ParentPath: Return parent path of string" do
      assert parent_path("/I/am/long/dir") == "/I/am/long/"
    end
  end
end
