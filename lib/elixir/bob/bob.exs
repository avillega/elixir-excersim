defmodule Bob do
  def hey(input) do
    cond do
      silence(input) -> "Fine. Be that way!"
      question(input) and shouting(input) -> "Calm down, I know what I'm doing!"
      shouting(input) -> "Whoa, chill out!"
      question(input) -> "Sure."
      :default -> "Whatever."
    end
  end

  defp question(input) do
    String.ends_with?(input, "?")
  end

  defp shouting(input) do
    Regex.match?(~r/^.*[[:upper:]]+.*$/u, input) and input === String.upcase(input)
  end

  defp silence(input) do
    Regex.match?(~r/^\s*$/u, input)
  end
end
