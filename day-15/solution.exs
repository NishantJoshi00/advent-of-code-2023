defmodule Solve do
  def print(x) do
    IO.puts(x)
    x
  end

  def input() do
    IO.gets("") |> String.trim() |> String.split(",")
  end

  def solve_one([], old) do
    old
  end

  def solve_one([hd | rest], old) do
    solve_one(rest, one_op(hd, old))
  end

  def one_op(var, current) do
    rem(((var |> String.to_charlist() |> hd) + current) * 17, 256)
  end

  def solve_one(word) do
    word |> String.graphemes() |> solve_one(0)
  end

  def solve(value) do
    value |> Enum.map(&solve_one(&1)) |> Enum.sum()
  end
end

Solve.input() |> Solve.solve() |> IO.puts()
