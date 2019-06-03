defmodule Markdown do
  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

    iex> Markdown.parse("This is a paragraph")
    "<p>This is a paragraph</p>"

    iex> Markdown.parse("#Header!\n* __Bold Item__\n* _Italic Item_")
    "<h1>Header!</h1><ul><li><em>Bold Item</em></li><li><i>Italic Item</i></li></ul>"
  """
  @spec parse(String.t()) :: String.t()
  def parse(markdown) do
    # Use pipelines instead of nested calls
    markdown
    |> String.split("\n")
    |> Enum.map_join("", &process/1)
    |> add_ul_tag()
  end

  # Split process in multiclause and use pattern matching
  defp process("#" <> _ = line) do
    line
    |> parse_header_md_level
    |> enclose_with_header_tag
  end

  defp process("*" <> _ = line) do
    parse_list_md_level(line)
  end

  defp process(line) do
    line
    |> String.split()
    |> enclose_with_paragraph_tag()
  end

  defp parse_header_md_level(header_line) do
    [header_indicator | line] = String.split(header_line, ~r[\s], parts: 2)
    {String.length(header_indicator), line}
  end

  defp parse_list_md_level(list_item) do
    parsed_words =
      list_item
      |> String.trim_leading("* ")
      |> String.split()
      |> join_words_with_tags()

    "<li>#{parsed_words}</li>"
  end

  defp enclose_with_header_tag({header_size, content}) do
    "<h#{header_size}>#{content}</h#{header_size}>"
  end

  defp enclose_with_paragraph_tag(line) do
    "<p>#{join_words_with_tags(line)}</p>"
  end

  defp join_words_with_tags(words) do
    words
    |> Enum.map_join(" ", &replace_md_with_tag/1)
  end

  defp replace_md_with_tag(word) do
    word
    |> replace_prefix_md()
    |> replace_suffix_md()
  end

  defp replace_prefix_md("__" <> word), do: "<strong>#{word}"
  defp replace_prefix_md("_" <> word), do: "<em>#{word}"
  defp replace_prefix_md(word), do: word

  # I was not able to find a way to match the end of a string as I did with the prefix
  defp replace_suffix_md(md_word) do
    cond do
      String.ends_with?(md_word, "__") ->
        String.replace_suffix(md_word, "__", "</strong>")

      String.ends_with?(md_word, "_") ->
        String.replace_suffix(md_word, "_", "</em>")

      true ->
        md_word
    end
  end

  defp add_ul_tag(markdown) do
    markdown
    |> String.replace("<li>", "<ul><li>", global: false)
    |> String.replace_suffix("</li>", "</li></ul>")
  end
end
