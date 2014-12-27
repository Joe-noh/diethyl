defmodule Mix.Tasks.Diethyl.Init do
  @shortdoc "initialize this dir as diethyl project"

  use Mix.Task

  def run(_) do
    Enum.each ["lib", "test"], fn dir ->
      if File.dir?(dir), do: File.rm_rf!(dir)
    end

    Enum.each ["config", "src"], fn dir ->
      unless File.dir?(dir), do: File.mkdir!(dir)
    end

    create_presentation_exs("src/presentation.exs")
    create_config_exs("config/config.exs")
  end

  defp create_presentation_exs(path) do
    unless File.exists?(path), do: File.write!(path, presentation_exs_content)
  end

  defp create_config_exs(path) do
    unless File.exists?(path), do: File.write!(path, config_exs_content)
  end

  defp presentation_exs_content do
    ~s<
    use Diethyl

    presentation do
      slide :cover do
        title  "Presentation Title"
        author "John Doe"
        date   2014, 12, 26
      end
    end
    >
  end

  defp config_exs_content do
    ~s<
    use Mix.Config

    config :diethyl, :foo,
      bar: 1
    >
  end
end
