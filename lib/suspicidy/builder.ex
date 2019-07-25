defmodule Suspicidy.Builder do
  @moduledoc """
  Used to generate all `Suspicidy` functions.

  By default, it uses the data-set that comes with the library.

  ## Usage

      defmodule MyCustomModule do
        use Suspicidy.Builder
      end

  If you want to use your own data-set, you have to create your own loader module.
  Take a look at the default `Suspicidy.Loader.Path` module for an example.

  You then pass your custom loader module as an option to the `use` macro.

      defmodule MyCustomModule do
        use Suspicidy.Builder,
            path: [loader: MyApp.CustomPathLoader]
      end

  The inner options for the `path` option get passed to the `Suspicidy.Builder.Path` module.
  """

  defmacro __using__(opts) do
    path_options = Keyword.get(opts, :path, [])

    quote do
      use Suspicidy.Builder.Path, unquote(path_options)
    end
  end
end
