defmodule FlattenArray do
  @doc """
    Accept a list and return the list flattened without nil values.

    ## Examples

      iex> FlattenArray.flatten([1, [2], 3, nil])
      [1,2,3]

      iex> FlattenArray.flatten([nil, nil])
      []

  """

  @spec flatten(list) :: list
  def flatten([head | tail]) do
    case head do
      nil ->
        flatten(tail)

      h when is_list(h) ->
        flatten(h) ++ flatten(tail)

      _ ->
        [head | flatten(tail)]
    end
  end

  def flatten([]), do: []
end
