defmodule Suspicidy.Loader.Path do
  @moduledoc false

  def resource_files() do
    excluded_paths_files() ++ paths_files()
  end

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
