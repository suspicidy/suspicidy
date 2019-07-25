defmodule Suspicidy.Builder.Path do
  @moduledoc """
  Used to generate functions that deal with request paths.

  The functions are:
    - `Suspicidy.suspicious_path?/1`

  By default, it uses the data-set that comes with the library.

  ## Usage

      defmodule MyCustomModule do
        use Suspicidy.Builder.Path
      end

  If you want to use your own data-set, you have to create your own loader module.
  Take a look at the default `Suspicidy.Loader.Path` module for an example.

  You then pass your custom loader module as an option to the `use` macro.

      defmodule MyCustomModule do
        use Suspicidy.Builder.Path,
            loader: MyApp.CustomPathLoader
      end

  ## Options

    - `loader`: Module which loads the data. Defaults to `Suspicidy.Loader.Path`
  """

  defmacro __using__(opts) do
    path_loader = Macro.expand_once(Keyword.get(opts, :loader, (quote do: Suspicidy.Loader.Path)), __ENV__)

    paths = path_loader.paths()

    external_resources = external_resource_files(path_loader.resource_files())
    suspicious_path_functions = generate_suspicious_path_functions(paths)

    external_resources ++ suspicious_path_functions
  end

  defp external_resource_files(paths) do
    for path <- paths do
      quote do
        @external_resource unquote(path)
      end
    end
  end

  defp generate_suspicious_path_functions(paths) do
    doc = quote do
      @doc """
      Returns `true` if the given path is likely to be suspicious.

      ## Examples

          iex> suspicious_path?("/")
          false

          iex> suspicious_path?("/phpmyadmin")
          true

      """
    end

    type = quote do
      @spec suspicious_path?(String.t()) :: boolean()
    end

    for_paths = for path <- paths do
      quote do
        def suspicious_path?(unquote(path)), do: true
      end
    end

    for_catch_all = quote do
      def suspicious_path?(_), do: false
    end

    [doc, type] ++ for_paths ++ [for_catch_all]
  end
end
