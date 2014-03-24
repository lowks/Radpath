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

         Radpath.mktempfile(".log", "/home/lowks/Downloads")

     """
     def mktempfile(ext, path) do
         tmp_path = Tempfile.get_name("", [ext: ext, path: path])
     if File.dir?(path) do
       case File.open(tmp_path, [:write]) do
         {:ok, tmp_path} ->
           {:ok, tmp_path }
         error ->
           error
       end
     end
    end

    @doc """
    To create a temp file at a certain location:

        Radpath.mktempfile("/home/lowks/Downloads")

    """
    def mktempfile(path) do
      tmp_path = Tempfile.get_name("", [ext: ".tmp", path: path])
      if File.dir?(path) do
        case File.open(tmp_path, [:write]) do
          {:ok, tmp_path} ->
            {:ok, tmp_path }
          error ->
            error
        end
      end
    end

    @doc """
    To create a temp dir without arguments:

        Radpath.mktempdir

    """
    def mktempdir do
      tmp_path = Tempfile.get_name |> Path.rootname
      if File.exists?(tmp_path) do
        File.rm_rf tmp_path
      end
      do_mkdir(tmp_path)
    end

    @doc """
    To create a temp dir with arguments:

        Radpath.mktempdir("/home/lowks/Downloads")

    """
    def mktempdir(path) when is_bitstring(path) do
      tmp_path = Tempfile.get_name([path: make_into_path(path)]) |> Path.rootname
      do_mkdir(tmp_path)
    end
    
   end
  end
end