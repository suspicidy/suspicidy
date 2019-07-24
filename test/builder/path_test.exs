defmodule Suspicidy.Builder.PathTest do
  use ExUnit.Case

  describe "using the Path builder" do
    defmodule StandardUsage do
      use Suspicidy.Builder.Path
    end

    test "shipped data becomes available as suspicious_path?/1 functions" do
      assert StandardUsage.suspicious_path?("/") == false
      assert StandardUsage.suspicious_path?("/phpmyadmin") == true
    end

    defmodule CustomLoader do
      def resource_files(), do: []
      def paths(), do: ["/evil", "/data.zip"]
    end

    defmodule CustomUsage do
      use Suspicidy.Builder.Path, loader: Suspicidy.Builder.PathTest.CustomLoader
    end

    test "custom data becomes available as suspicious_path?/1 functions" do
      assert CustomUsage.suspicious_path?("/") == false
      assert CustomUsage.suspicious_path?("/evil") == true
      assert CustomUsage.suspicious_path?("/data.zip") == true
    end
  end
end
