defmodule Hexadecimal do
  @doc """
    Accept a string representing a hexadecimal value and returns the
    corresponding decimal value.
    It returns the integer 0 if the hexadecimal is invalid.
    Otherwise returns an integer representing the decimal value.

    ## Examples

      iex> Hexadecimal.to_decimal("invalid")
      0

      iex> Hexadecimal.to_decimal("af")
      175

  """
  @spec to_decimal(binary) :: integer
  def to_decimal(hex) do
    hex
    |> String.upcase()
    |> String.reverse()
    |> String.codepoints()
    |> Stream.with_index()
    |> Enum.reduce_while(0, fn {codepoint, index}, acc ->
      case codepoint_to_decimal(codepoint) do
        {:ok, decimal} -> {:cont, acc + :math.pow(16, index) * decimal}
        {:error, _} -> {:halt, 0}
      end
    end)
  end

  defp codepoint_to_decimal(codepoint) do
    case codepoint do
      "0" -> {:ok, 0}
      "1" -> {:ok, 1}
      "2" -> {:ok, 2}
      "3" -> {:ok, 3}
      "4" -> {:ok, 4}
      "5" -> {:ok, 5}
      "6" -> {:ok, 6}
      "7" -> {:ok, 7}
      "8" -> {:ok, 8}
      "9" -> {:ok, 9}
      "A" -> {:ok, 10}
      "B" -> {:ok, 11}
      "C" -> {:ok, 12}
      "D" -> {:ok, 13}
      "E" -> {:ok, 14}
      "F" -> {:ok, 15}
      _ -> {:error, 0}
    end
  end
end
