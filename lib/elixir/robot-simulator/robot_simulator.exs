defmodule RobotSimulator do
  defguard is_valid_direction(direction) when direction in [:north, :east, :south, :west]

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create(direction \\ :north, {x, y} = position \\ {0, 0})
      when is_valid_direction(direction) and is_integer(x) and is_integer(y) do
    %{direction: direction, position: position}
  end

  def create(direction, _position)
      when is_valid_direction(direction) do
    {:error, "invalid position"}
  end

  def create(_direction, _position), do: {:error, "invalid direction"}

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: any, instructions :: String.t()) :: any
  def simulate(robot, instructions) do
    instructions
    |> String.to_charlist()
    |> Enum.reduce_while(robot, fn ins, acc ->
      case ins do
        ?R -> {:cont, turn_right(acc)}
        ?L -> {:cont, turn_left(acc)}
        ?A -> {:cont, advance(acc)}
        _ -> {:halt, {:error, "invalid instruction"}}
      end
    end)
  end

  defp turn_right(%{direction: direction} = robot) do
    next_dir =
      case direction do
        :north -> :east
        :east -> :south
        :south -> :west
        :west -> :north
        _ -> :north
      end

    %{robot | direction: next_dir}
  end

  defp turn_left(%{direction: direction} = robot) do
    next_dir =
      case direction do
        :north -> :west
        :west -> :south
        :south -> :east
        :east -> :north
        _ -> :north
      end

    %{robot | direction: next_dir}
  end

  defp advance(%{direction: direction, position: {x, y}} = robot) do
    next_pos =
      case direction do
        :north -> {x, y + 1}
        :east -> {x + 1, y}
        :south -> {x, y - 1}
        :west -> {x - 1, y}
      end

    %{robot | position: next_pos}
  end

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction(%{direction: direction}) do
    direction
  end

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position(%{position: position}) do
    position
  end
end
