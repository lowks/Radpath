defmodule Radpath do
  alias :file, as: F
  @doc """
  Returns all of the directories in the given path
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
      raw_files |> Enum.filter(fn(x) -> Path.extname(x) == "." <> ext end)
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

  defp full_path(path) do
    File.ls!(path) |> Enum.map(&Path.expand(&1, path))
  end
end
