ExUnit.configure(exclude: [task: true])
ExUnit.start()

defmodule TestHelper do
  @project_path        Path.dirname(__DIR__)
  @sample_project_path Path.join([@project_path, "test", "sample_project"])

  def prepare_test_project do
    tmp_dir = Path.join([System.tmp_dir!, "sample_project"])
    File.cp_r!(@sample_project_path, tmp_dir)

    tmp_mix_exs = Path.join([tmp_dir, "mix.exs"])

    mix_exs_content = tmp_mix_exs
      |> File.read!
      |> String.replace("PROJECT_PATH", @project_path)
    File.write!(tmp_mix_exs, mix_exs_content)

    tmp_dir
  end

  def run(task, tmp_dir) when task in [:init, :compile] do
    System.cmd("mix", ["diethyl.#{task}"], cd: tmp_dir)
  end
end
