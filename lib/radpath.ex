defmodule Radpath do
  alias :file, as: F
  alias :zip, as: Z
  use Application
  use Radpath.Dirs
  use Radpath.Files
  use Radpath.Tempfs

  def start(_type, _args) do
    Radpath.Supervisor.start_link
  end

  defmacro __using__([]) do
    quote do
      use Radpath.Dirs
      use Radpath.Files
      use Radpath.Tempfs
    end
  end

  @moduledoc """
  Elixir library for path operations inspired by pathlib from Python.
  """

  @doc """
  To create symlink:

  ## Arguments
  
  - `source` of file or directory in bitstring
  - `destination` of file or directory in bitstring

  ## Usage

      Radpath.symlink(source, destination). Source must exist.

  """
  def symlink(source, destination) do
    if File.exists?(source) do
      F.make_symlink(source, destination)
    end
  end
  
  @doc """
  
  To create a zip archive:

  ## Arguments

  - `list of directories`: List containing all the directories to be zipped
  - `archive_name`: String which is the name of the archive to be created

  # Usage

      Radpath.zip([dir1, file1, dir2], archive_name)

  """
  def zip(dirs, archive_name) when is_list(dirs) do
    dirs_list = dirs |> Enum.filter(fn(x) -> File.exists?(x) end) |> Enum.map&(String.to_char_list(&1))
    if !Enum.empty? dirs_list do
      Z.create(String.to_char_list(archive_name), dirs_list)
    end
  end

  @doc """
  
  To create a zip archive:

  ## Arguments

  - `dir`: List containing all the directories to be zipped
  - `archive_name`: String which is the name of the archive to be created

  # Usage

      Radpath.zip(dir1, archive_name)

  """
  def zip(dir, archive_name) when is_bitstring(dir) do
    if File.exists?(dir) do
      Z.create(String.to_char_list(archive_name), [String.to_char_list(dir)])
    end
  end

  @doc """
 
  zip_file is the zip archive. Will only unzip if zip_file exists

  ## Arguments

  - `zip_file` string value of file that is to be uncompressed.  
  - `unzip_dir` string value of output directory of where to unzip. 

  ## Usage
  
  To create a zip archive:

      Radpath.unzip(zip_file, unzip_dir)


  """

  def unzip(zip_file, unzip_dir \\ File.cwd!) when is_bitstring(zip_file) do
    if File.exists?(zip_file) do
      {:ok,ziphandler} = Z.openzip_open String.to_char_list(zip_file), [cwd: unzip_dir]
      Z.openzip_get(ziphandler)
      Z.openzip_close(ziphandler)
    end
  end

  @doc """
  
  To mv a file / directory:

  ## Arguments

  - `source` file or directory in bitstring
  - `destination` file or directory in bitstring

  ## Usage

      Radpath.rename(source, destination)

  """
  def mv(source, destination) when is_bitstring(source), do: rename(source, destination)

  @doc """
  
  To rename a file / directory:

  ## Arguments

  * `source` - Original name of directory / file
  * `destination` - New name of directory / file

  ## Usage

      Radpath.rename(source, destination)

  """

  def rename(source, destination) when is_bitstring(source) do
    F.rename(source, destination)
  end

  @doc """
  Gives you back the relative path:

  ## Arguments

  - `file` Bitstring 
  - `base` Bitstring 

  ## Usage   

      iex(1)> Radpath.relative_path("/tmp/lowks/", "/tmp/lowks/iam.txt")
      "iam.txt"
      iex(2)> Radpath.relative_path("/tmp/lowks/", "/tmp/lowks/hoho/iam.txt")
      "hoho/iam.txt"
  """

  def relative_path(base, file) do
    split = Path.split(base)
    case split == Path.split(file) || length(split) > length(Path.split(file)) do
      true -> ""
      false -> Path.join(:lists.nthtail(length(split), Path.split(file)))
    end
  end

  @doc """

  To get parent_path of a given path. The path supplied should be a bit string:

  ## Arguments

   - `path` - The path which you want parent_path returned.

  ## Usage

       Radpath.parent_path(path).

  """
  def parent_path(path) when is_bitstring(path) do
    Path.absname(path)
    |> String.split(Path.basename(path))
    |> List.first
  end

  @doc """
  Ensures that a directory/file is created. If is_file is set to true then file is created.

  ## Arguments

  - `path` - Path that is to be created

  - `is_file` - Boolean, indicating if path is a file, if true then ensure will create file. Default false (directory).
  
  ## Usage

      iex(1)> Radpath.ensure(path)
        :ok
  
      iex(2)> Radpath.ensure(path, true)
        :ok

  """

  def ensure(path, is_file \\ false) when is_bitstring(path) do
    if !File.exists?(path) do
      cond do
        is_file == false -> File.mkdir_p(path)
        is_file -> File.touch(path)
      end
    end
  end

  @doc """
  Returns true if path is a symbolic link and false if otherwise:

  ## Arguments

  - `path` Path to be checked in bitstring

  ## Usage


       iex(1)> Radpath.islink?("test3")
       true
       iex(2)> Radpath.islink?("/home")
       false
  """

  def islink?(path) when is_bitstring(path) do
    case F.read_link(path) do
      {:ok, _} -> true
      {:error, _} -> false
    end
  end

  @doc """
  Returns the md5sum of a file. Only works for files. Folders passed will return :error:

  ## Arguments

  - `path` Path to file to generate md5sum in bitstring

  ## Usage

      iex(2)> Radpath.md5sum("mix.exs")
      "e7794b67112458774fe9f23d1b9c4913"
      iex(3)> Radpath.md5sum("test")   
      :error
  """

  def md5sum(path) when is_bitstring(path) do
    case File.exists?(path) do
      true ->
        case File.dir?(path) do
          true -> :error
          false -> File.read!(path)
                   |> :ec_file.md5sum
                   |> to_string
        end
      false -> :error
    end
  end

  @doc """
  Returns the sha1sum of a file. Only works for files. Folders passed will return :error:

  ## Arguments

  - `path` Path to file to generate sha1sum in bitstring


  ## Usage

      iex(1)> Radpath.sha1sum("mix.exs")
      "48edfd81ee32efc0f9aea7dbebd0798fb2adf226"
      iex(2)> Radpath.sha1sum("test")   
      :error
  """

  def sha1sum(path) when is_bitstring(path) do
    case File.exists?(path) do
      true ->
        case File.dir?(path) do
          true -> :error
          false -> File.read!(path)
                   |> :ec_file.sha1sum
                   |> to_string
        end
      false -> :error
    end
  end
      
  defp do_mkdir(path) do
    if !File.exists?(path) do
      case File.mkdir(path) do
        :ok -> path
        error -> error
      end
    end
  end

  defp make_into_path(path_str) do
    Path.absname(path_str) <> "/"
  end

end