# Radpath Repository Explanation

Radpath is an Elixir library designed for path manipulation, largely inspired by Python's `pathlib`. It provides a more idiomatic and convenient way to handle file system paths in Elixir compared to the standard `Path` and `File` modules alone.

## Project Structure

The codebase is organized into a main facade module and several specialized submodules:

*   **`Radpath` (`lib/radpath.ex`)**: The main entry point that aggregates functionalities from submodules and provides additional utilities like zipping, hashing, and symlink management.
*   **`Radpath.Dirs` (`lib/Radpath/directory.ex`)**: Focuses on directory-related operations, such as listing directories with regex filtering.
*   **`Radpath.Files` (`lib/Radpath/files.ex`)**: Handles file-specific operations, including listing files with extension-based filtering.
*   **`Radpath.Tempfs` (`lib/Radpath/tempfs.ex`)**: Provides utilities for creating temporary files and directories.

## Key Features and Functionalities

### 1. File and Directory Listing
*   `Radpath.files(path, ext \\ nil)`: Lists files in a given path, optionally filtered by extension.
*   `Radpath.dirs(path, regex_dir \\ ".+")`: Lists directories in a given path, optionally filtered by a regex pattern.

### 2. Archiving (Zip/Unzip)
*   `Radpath.zip(paths, archive_name)`: Creates a zip archive from a list of paths or a single path.
*   `Radpath.unzip(zip_file, unzip_dir \\ File.cwd!)`: Extracts a zip archive to a specified directory.

### 3. File Hashing
*   `Radpath.md5sum(path)`: Calculates the MD5 hash of a file.
*   `Radpath.sha1sum(path)`: Calculates the SHA1 hash of a file.

### 4. Path Utilities
*   `Radpath.relative_path(base, file)`: Returns the relative path of a file with respect to a base directory.
*   `Radpath.parent_path(path)`: Retrieves the parent directory of a given path.
*   `Radpath.ensure(path, is_file \\ false)`: Ensures a directory or file exists (creates it if it doesn't).
*   `Radpath.erusne(path)`: The opposite of `ensure`; removes a file or directory if it exists.

### 5. Symlinks
*   `Radpath.symlink(source, destination)`: Creates a symbolic link.
*   `Radpath.islink?(path)`: Checks if a given path is a symbolic link.

### 6. Temporary Filesystem
*   `Radpath.mktempfile(ext \\ ".tmp", path)`: Creates a temporary file.
*   `Radpath.mktempdir(path \\ "/tmp")`: Creates a temporary directory.

## Usage Examples

Based on the project's tests and documentation:

```elixir
# List all PDF files in a directory
Radpath.files("/path/to/docs", "pdf")

# Create a zip archive
Radpath.zip(["dir1", "file1.txt"], "my_archive.zip")

# Get MD5 checksum of a file
hash = Radpath.md5sum("mix.exs")

# Ensure a directory exists
Radpath.ensure("/tmp/my_new_dir")

# Create a temporary log file
{status, fd, filepath} = Radpath.mktempfile(".log", "/tmp")
```

## Development and Testing

*   **Build Tool**: Mix
*   **Dependencies**: Includes `ex_doc`, `finder`, `erlware_commons`, `pattern_tap`, and `temp`.
*   **Testing**: The project uses `ExUnit`. Tests can be run via `make test` or `mix test` (requires Elixir and Erlang to be installed).
*   **CI/CD**: The project uses GitHub Actions for automated building and testing (see `.github/workflows/autobuild.yml`).
