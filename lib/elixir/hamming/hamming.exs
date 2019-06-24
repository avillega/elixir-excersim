defmodule Hamming do
  @doc """
  Returns number of differences between two strands of DNA, known as the Hamming Distance.

  ## Examples

  iex> Hamming.hamming_distance('AAGTCATA', 'TAGCGATC')
  {:ok, 4}
  """
  @spec hamming_distance([char], [char]) :: {:ok, non_neg_integer} | {:error, String.t()}
  def hamming_distance(strand, strand), do: {:ok, 0}

  def hamming_distance(strand1, strand2) when length(strand1) == length(strand2) do
    sum =
      Stream.zip(strand1, strand2)
      |> Enum.count(fn {s1, s2} -> s1 != s2 end)

    {:ok, sum}
  end

  def hamming_distance(_, _), do: {:error, "Lists must be the same length"}
end
