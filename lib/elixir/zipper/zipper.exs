defmodule BinTree do
  @moduledoc """
  A node in a binary tree.

  `value` is the value of a node.
  `left` is the left subtree (nil if no subtree).
  `right` is the right subtree (nil if no subtree).
  """

  @type t :: %BinTree{value: any, left: t() | nil, right: t() | nil}

  defstruct [:value, :left, :right]
end

defimpl Inspect, for: BinTree do
  import Inspect.Algebra

  # A custom inspect instance purely for the tests, this makes error messages
  # much more readable.
  #
  # BinTree[value: 3, left: BinTree[value: 5, right: BinTree[value: 6]]] becomes (3:(5::(6::)):)
  def inspect(%BinTree{value: value, left: left, right: right}, opts) do
    concat([
      "(",
      to_doc(value, opts),
      ":",
      if(left, do: to_doc(left, opts), else: ""),
      ":",
      if(right, do: to_doc(right, opts), else: ""),
      ")"
    ])
  end
end

defmodule Zipper do
  @doc """
  Get a zipper focused on the root node.
  """
  @type trail :: [{:left, any, BinTree.t()} | {:right, any, BinTree.t()}]
  @type t :: %Zipper{original: BinTree.t(), focus: BinTree.t(), trail: trail()}
  defstruct [:original, :focus, :trail]

  @spec from_tree(BinTree.t()) :: Zipper.t()
  def from_tree(%BinTree{} = bin_tree) do
    %Zipper{original: bin_tree, focus: bin_tree, trail: []}
  end

  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Zipper.t()) :: BinTree.t()
  def to_tree(%Zipper{focus: focus, trail: []}), do: focus

  def to_tree(%Zipper{} = zipper) do
    zipper
    |> up()
    |> to_tree()
  end

  @doc """
  Get the value of the focus node.
  """
  @spec value(Zipper.t()) :: any
  def value(%Zipper{focus: %BinTree{value: value}}) do
    value
  end

  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Zipper.t()) :: Zipper.t() | nil
  def left(%Zipper{focus: %BinTree{left: nil}}), do: nil

  def left(%Zipper{trail: trail, focus: %BinTree{} = focus} = zipper) do
    %{zipper | focus: focus.left, trail: [{:left, focus.value, focus.right} | trail]}
  end

  @doc """
  Get the right child of the focus node, if any.
  """
  @spec right(Zipper.t()) :: Zipper.t() | nil
  def right(%Zipper{focus: %BinTree{right: nil}}), do: nil

  def right(%Zipper{trail: trail, focus: %BinTree{} = focus} = zipper) do
    %{zipper | focus: focus.right, trail: [{:right, focus.value, focus.left} | trail]}
  end

  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(Zipper.t()) :: Zipper.t() | nil
  def up(%Zipper{trail: [{:left, value, right_tree} | rest], focus: focus} = zipper) do
    %{zipper | trail: rest, focus: %BinTree{value: value, left: focus, right: right_tree}}
  end

  def up(%Zipper{trail: [{:right, value, left_tree} | rest], focus: focus} = zipper) do
    %{zipper | trail: rest, focus: %BinTree{value: value, left: left_tree, right: focus}}
  end

  def up(%Zipper{}), do: nil

  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Zipper.t(), any) :: Zipper.t()
  def set_value(%Zipper{focus: focus} = zipper, value) do
    %{zipper | focus: %{focus | value: value}}
  end

  @doc """
  Replace the left child tree of the focus node.
  """
  @spec set_left(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_left(%Zipper{focus: focus} = zipper, left) do
    %{zipper | focus: %{focus | left: left}}
  end

  @doc """
  Replace the right child tree of the focus node.
  """
  @spec set_right(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_right(%Zipper{focus: focus} = zipper, right) do
    %{zipper | focus: %{focus | right: right}}
  end
end
