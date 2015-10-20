defmodule Radpath.Files do
   defmacro __using__([]) do
     quote do

     @moduledoc """
        Radpath handling files/directories manipulation. 
      """

       @doc """
  Returns all of the files in the given path, and if ext is
  given will filter by that extname.

  ## Arguments

  - `path` Path of file to filter in bitstring
  - `ext` Extensions to show in filter in bitstring

  ### Usage
  
  Listing all of the contents of the folder /home/lowks/Documents

     Radpath.files("/home/lowks/Documents")

  Appling a filter 'doc' on that search:

      Radpath.files("/home/lowks/Documents", "doc")

  Appling a list filter of 'doc' and 'pdf' on that search:

      Radpath.files("/home/lowks/Documents", ["doc", "pdf"])

  Listing for list of directories is also supported:

      Radpath.files(["/home/lowks/Documents", "/tmp"], ["doc"])
  or 
      Radpath.files(["/home/lowks/Documents", "/tmp"])
  or
      Radpath.files(['/home/lowks/Documents', '/tmp'], ['doc', 'pdf'])

  Paths that do not exists returns an empty list:

      iex(2)> Radpath.files("/heck/i/do/not/exist")
      []

  """

    @spec files(bitstring, bitstring) :: list
    def files(path, ext) when is_bitstring(path) and is_bitstring(ext) do
      file_ext = case String.valid? ext do
        true -> [ext]
        false -> ext
      end
      expanded_path = Path.expand(path)
      case File.exists? expanded_path do
        true -> Finder.new() |>
                Finder.only_files() |>
                Finder.with_file_endings(file_ext) |>
                Finder.find(expanded_path) |>
                Enum.to_list
        false -> []
      end
    end

    @doc """
Radpath.files(path) will list down all files in the path without filtering

## Arguments

- `path` location to list down all files in bitstring

## Usage

Listing down all files in the "ci" folder without filtering: 

     Radpath.files("ci")
     ["/Users/lowks/Projects/src/elixir/Radpath/ci/script/circleci/prepare.sh"]

"""

    def files(path) when is_bitstring(path) do
      expanded_path = Path.expand(path)
      case File.exists? expanded_path do
        true -> Finder.new() |>
                Finder.only_files() |>
                Finder.find(expanded_path) |>
                Enum.to_list
        false -> []
      end
    end

    def files(path, file_ext) when is_bitstring(path) and is_list(file_ext) do
      file_ext = normalize_path(file_ext)
      path
      |> normalize_path
      |> do_ext_files([], file_ext)
    end

    def files(path) when is_list(path) do
      path
      |> normalize_path
      |> do_files([])
    end

    def files([path], file_ext) when is_list(path) and is_list(file_ext) do
      file_ext = normalize_path(file_ext)
      path
      |> normalize_path
      |> do_ext_files([], file_ext)
    end

    def files(path, file_ext) when is_list(path) and is_list(file_ext) do
      file_ext = normalize_path(file_ext)
      path
      |> normalize_path
      |> do_ext_files([], file_ext)
    end

    defp do_files([], result) do
      result
    end

    defp do_files(paths, result) do
      [h | t] = paths
      do_files(t, result ++ files_list(h))
    end

    defp do_ext_files([], result, file_ext) do
      result
    end

    defp do_ext_files(paths, result, file_ext) do
      [h | t] = paths
      do_ext_files(t, result ++ ext_file_list(h, file_ext), file_ext)
    end

    defp ext_file_list(path, file_ext) do
      expanded_path = Path.expand(path)
      case File.exists? expanded_path do
        true -> Finder.new() |>
                Finder.only_files() |>
                Finder.with_file_endings(file_ext) |>
                Finder.find(expanded_path) |>
                Enum.to_list
        false -> []
      end
    end

    defp files_list(path) when is_bitstring(path) do
      expanded_path = Path.expand(path)
      case File.exists? expanded_path do
        true -> Finder.new() |>
                Finder.only_files() |>
                Finder.find(expanded_path) |>
                Enum.to_list
        false -> []
      end
    end

  end
 end
end
