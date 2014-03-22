defmodule Radpath do
  alias :file, as: F
  alias :zip, as: Z

  @doc """
  Returns all of the directories in the :qgiven path
  """
  def dirs(path) when is_bitstring(path) do
    Finder.new() |> Finder.only_directories() |> Finder.find(Path.expand(path)) |> Enum.to_list
  end

  def dirs(path) when is_list(path) do
    do_dirs(path, [])
  end

  defp do_dirs([], result) do
    result
  end

  defp do_dirs(paths ,result) do
    [h | t] = paths
    result_dirs = dirs(h)
    do_dirs(t, result ++ result_dirs)
  end

  @doc """
  Returns all of the files in the given path, and if ext is
  given will filter by that extname.

  ### Examples
  
  Listing all of the contents of the folder /home/lowks/Documents

    Radpath.files("/home/lowks/Documents")
    [a-lot-of-output]

  If you wanted to apply a filter on that search:

    Radpath.files("/home/lowks/Documents", "doc")
    ["/home/lowks/Documents/MyResume.doc"]

  If you wanted to apply a list filter on that search:

    Radpath.files("/home/lowks/Documents", ["doc", "pdf"])
    ["/home/lowks/Documents/MyResume.doc", "/home/lowks/Documents/MyResume.pdf"]

  """
  
  def files(path, ext) when is_bitstring(ext) do
    Finder.new() |> Finder.with_file_endings([ext]) |> Finder.find(Path.expand(path)) |> Enum.to_list
  end

  def files(path, ext) when is_list(ext) do
    Finder.new() |> Finder.with_file_endings(ext) |> Finder.find(Path.expand(path)) |> Enum.to_list
  end

  def files(path) do
    Finder.new() |> Finder.only_files() |> Finder.find(Path.expand(path)) |> Enum.to_list
  end

  @doc """
  To create symlink: Radpath.symlink(source, destination). Source must exist.
  """
  def symlink(source, destination) do
     if File.exists?(source) do
       F.make_symlink(source, destination)
     end
  end

  @doc """
  To create a temp file without arguments: Radpath.mktempfile
  """
  def mktempfile() do
    Tempfile.open
  end

  @doc """
  To create a temp file with arguments: Radpath.mktempfile(".log", "/home/lowks/Downloads").
  Default value for ext is '.tmp'
  """
  def mktempfile(ext, path) do
    tmp_path = Tempfile.get_name("", [ext: ext, path: path])
    if File.dir?(path) do
      case File.open(tmp_path, [:write]) do
        {:ok, tmp_path} ->
          {:ok, tmp_path }
        error ->
          error
      end
    end
  end

  def mktempfile(path) do
    tmp_path = Tempfile.get_name("", [ext: ".tmp", path: path])
    if File.dir?(path) do
      case File.open(tmp_path, [:write]) do
        {:ok, tmp_path} ->
          {:ok, tmp_path }
        error ->
          error
      end
    end
  end

  @doc """
  To create a temp dir without arguments: Radpath.mktempdir
  """
  def mktempdir do
    tmp_path = Tempfile.get_name |> Path.rootname
    do_mkdir(tmp_path)
  end

  @doc """
  To create a temp dir with arguments: Radpath.mktempdir("/home/lowks/Downloads")
  """
  def mktempdir(path) when is_bitstring(path) do
    tmp_path = Tempfile.get_name([path: make_into_path(path)]) |> Path.rootname
    do_mkdir(tmp_path)
  end

  @doc """
  
  To create a zip archive: Radpath.zip(archive_name, [dir1, file1, dir2])

  """
  def zip(archive_name, dirs) when is_list(dirs) do
    Z.zip(archive_name, dirs)
  end

  defp do_mkdir(path) do
    if !File.exists?(path) do
      File.rm_rf(path)
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