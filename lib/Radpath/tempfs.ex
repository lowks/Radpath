defmodule Radpath.Tempfs do
   defmacro __using__([]) do
     quote do

     @doc """
     To create a temp file and write to it without arguments:

         Radpath.mktempfile |> File.write("test123")

     """
     def mktempfile() do
       Tempfile.get_name
     end
     @doc """
     To create a temp file with arguments (ext and path) and write to it. Default value for extension is '.tmp':

     ## Arguments
 
     - `path` path where to create tempfile in bitstring
     - `ext` extension of newly created tempfile in bitstring

     ## Usage

         Radpath.mktempfile(".log", "/home/lowks/Downloads") |> File.write("abcdef")

     """
     def mktempfile(ext, path) when is_bitstring(path) and is_bitstring(ext) do
        Tempfile.get_name("", [ext: ext, path: path])
     end
    @doc """
    To create a temp file at a certain location without extension and write to it:
    ## Arguments
 
     - `path` path where to create tempfile in bitstring

    ## Usage

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
      temp_name = Tempfile.get_name
      temp_name |> Path.rootname |> do_mkdir
      temp_name
    end
    @doc """
    To create a temp dir at a specific location:

    ## Arguments

    - `path` location to create tempdir in bitstring

    ## Usage

        Radpath.mktempdir("/home/lowks/Downloads")

    """
    def mktempdir(path) when is_bitstring(path) do
      Tempfile.get_name([path: make_into_path(path)]) |> 
	  Path.rootname |> 
	  do_mkdir
    end

  end   
  end
end
