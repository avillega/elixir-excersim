defmodule Strain do
  @doc """
  Given a `list` of items and a function `fun`, return the list of items where
  `fun` returns true.

  Do not use `Enum.filter`.
  """
  @spec keep(list :: list(any), fun :: (any -> boolean)) :: list(any)
  def keep(list, fun) do
    filter(list, fun, [])
  end

  defp filter([head|tail], fun, acc) do
    new_acc = if fun.(head), do: acc ++ [head], else: acc
    filter(tail, fun, new_acc)
  end

  defp filter([], _fun, acc) do
    acc
  end

  @doc """
  Given a `list` of items and a function `fun`, return the list of items where
  `fun` returns false.

  Do not use `Enum.reject`.
  """
  @spec discard(list :: list(any), fun :: (any -> boolean)) :: list(any)
  def discard(list, fun) do
    filter(list, comp(fun), [])
  end

  defp comp(fun) do
    fn x -> !fun.(x) end
  end

end
