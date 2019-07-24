defmodule Suspicidy.Builder do
  @moduledoc false

  defmacro __using__(opts) do
    path_options = Keyword.get(opts, :path, [])

    quote do
      use Suspicidy.Builder.Path, unquote(path_options)
    end
  end
end
