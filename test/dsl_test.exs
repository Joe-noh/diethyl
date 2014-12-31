defmodule DSLTest do
  use ExUnit.Case, async: true

  import Diethyl.DSL

  test "presentation/1 evals lines and collects results" do
    result = presentation do
      "1"
      2 + 3
    end

    assert result == ["1", 5]
  end

  test "cover" do
    html = cover do
      title  "The Title"
      author "The Author"
      date   "2014-12-30"
    end

    assert html =~ ~r{<h1.+The Title</h1>}
    assert html =~ ~r{<p.+The Author</p>}
    assert html =~ ~r{<p.+2014\-12\-30</p>}
    assert html =~ "cover"
  end

  test "title_and_content" do
    html = title_and_content do
      title "The Title"
      content """
      hey
      you
      whats
      up
      """
    end

    assert html =~ ~r{<h1.+The Title</h1>}
    assert html =~ "hey\nyou\nwhats\nup"
    assert html =~ "title-and-content"
  end

  test "only_content" do
    html = only_content do
      content """
      hey
      you
      whats
      up
      """
    end

    refute html =~ "h1"
    assert html =~ "hey\nyou\nwhats\nup"
    assert html =~ "only-content"
  end

  test "integration" do
    htmls = presentation do
      cover do
        title  "The Title"
        author "The Author"
        date   "Today"
      end

      title_and_content do
        title "Slide 1"
        content """
        - one
        - two

        this is a *slide*
        """
      end

      only_content do
        content """
        ```
        a = [1, 2, 3]
        a |> Enum.map(&to_string/1) |> Enum.join
        ```
        """
      end
    end

    assert Enum.count(htmls) == 3
    assert Enum.all? htmls, &String.contains?(&1, ~s{class="slide})
  end
end
