defmodule RNATranscription do
  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples

  iex> RNATranscription.to_rna('ACTG')
  'UGAC'
  """
  @spec to_rna([char]) :: [char]
  def to_rna(dna) do
    mapping = %{
      ?G => ?C,
      ?C => ?G,
      ?T => ?A,
      ?A => ?U,
    }
    Enum.map(dna, fn c -> mapping[c] end)
  end
end
