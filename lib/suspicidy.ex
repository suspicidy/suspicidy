defmodule Suspicidy do
  @moduledoc """
  Suspicidy aims to detect suspicious web requests.
  Currently, it only supports detection by request path,
  using a data-set of almost 800 paths collected from real web crawlers.

  `Suspicidy` exposes the data-set that comes with the library.

  ## Examples

      iex> suspicious_path?("/")
      false

      iex> suspicious_path?("/phpmyadmin")
      true

  """

  use Suspicidy.Builder
end
