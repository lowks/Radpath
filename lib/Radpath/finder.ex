defmodule Radpath.Finder do
  defstruct only_files: false, only_directories: false, file_endings: [], directory_regex: nil

  def new(), do: %Radpath.Finder{}

  def only_files(finder), do: %{finder | only_files: true}
  def only_directories(finder), do: %{finder | only_directories: true}
  def with_file_endings(finder, endings), do: %{finder | file_endings: endings}
  def with_directory_regex(finder, regex), do: %{finder | directory_regex: regex}

  def find(finder, path) do
    # Finder.find usually returns an Enumerable.
    # We will use Stream to be safe if there are many files.

    normalized_endings = Enum.map(finder.file_endings, &String.trim_leading(&1, "."))

    # We'll use File.ls and recursion to mimic a deep find.
    find_recursive(path)
    |> Stream.filter(fn p ->
      cond do
        finder.only_files and not File.regular?(p) -> false
        finder.only_directories and not File.dir?(p) -> false
        finder.file_endings != [] and not (String.trim_leading(Path.extname(p), ".") in normalized_endings) -> false
        finder.directory_regex and not (Path.basename(p) =~ finder.directory_regex) -> false
        true -> true
      end
    end)
  end

  defp find_recursive(path) do
    case File.ls(path) do
      {:ok, files} ->
        files
        |> Stream.flat_map(fn file ->
          full_path = Path.join(path, file)
          [full_path | find_recursive(full_path)]
        end)
      _ ->
        []
    end
  end
end
