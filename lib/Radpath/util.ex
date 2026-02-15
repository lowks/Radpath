defmodule Radpath.Util do
  def make_into_path(path_str) do
    Path.absname(path_str) <> "/"
  end

  # list of bitstrings
  def normalize_path([path | rest]) when is_bitstring(path) do
    [path | normalize_path(rest)]
  end

  # list of character lists
  def normalize_path([path | rest]) when is_list(path) do
    [to_string(path) | normalize_path(rest)]
  end

  def normalize_path([]) do
    []
  end

  # bitstring
  def normalize_path(path) when is_bitstring(path) do
    [path]
  end

  # character list
  def normalize_path(path) when is_list(path) do
    [to_string(path)]
  end
end
