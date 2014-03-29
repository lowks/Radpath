defmodule Radpath.Files do
   defmacro __using__([]) do
     quote do

       @doc """
  Returns all of the files in the given path, and if ext is
  given will filter by that extname.

  ### Examples
  
  Listing all of the contents of the folder /home/lowks/Documents

     Radpath.files("/home/lowks/Documents")

  If you wanted to apply a filter on that search:

      Radpath.files("/home/lowks/Documents", "doc")

  If you wanted to apply a list filter on that search:

      Radpath.files("/home/lowks/Documents", ["doc", "pdf"])

  """

    def files(path, ext) when (is_bitstring(ext) or is_list(ext)) do
      case String.valid? ext do
        true -> file_ext = [ext]
        false -> file_ext = ext
      end
      Finder.new() |> Finder.only_files() |> Finder.with_file_endings(file_ext) |> Finder.find(Path.expand(path)) |> Enum.to_list
    end

    def files(path) do
      Finder.new() |> Finder.only_files() |> Finder.find(Path.expand(path)) |> Enum.to_list
    end

  end
 end
end