defmodule Diethyl do
  defmacro __using__(_) do
    quote do
      import Diethyl.DSL
    end
  end
end
