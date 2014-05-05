defmodule Radpath.Dirs do
  defmacro __using__([]) do
  quote do

    # defp dirs_list(path) when is_list(path) do
    #   []
    # end

  @doc """
  
  Returns all of the directories in the given path

      iex(4)> Radpath.dirs("/home/lowks/src/elixir/radpath/lib")

      iex(3)> Radpath.dirs(["/home/lowks/src/elixir/radpath/lib", "/home/lowks/src/elixir/radpath/_build"])
      
  """

    def dirs(path) when (is_bitstring(path) or is_list(path)) do
      file_path = case String.valid? path do
        true -> [path]
        false -> path
      end
      do_dirs(file_path, [])
    end
    defp do_dirs([], result) do
      result
    end
    defp do_dirs(paths ,result) do
      [h | t] = paths
      do_dirs(t, result ++ dirs_list(h))
    end
  
    defp dirs_list(path) when is_bitstring(path) do
      Finder.new() |> Finder.only_directories() |> Finder.find(Path.expand(path)) |> Enum.to_list
    end
  end
  end
end