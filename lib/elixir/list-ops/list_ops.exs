defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.

  @spec count(list) :: non_neg_integer
  def count(l) do
    reduce(l, 0, fn _, acc ->
      acc + 1
    end)
  end

  @spec reverse(list) :: list
  def reverse(l) do
    reverse(l, [])
  end

  defp reverse([], acc), do: acc
  defp reverse([head | tail], acc), do: reverse(tail, [head | acc])

  @spec map(list, (any -> any)) :: list
  def map(l, f) do
    l
    |> reduce([], &[f.(&1) | &2])
    |> reverse
  end

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(l, f) do
    l
    |> reduce([], fn x, acc ->
      if f.(x) do
        [x | acc]
      else
        acc
      end
    end)
    |> reverse()
  end

  @type acc :: any
  @spec reduce(list, acc, (any, acc -> acc)) :: acc
  def reduce(l, acc, f) do
    reduce_aux(l, acc, f)
  end

  defp reduce_aux([], acc, _f), do: acc

  defp reduce_aux([head | tail], acc, f) do
    reduce_aux(tail, f.(head, acc), f)
  end

  @spec append(list, list) :: list
  def append(a, b) do
    concat([a, b])
  end

  @spec concat([[any]]) :: [any]
  def concat(ll) do
    ll
    |> reduce([], fn ls, acc ->
      reduce(ls, acc, &[&1 | &2])
    end)
    |> reverse()
  end
end
