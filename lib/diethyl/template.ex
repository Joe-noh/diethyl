defmodule Diethyl.Template do
  import EEx

  function_from_string :def, :cover,
    """
    <div class="slide cover">
      <h1><%= title %></h1>
      <p><%= author %></p>
      <p><%= date %></p>
    </div>
    """,
    [:title, :author, :date]

  function_from_string :def, :title_and_content,
    """
    <div class="slide title-and-content">
      <h1><%= title %></h1>
      <div class="content">
        <%= content %>
      </div>
    </div>
    """,
    [:title, :content]

  function_from_string :def, :only_content,
    """
    <div class="slide only-content">
      <div class="content">
        <%= content %>
      </div>
    </div>
    """,
    [:content]
end
