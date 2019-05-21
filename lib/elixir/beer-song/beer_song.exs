defmodule BeerSong do
  @doc """
  Get a single verse of the beer song
  """
  @spec verse(integer) :: String.t()
  def verse(number) do
    """
    #{first_verse(number)}
    #{second_verse(number)}
    """
  end

  defp first_verse(1), do: "1 bottle of beer on the wall, 1 bottle of beer."
  defp first_verse(0), do: "No more bottles of beer on the wall, no more bottles of beer."

  defp first_verse(number) do
    "#{number} bottles of beer on the wall, #{number} bottles of beer."
  end

  defp second_verse(2), do: "Take one down and pass it around, 1 bottle of beer on the wall."
  defp second_verse(0), do: "Go to the store and buy some more, 99 bottles of beer on the wall."

  defp second_verse(1) do
    "Take it down and pass it around, no more bottles of beer on the wall."
  end

  defp second_verse(number) do
    "Take one down and pass it around, #{number - 1} bottles of beer on the wall."
  end

  @doc """
  Get the entire beer song for a given range of numbers of bottles.
  """
  @spec lyrics(Range.t()) :: String.t()
  def lyrics(range) do
    range
    |> Enum.map(&verse/1)
    |> Enum.join("\n")
  end

  def lyrics() do
    lyrics(99..0)
  end
end
