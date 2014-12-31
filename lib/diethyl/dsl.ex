defmodule Diethyl.DSL do
  alias Diethyl.Template

  defmacro presentation([do: {:__block__, _, slides}]) do
    quote do
      Enum.map unquote(slides), fn slide ->
        Code.eval_quoted(slide) |> elem 0
      end
    end
  end

  defmacro cover([do: block]) do
    params = block |> to_map

    quote do
      Template.cover(
        unquote(params.title),
        unquote(params.author),
        unquote(params.date)
      )
    end
  end

  defmacro title_and_content([do: block]) do
    params = block |> to_map

    quote do
      Template.title_and_content(
        unquote(params.title),
        unquote(params.content)
      )
    end
  end

  defmacro only_content([do: block]) do
    params = block |> to_map

    quote do
      Template.only_content(unquote params.content)
    end
  end

  defp to_map({:__block__, _, lines}) do
    for line <- lines, do: to_kv(line), into: %{}
  end

  defp to_map(single_line) do
    {k, v} = to_kv(single_line)
    Map.new |> Map.put(k, v)
  end

  @valid_keys [:title, :author, :date, :content]

  defp to_kv({k, _, [v | _]}) when k in @valid_keys, do: {k, v}
end
