defmodule Evaluator do
  @type t :: %Evaluator{stack: [integer], words: map}
  defstruct stack: [], words: %{}
end

defmodule Forth do
  @opaque evaluator :: Evaluator.t()

  defguard is_arithmetic_operator(element) when element in ["+", "-", "*", "/"]

  @doc """
  Create a new evaluator.
  """
  @spec new() :: evaluator
  def new() do
    words = %{
      "dup" => [&dup/1],
      "swap" => [&swap/1],
      "drop" => [&drop/1],
      "over" => [&over/1]
    }

    %Evaluator{words: words}
  end

  defp is_digits(term), do: Regex.match?(~r/\d+/, term)

  @doc """
  Evaluate an input string, updating the evaluator state.
  """
  @spec eval(evaluator, String.t()) :: evaluator
  def eval(evaluator, expresion) do
    expresion
    |> String.downcase()
    |> String.split(";", trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.reduce(evaluator, &process_line/2)
  end

  defp process_line(":" <> expression, %Evaluator{words: words} = evaluator) do
    [new_word | assigns] = String.split(expression, ~r/[^[:graph:]]+/iu, trim: true)

    if is_digits(new_word) do
      raise(Forth.InvalidWord)
    end

    processed_assigns =
      Enum.flat_map(assigns, fn assign ->
        cond do
          is_digits(assign) -> [String.to_integer(assign)]
          true -> find_word_function(assign, words)
        end
      end)

    %{evaluator | words: Map.put(words, new_word, processed_assigns)}
  end

  defp process_line(line, evaluator) do
    line
    |> String.split(~r/[^[:graph:]]+/iu)
    |> Enum.reduce(evaluator, &process_element/2)
  end

  defp find_word_function(word, words_map) do
    case Map.fetch(words_map, word) do
      {:ok, val} -> val
      :error -> raise(Forth.UnknownWord)
    end
  end

  defp process_element("/", %Evaluator{stack: [0, _ | _]}), do: raise(Forth.DivisionByZero)

  defp process_element(element, %Evaluator{stack: [x, y | rest]} = evaluator)
       when is_arithmetic_operator(element) do
    case element do
      "+" -> %{evaluator | stack: [x + y | rest]}
      "-" -> %{evaluator | stack: [y - x | rest]}
      "*" -> %{evaluator | stack: [x * y | rest]}
      "/" -> %{evaluator | stack: [div(y, x) | rest]}
    end
  end

  defp process_element(element, %Evaluator{stack: _})
       when is_arithmetic_operator(element) do
    raise(Forth.StackUnderflow)
  end

  defp process_element(element, %Evaluator{stack: stack} = evaluator) do
    cond do
      is_digits(element) ->
        %{evaluator | stack: [String.to_integer(element) | stack]}

      true ->
        apply_word(element, evaluator)
    end
  end

  defp apply_word(word, %Evaluator{words: words, stack: stack} = evaluator) do
    with {:ok, expressions} <- Map.fetch(words, word) do
      new_stack =
        expressions
        |> Enum.reduce(stack, fn
          number, acc when is_number(number) -> [number | acc]
          fun, acc when is_function(fun) -> fun.(acc)
        end)

      %{evaluator | stack: new_stack}
    else
      :error -> raise(Forth.UnknownWord)
    end
  end

  defp dup([]), do: raise(Forth.StackUnderflow)

  defp dup([x | rest]) do
    [x, x | rest]
  end

  defp drop([]), do: raise(Forth.StackUnderflow)

  defp drop([_x | rest]) do
    rest
  end

  defp swap([_]), do: raise(Forth.StackUnderflow)
  defp swap([]), do: raise(Forth.StackUnderflow)

  defp swap([x, y | rest]) do
    [y, x | rest]
  end

  defp over([]), do: raise(Forth.StackUnderflow)
  defp over([_]), do: raise(Forth.StackUnderflow)

  defp over([x, y | rest]) do
    [y, x, y | rest]
  end

  @doc """
  Return the current stack as a string with the element on top of the stack
  being the rightmost element in the string.
  """
  @spec format_stack(evaluator) :: String.t()
  def format_stack(%Evaluator{stack: stack}) do
    stack
    |> Enum.reverse()
    |> Enum.join(" ")
  end

  defmodule StackUnderflow do
    defexception []
    def message(_), do: "stack underflow"
  end

  defmodule InvalidWord do
    defexception word: nil
    def message(e), do: "invalid word: #{inspect(e.word)}"
  end

  defmodule UnknownWord do
    defexception word: nil
    def message(e), do: "unknown word: #{inspect(e.word)}"
  end

  defmodule DivisionByZero do
    defexception []
    def message(_), do: "division by zero"
  end
end
