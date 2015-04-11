Code.require_file "../test_helper.exs", __ENV__.file

defmodule RadpathTests.RadpathFacts do

  use Amrita.Sweet       

  import PathHelpers

  alias :file, as: F

  facts "Test zipping" do

    defchecker path_exists(path) do
        File.exists?(path) |> truthy
    end

    fact "Test zip: List of directories" do
      try do
        Path.join(fixture_path, "Testdir1.zip") |> ! path_exists()
        Radpath.zip([fixture_path], "Testdir1.zip")
        "Testdir1.zip" |> path_exists()
        System.cmd("zip",["-T","Testdir1.zip"]) |> {"test of Testdir1.zip OK\n", 0}
        {result_str, code} = System.cmd("zipinfo",["-1","Testdir1.zip"])
        result_str |> contains "testdir1"
      after
        File.rm_rf("Testdir1.zip")
      end
    end

    fact "Test zip: One path" do

      dir = Path.join(fixture_path, "testdir2")

      try do
        Path.join(fixture_path, "Testdir2.zip") |> ! path_exists()
        Radpath.zip([dir], "Testdir2.zip")
        "Testdir2.zip" |> path_exists()
        {result_str, code} = System.cmd("zip",["-T","Testdir2.zip"]) 
        result_str |> String.strip |> "test of Testdir2.zip OK"
        {result_str2, code2} = System.cmd("zipinfo",["-1","Testdir2.zip"]) 
        result_str2 |> contains "testdir2"
      after
        File.rm_rf("Testdir2.zip")
      end
    end

  fact "Test zip: One bitstring path" do
    dir = Path.join(fixture_path, "testdir1")
    try do
      Path.join(fixture_path, "Testdir3.zip") |> ! path_exists()
      Radpath.zip(dir, "Testdir3.zip")
      "Testdir3.zip" |> path_exists()
      System.cmd("zip",["-T","Testdir3.zip"]) |> {"test of Testdir3.zip OK\n", 0}
      {result_str, code} = System.cmd("zipinfo",["-1","Testdir3.zip"]) 
      result_str |> contains "testdir1"
    after
      File.rm_rf("Testdir3.zip")
    end
  end

  fact "Test unzip: One bitstring path in cwd" do
    try do
      Path.join(fixture_path, "dome.csv") |> ! path_exists()
      Radpath.unzip(Path.join(fixture_path, "dome.zip"), fixture_path)
      Path.join(fixture_path, "dome.csv") |> path_exists()
    after
      File.rm_rf(Path.join(fixture_path, "dome.csv"))
    end
  end

  fact "Test unzip: One bitstring path in tmp" do
    try do
      Path.join(fixture_path, "dome.csv") |> ! path_exists()
      Radpath.unzip(Path.join(fixture_path, "dome.zip"), "/tmp")
      Path.join("/tmp", "dome.csv") |> path_exists()
    after
      File.rm_rf("/tmp/dome.csv")
    end
  end
  
  fact "Test unzip: Non existent zip file will result in nil" do
    Radpath.unzip("gogo/gaga/none.zip") |> nil
  end
  
  fact "Test zip: Path that does not exist" do
      dir = "/gogo/I/don/exist/"
      try do
        Path.join(fixture_path, "Testdir-dont-exist.zip") |> ! path_exists()
        Radpath.zip([dir], "Testdir-dont-exist.zip")
        "Testdir-dont-exist.zip" |> ! path_exists()
      rescue
        e in RuntimeError -> e
      end
    end                         
  end

  facts "Test Filtering" do

		@dud_files ["testfile1.dud, file3.dud"]
		@test_files ["testdir3", "testdir2", "testdir1"]
		@file_list ["file1.txt", "file2.txt", "file3.log"]
		@file_ext ["txt", "log"]

    fact "Test Filtering: Files" do
      files = Radpath.files(fixture_path, "txt") |> Enum.map(&Path.basename(&1))
      Enum.map(files, fn(x) -> String.ends_with? x, ".dud" end) |> 
				[false, false, false, false, false] 
      Enum.each(@file_list -- ["file3.log"], fn(x) -> files |> contains x end)
    end

    fact "Test Filtering: Files returns empty list if path does not exist" do
      Radpath.files("/this/path/does/not/exist") |> []
    end
  
    fact "Test Filtering: Directories" do
      dirs = Radpath.dirs(fixture_path) |> Enum.map(&Path.basename(&1))
			Enum.map(dirs, fn(x) -> String.ends_with? x, ".dud" end) |> 
				[false, false, false, false] 
			Enum.each(@dud_files, fn(x) -> dirs |> ! contains x end)
      Enum.each(@test_files, fn(x) -> dirs |> contains x end)
    end

    fact "Test Filtering: List of Directories" do
      dirs = Radpath.dirs(["test", "lib"]) |> Enum.map(&Path.basename(&1))
      Enum.each(@test_files ++ ["Radpath"], fn(x) -> dirs |> contains x end)
    end

    fact "Test Filtering: Regex Directories" do
      dirs = Radpath.dirs("test", "fixtures") |> Enum.map(&Path.basename(&1))
      Enum.each(["fixtures"], fn(x) -> dirs |> contains x end)
    end
    
    fact "Test Filtering: files" do
			files = Radpath.files(fixture_path, "log") 
			length(files) |> 1
      files |> Enum.map(&Path.basename(&1)) |> ["file3.log"]
    end

    fact "Test Filtering: files with lists" do
      Radpath.files(["test", "lib"], @file_ext) 
      |> Enum.map(&Path.basename(&1)) 
      |> Enum.sort 
      |> ["file1.txt", "file2.txt", "file3.log", 
					"testfile1.txt", "testfile2.txt", 
					"testfile3.txt"]
    end

    fact "Test Filtering: files. Expanded path works too." do
      Radpath.files("test/fixtures", "log") |> Enum.map(&Path.basename(&1)) |> ["file3.log"]
    end

    fact "Test Filtering: Multiple filter for files function" do
      files = Radpath.files(fixture_path, @file_ext) |> Enum.map(&Path.basename(&1))
			length(files) |> 6
      @file_list |> for_all (&Enum.member?(files, &1))
    end

    fact "Test Filtering: Multiple filter for files function if extension is list of char list" do
      files = Radpath.files(fixture_path, @file_ext) |> Enum.map(&Path.basename(&1))
			length(files) |> 6
      @file_list |> for_all (&Enum.member?(files, &1))
    end

    fact "Test Filtering: Multiple filter for files function if extension and paths is list of char list" do
      files = Radpath.files(['lib'], @file_ext) |> Enum.map(&Path.basename(&1))
      @file_list |> for_all (&Enum.member?(files, &1))
    end
  end

  facts "Test symlink" do

    fact "Test symlink: Normal Usage" do
      src = Path.join(fixture_path, "testdir3")
      dest = Path.join(Path.expand("."), "testdir3")
    
      try do
        dest |> ! path_exists()
        Radpath.symlink(src, dest)
        elem(F.read_link(dest), 0) |> :ok
        Radpath.islink?(dest) |> truthy
        dest |> path_exists()
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
        F.read_link(dest) |> {:error, :enoent}
        dest |> ! path_exists
      after
        File.rm_rf dest
      end
    end

    fact "Test symlink: islink? Return true if path is symlink" do

      test_dest = Path.join(fixture_path, "test_symlink")

      try do
        test_dest |> ! path_exists
        Radpath.symlink(fixture_path, test_dest)
        Radpath.islink?(test_dest) |> truthy
      after
        File.rm_rf test_dest
      end
    end

    fact "Test symlink: islink? Return false if path is not symlink" do
      Radpath.islink?(fixture_path) |> falsey
    end

    fact "Test symlink: islink? Return false if path does not exist" do
      Radpath.islink?("/I/wiLL/neveR/exist") |> falsey
    end

  end
  
  facts "Test Tempfilefs" do

    fact "Test Tempfilefs: Without Argument" do
        tmpdirpath1 = Radpath.mktempdir
        try do
          Radpath.mktempdir |> File.exists?
        after
          File.rm_rf tmpdirpath1
        end
    end
 
    fact "Test mktempdir: With argument" do
      src = Path.join(fixture_path, "testdir3")
      tmpdirpath = Radpath.mktempdir(src)

      try do
        File.exists?(tmpdirpath) |> truthy
      after
        File.rm_rf tmpdirpath
      end
    end

    fact "Test mktempdir: Nonexistant parent path, error returned" do
      tmpdirpath = Radpath.mktempdir("/gogo/gaga/gigi")
      try do
        tmpdirpath |> {:error, :enoent}
      rescue
        e in RuntimeError -> e
      end
    end
  end

  facts "Test rename and mv" do

    fact "Test rename: Normal Usage" do
      source_file = "/tmp/hoho.txt"
      dest_file = "/tmp/hehe.txt"
      File.touch!(source_file)
      try do
        source_file |> path_exists()
        Radpath.rename(source_file, dest_file)
        source_file |> ! path_exists()
        dest_file |> path_exists()
      after
        File.rm_rf dest_file
      end
    end

    fact "Test mv: Normal Usage" do
      source_file = "/tmp/hoho.txt"
      dest_file = "/tmp/hehe.txt"
      File.touch!(source_file)
      try do
        source_file |> path_exists()
        Radpath.mv(source_file, dest_file)
        source_file |> ! path_exists()
        dest_file |> path_exists()
      after
        File.rm_rf dest_file
      end
    end

    fact "Test rename: Source file does not exist" do
      source_file = "/tmp/hoho.txt"
      dest_file = "/tmp/hehe.txt"
      try do
      	source_file |> ! path_exists()
      	Radpath.rename(source_file, dest_file)
      	dest_file |> ! path_exists()
      after
      	File.rm_rf source_file
      	File.rm_rf dest_file
      end
    end

    fact "Test mv: Source file does not exist" do
      source_file = "/tmp/hoho.txt"
      dest_file = "/tmp/hehe.txt"
      try do
      	source_file |> ! path_exists()
      	Radpath.mv(source_file, dest_file)
      	dest_file |> ! path_exists()
      after
      	File.rm_rf source_file
      	File.rm_rf dest_file
      end
    end

    fact "Test mv: Destination folder does not exist" do
      source_file = "mix.exs"
      dest_file = "/tmp/xxxyyyzzz/mix.exs"
      Radpath.mv(source_file, dest_file) |> {:error, :enoent}
    end

  end

  facts "Test relative paths" do
    fact "Test relative_path: Normal Usage" do
      Radpath.relative_path("/tmp/base", "/tmp/base/hoho.txt") |> "hoho.txt"
    end

    fact "Test relative_path: If same path is given empty string will result" do
      Radpath.relative_path("/tmp/base/", "/tmp/base/") |> ""
    end
  end

  facts "Test ensure" do
    
    fact "Test ensure: Ensure Directory is created" do
      test_dir_path = Path.join(fixture_path, "gogo/gaga")
      test_dir_path |> ! path_exists()
      try do
        Radpath.ensure(test_dir_path)
        test_dir_path |> path_exists()
      after
        File.rm_rf(test_dir_path)
      end
    end

    fact "Test ensure: Ensure File is created" do
      test_file_path = Path.join(fixture_path, "gogo/gaga.txt")
      test_file_path |> ! path_exists()
      try do
        Radpath.ensure(test_file_path)
        test_file_path |> path_exists()
      after
        File.rm_rf(test_file_path)
      end
    end
  end

  facts "Test Other functions:" do
    fact "Test md5sum: md5sum function" do
      [h | _]= String.split(to_string(:os.cmd('md5sum mix.exs')))
      assert h == Radpath.md5sum("mix.exs")
    end
    fact "Test sha1sum: sha1sum function" do
      [h | _]= String.split(to_string(:os.cmd('sha1sum mix.exs')))
      assert h == Radpath.sha1sum("mix.exs")
    end
    fact "Test sha1sum: sha1sum on directory" do
      Radpath.sha1sum("/tmp") |> :error
    end
    fact "Test md5sum: md5sum on directory" do
      Radpath.md5sum("/tmp") |> :error
    end
    fact "Test md5sum: md5sum on non existent directory" do
      Radpath.md5sum("xxx") |> :error
    end
    fact "Test ParentPath: Return parent path of string" do
      Radpath.parent_path("/I/am/long/dir") |> "/I/am/long/"
    end
  end
end
