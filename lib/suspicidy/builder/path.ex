defmodule Suspicidy.Builder.Path do
  @moduledoc false

  defp external_resource_files(paths) do
    for path <- paths do
      quote do
        @external_resource unquote(path)
      end
    end
  end

  defp generate_suspicious_path_functions(paths) do
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

    [type] ++ for_paths ++ [for_catch_all]
  end

  defmacro __using__(opts) do
    path_loader = Macro.expand_once(Keyword.get(opts, :loader, (quote do: Suspicidy.Loader.Path)), __ENV__)

    paths = path_loader.paths()

    external_resources = external_resource_files(path_loader.resource_files())
    suspicious_path_functions = generate_suspicious_path_functions(paths)

    external_resources ++ suspicious_path_functions
  end
end
