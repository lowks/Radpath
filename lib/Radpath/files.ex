defmodule Radpath.Files do
   defmacro __using__([]) do
     quote do

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

  Paths that do not exists returns an empty list:

      iex(2)> Radpath.files("/heck/i/do/not/exist")
      []

  """

    def files(path, ext) when (is_bitstring(ext) or is_list(ext)) do
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

    def files(path) do
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
