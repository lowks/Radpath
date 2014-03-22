defmodule Radpath.Files do
   defmacro __using__([]) do
     quote do

       @doc """
  Returns all of the files in the given path, and if ext is
  given will filter by that extname.

  ### Examples
  
  Listing all of the contents of the folder /home/lowks/Documents

    Radpath.files("/home/lowks/Documents")
    [a-lot-of-output]

  If you wanted to apply a filter on that search:

    Radpath.files("/home/lowks/Documents", "doc")
    ["/home/lowks/Documents/MyResume.doc"]

  If you wanted to apply a list filter on that search:

    Radpath.files("/home/lowks/Documents", ["doc", "pdf"])
    ["/home/lowks/Documents/MyResume.doc", "/home/lowks/Documents/MyResume.pdf"]

  """
  
  def files(path, ext) when is_bitstring(ext) do
    Finder.new() |> Finder.with_file_endings([ext]) |> Finder.find(Path.expand(path)) |> Enum.to_list
  end

  def files(path, ext) when is_list(ext) do
    Finder.new() |> Finder.with_file_endings(ext) |> Finder.find(Path.expand(path)) |> Enum.to_list
  end

  def files(path) do
    Finder.new() |> Finder.only_files() |> Finder.find(Path.expand(path)) |> Enum.to_list
  end
end
end
end