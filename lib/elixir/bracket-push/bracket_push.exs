defmodule BracketPush do
  @doc """
  Checks that all the brackets and braces in the string are matched correctly, and nested correctly
  """
  @spec check_brackets(String.t()) :: boolean
  def check_brackets(str) do
    str
    |> String.codepoints()
    |> Enum.reduce_while([], &process_brackets/2)
    |> check_valid_stack()
  end

  defp process_brackets(codepoint, stack) when codepoint not in ["(", ")", "{", "}", "[", "]"] do
    {:cont, stack}
  end

  defp process_brackets("(", stack), do: {:cont, [")" | stack]}
  defp process_brackets("[", stack), do: {:cont, ["]" | stack]}
  defp process_brackets("{", stack), do: {:cont, ["}" | stack]}
  defp process_brackets(codepoint, [codepoint | stack]), do: {:cont, stack}
  defp process_brackets(_, _), do: {:halt, false}

  defp check_valid_stack([]), do: true
  defp check_valid_stack(_), do: false
end
