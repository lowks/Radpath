defmodule Radpath do
  alias :file, as: F
  @doc """
  Returns all of the directories in the given path
  """
  def dirs(path) do
    full_path(path) |> Enum.filter(fn(x) -> File.exists?(x) && File.dir?(x) end)      
  end

  @doc """
  Returns all of the files in the given path, and if ext is given will filter by that extname.
  """
  def files(path, ext \\ "None") do
    raw_files = full_path(path) |> Enum.filter(fn(x) -> File.exists?(x) && File.regular?(x) end)
    if ext != "None" do
      raw_files |> Enum.filter(fn(x) -> Path.extname(x) == "." <> ext end)
    else
      raw_files
    end
  end

  def symlink(source, destination) do
     if File.exists?(source) do
       F.make_symlink(source, destination)
     end
  end

  defp full_path(path) do
    File.ls!(path) |> Enum.map(&Path.expand(&1, path))
  end
end
