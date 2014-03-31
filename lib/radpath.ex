defmodule Radpath do
  alias :file, as: F
  alias :zip, as: Z
  use Application.Behaviour
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

      Radpath.symlink(source, destination). Source must exist.

  """
  def symlink(source, destination) do
    if File.exists?(source) do
      F.make_symlink(source, destination)
    end
  end
  
  @doc """
  
  To create a zip archive:

      Radpath.zip([dir1, file1, dir2], archive_name)

  """
  def zip(dirs, archive_name) when is_list(dirs) do
    dirs_list = dirs |> Enum.map&(String.to_char_list!(&1))
    Z.create(String.to_char_list!(archive_name), dirs_list)
  end

  @doc """
  
  To rename a file / directory:

      Radpath.rename(source, destination)

  """
  def mv(source, destination) when is_bitstring(source) and is_bitstring(source), do: rename(source, destination)
  def rename(source, destination) when is_bitstring(source) and is_bitstring(source) do
    F.rename(source, destination)
  end

  @doc ~S"""
  Gives you back the relative path:

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