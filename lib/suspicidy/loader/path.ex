defmodule Suspicidy.Loader.Path do
  @moduledoc """
  Loads the path data from the built-in data-set.

  Currently, there is only static path data collected from real web crawlers using honeypots.
  The static path data is stored in `priv/paths/static/data/`.

  Since the data comes from real crawlers, there might be false-positives.
  That is what the `priv/paths/static/excluded.txt` file is for.
  It contains paths that should not be treated as suspicious.
  """

  @doc """
  Returns a list of file paths for the data-set.

  The file paths are used for generating the `@external_resource` module attributes
  to enforce recompilation if their content has changed.
  """
  @spec resource_files() :: list(String.t())
  def resource_files() do
    excluded_paths_files() ++ paths_files()
  end

  @doc """
  Returns a list of all suspicious static paths.
  """
  @spec paths() :: list(String.t())
  def paths() do
    data =
      paths_files()
      |> load_file_entries()

    excluded =
      excluded_paths_files()
      |> load_file_entries()

    MapSet.difference(MapSet.new(data), MapSet.new(excluded))
    |> MapSet.to_list()
  end

  defp load_file_entries(files) do
    files
    |> Enum.map(fn path ->
      path
      |> File.read!()
      |> String.split("\n")
      |> Enum.reject(fn
        "" -> true
        x -> String.starts_with?(x, "#")
      end)
    end)
    |> List.flatten()
    |> Enum.uniq()
  end

  defp paths_files() do
    :code.priv_dir(:suspicidy)
    |> Path.join("/paths/static/data/**/*.txt")
    |> Path.wildcard()
  end

  defp excluded_paths_files() do
    excluded =
      :code.priv_dir(:suspicidy)
      |> Path.join("/paths/static/excluded.txt")

    [excluded]
  end
end
