defmodule Roman do
  @doc """
  Convert the number to a roman number.
  """
  @spec numerals(pos_integer) :: String.t()
  def numerals(number) do
    numerals(number, "")
  end

  defp numerals(0, acc) do
    acc
  end

  defp numerals(number, acc) do
    {number, roman} =
      cond do
        number >= 1_000 -> {number - 1000, "M"}
        number >= 900 -> {number - 900, "CM"}
        number >= 500 -> {number - 500, "D"}
        number >= 400 -> {number - 400, "CD"}
        number >= 100 -> {number - 100, "C"}
        number >= 90 -> {number - 90, "XC"}
        number >= 50 -> {number - 50, "L"}
        number >= 40 -> {number - 40, "XL"}
        number >= 10 -> {number - 10, "X"}
        number >= 9 -> {number - 9, "IX"}
        number >= 5 -> {number - 5, "V"}
        number >= 4 -> {number - 4, "IV"}
        number >= 1 -> {number - 1, "I"}
      end

    numerals(number, acc <> roman)
  end
end
