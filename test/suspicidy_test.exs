defmodule SuspicidyTest do
  use ExUnit.Case

  describe "suspicious_path?/1" do
    test "index is not suspicious" do
      assert Suspicidy.suspicious_path?("/") == false
    end

    test "phpmyadmin is suspicious" do
      assert Suspicidy.suspicious_path?("/phpmyadmin") == true
    end
  end
end
