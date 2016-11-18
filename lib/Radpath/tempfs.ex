defmodule Radpath.Tempfs do
   defmacro __using__([]) do
     quote do

    @moduledoc """
     Generating temp files and directories which can be used. 
    """

     @doc """
     To create a temp file and write to it without arguments:

         {status, fd, file_path}  = Radpath.mktempfile
         IO.write fd, "hoho"
         File.close fd
         File.read! filepath
         "hoho"
         File.rm! filepath
     """

     @spec mktempfile() :: none
     def mktempfile() do
       Temp.open "Temp file"
     end
     @doc """
     To create a temp file with arguments (ext and path) and write to it. Default value for extension is '.tmp':

     ## Arguments

     - `path` path where to create tempfile in bitstring
     - `ext` extension of newly created tempfile in bitstring

     ## Usage

         {_, fd, filepath} = Radpath.mktempfile(".log", "/home/lowks/Downloads")
         IO.write fd, "hoho"
         File.read! filepath
         "hoho"
         File.close! filepath

         {_, fd, filepath} = Radpath.mktempfile("/home/lowks/Downloads")
         IO.write fd, "hoho"
         File.read! filepath
         "hoho"
         File.close! filepath
 
     """

     @spec mktempfile(bitstring, bitstring) :: bitstring
     def mktempfile(ext \\ ".tmp", path) when is_bitstring(path) and is_bitstring(ext) do
        # Tempfile.get_name("", [ext: ext, path: path])
        Temp.open %{suffix: ext, basedir: path}
     end

    @doc """
    To create a temp file at a certain location without extension and write to it:
    ## Arguments

     - `path` path where to create tempfile in bitstring

    ## Usage

         {_, fd, filepath} = Radpath.mktempfile("/home/lowks/Downloads")
         IO.write fd, "hoho"
         File.read! filepath
         "hoho"
         File.close! filepath
    """

   @doc """
    To create a temp dir with out without arguments:

        Radpath.mktempdir

    To create a temp dir at a specific location:

    ## Arguments

    - `path` location to create tempdir in bitstring

    ## Usage

        Radpath.mktempdir("/home/lowks/Downloads")


    """

    @spec mktempdir(bitstring) :: none
    def mktempdir(path \\ "/tmp") when is_bitstring(path) do
      Temp.mkdir(%{basedir: path}) |> tap({_, path_name} ~> path_name)
    end

  end
  end
end
