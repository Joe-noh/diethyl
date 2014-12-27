defmodule CompileTaskTest do
  use ExUnit.Case

  @moduletag :task

  setup_all do
    tmp_dir = TestHelper.prepare_test_project
    TestHelper.run(:init, tmp_dir)
    TestHelper.run(:compile, tmp_dir)

    {:ok, tmp_dir: tmp_dir}
  end

  test "directory structure", context do
    File.cd! context.tmp_dir

    [
      "pub/index.html", "pub/js/base.js", "pub/css/base.css",
      "pub/css/reset.css", "pub/css/theme.css"
    ]
    |> Enum.each fn file ->
      assert File.exists?(file)
    end
  end
end
