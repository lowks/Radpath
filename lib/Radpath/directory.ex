defmodule Radpath.Dirs do
  defmacro __using__([]) do
  quote do

    # defp dirs_list(path) when is_list(path) do
    #   []
    # end

  @moduledoc """
    Directory functions of Radpath library
  """

  @doc """
  Returns all of the directories in the given path

  ## Arguments

  - `path` path to show list of directories in bitstring.
  - `regex_dir` String regex of directory pattern to show in final output.
  
  ## Usage

      iex(4)> Radpath.dirs("/home/lowks/src/elixir/radpath/lib", regex_dir)

      iex(3)> Radpath.dirs(["/home/lowks/src/elixir/radpath/lib", "/home/lowks/src/elixir/radpath/_build"], regex_dir)
      
  """
    @spec dirs(bitstring, bitstring) :: list
    def dirs(path, regex_dir \\ ".+") when (is_bitstring(path) or is_list(path)) do
      path
       |> normalize_path
       |> do_dirs([], regex_dir)
    end
    defp do_dirs([], result, regex_dir) do
      result
    end
    defp do_dirs(paths ,result, regex_dir) do
      [h | t] = paths
      do_dirs(t, result ++ dirs_list(h, regex_dir), regex_dir)
    end

    defp dirs_list(path, regex_dir) when is_bitstring(path) do
        Finder.new()
        |> Finder.with_directory_regex(Regex.compile!(regex_dir))
        |> Finder.only_directories()
        |> Finder.find(Path.expand(path))
        |> Enum.to_list
        |> Enum.sort
    end
   end
  end
end
