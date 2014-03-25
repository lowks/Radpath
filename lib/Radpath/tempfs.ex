defmodule Radpath.Tempfs do
   defmacro __using__([]) do
     quote do

     @doc """
       
     To create a temp file without arguments:

         Radpath.mktempfile

     """
     def mktempfile() do
       Tempfile.open
     end

     @doc """
     To create a temp file with arguments. Default value for extension is '.tmp':

         Radpath.mktempfile(".log", "/home/lowks/Downloads") |> File.write("abcdef")

     """

     def mktempfile(ext, path) when is_bitstring(path) and is_bitstring(ext) do
        Tempfile.get_name("", [ext: ext, path: path])
     end

    @doc """
    To create a temp file at a certain location:

        Radpath.mktempfile("/home/lowks/Downloads") |> File.write("abcdef")

    """
    def mktempfile(path) when is_bitstring(path) do
      Tempfile.get_name("", [ext: ".tmp", path: path])
    end

    @doc """
    To create a temp dir without arguments:

        Radpath.mktempdir

    """
    def mktempdir do
      Tempfile.get_name |> Path.rootname |> do_mkdir
    end

    @doc """
    To create a temp dir with arguments:

        Radpath.mktempdir("/home/lowks/Downloads")

    """
    def mktempdir(path) when is_bitstring(path) do
      Tempfile.get_name([path: make_into_path(path)]) |> Path.rootname |> do_mkdir
    end

  end   
  end
end