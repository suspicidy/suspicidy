# Suspicidy

Suspicidy aims to detect suspicious web requests. 
Currently, it only supports detection by request path, 
using a data-set of almost 800 paths collected from real web crawlers.

## Installation

The package can be installed by adding `suspicidy` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:suspicidy, "~> 0.1.0"}
  ]
end
```

## Usage

If you want to use the built-in data-set, you can just use the `Suspicidy` module.

```elixir
iex(1)> Suspicidy.suspicious_path?("/")
false

iex(2)> Suspicidy.suspicious_path?("/phpmyadmin")
true
```

### Custom Data

You can use your own data-set if you wish. 
In order to do so, you have to create a loader module for the 
request paths. Here is a simply example:

```elixir
defmodule MyApp.CustomLoader do
  def resource_files() do
    # Normally this would return a list of
    # file paths to the files containing the data-set.
    # You would put them in your priv directory.
    []
  end
  
  def paths() do
    # Here we return a list of paths.
    # You would normally load them from 
    # e.g. your priv directory.
    ["/evil", "/data.zip"]
  end
end
```

Then you can create a custom module and instruct Suspicidy to 
expose your data-set.

```elixir
defmodule MyApp.CustomUsage do
  use Suspicidy.Builder, 
      path: [loader: MyApp.CustomLoader]
end
```

Finally, use your custom module:

```elixir
iex(1)> MyApp.CustomUsage.suspicious_path?("/")
false

iex(2)> MyApp.CustomUsage.suspicious_path?("/evil")
true
```

