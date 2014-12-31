defmodule InitTaskTest do
  use ExUnit.Case

  @moduletag :task

  setup_all do
    tmp_dir = TestHelper.prepare_test_project
    TestHelper.run(:init, tmp_dir)

    {:ok, tmp_dir: tmp_dir}
  end

  test "directory structure", context do
    File.cd! context.tmp_dir

    ["src/presentation.exs", "config/config.exs"]
    |> Enum.each(fn file ->
      assert File.exists?(file)
    end)

    ["lib", "test"]
    |> Enum.each(& refute(File.exists? &1))
  end

  test "src/presentation.exs does not have indents", context do
    File.cd! context.tmp_dir

    File.read!("src/presentation.exs")
    |> String.starts_with?(" ")
    |> refute
  end
end
