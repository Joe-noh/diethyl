defmodule TasksTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO

  test "mix help shows diethyl tasks" do
    tasks = capture_io(fn -> Mix.shell.cmd "mix help" end)

    assert tasks =~ ~r{diethyl\.compile}
    assert tasks =~ ~r{diethyl\.init}
  end
end
