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
    ~s{
    use Diethyl

    presentation do
      cover do
        title  "Presentation Title"
        author "John Doe"
        date   "2014.12.26"
      end

      title_and_content do
        title "First Slide"
        content """
        - yeah!
        - write markdown here!
        """
      end
    end
    }
    |> String.strip(?\n)
    |> remove_indent 4
  end

  defp config_exs_content do
    """
    use Mix.Config

    config :diethyl, :foo,
      bar: 1
    """
  end

  defp remove_indent(lines, n) do
    lines
    |> String.split("\n")
    |> Enum.map(&do_remove_indent &1, n)
    |> Enum.join("\n")
  end

  defp do_remove_indent(line, 0), do: line
  defp do_remove_indent(" " <> line, n) do
    do_remove_indent(line, n-1)
  end
  defp do_remove_indent(line, _), do: line
end
