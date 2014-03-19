defmodule Radpath do
  alias :file, as: F
  import Tempfile

  @doc """
  Returns all of the directories in the :qgiven path
  """
  def dirs(path) do
    full_path(path) |> Enum.filter(&File.dir?(&1))      
  end

  @doc """
  Returns all of the files in the given path, and if ext is
  given will filter by that extname.
  """
  def files(path, ext \\ "None") do
    raw_files = full_path(path) |> Enum.filter(&File.regular?(&1))
    if ext != "None" do
      raw_files |> Enum.filter&(Path.extname(&1) == "." <> ext)
    else
      raw_files
    end
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
  To create a temp file with arguments: Radpath.mktempfile(".log", "/home/lowks/Downloads")
  """
  def mktempfile(ext \\ ".log", path) do
    tmp_path = Tempfile.get_name("", [ext: ext, path: path])
    if File.dir?(path) do
      case File.open(tmp_path, [:write]) do
        {:ok, filepath} ->
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
    if !String.ends_with?(path_str, "/") do
      path_str <> "/"
    else
      path_str
    end
  end
  
  defp full_path(path) do
    File.ls!(path) |> Enum.map(&Path.expand(&1, path))
  end
end