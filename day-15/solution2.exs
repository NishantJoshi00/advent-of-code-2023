defmodule Solve do
  def print(x) do
    IO.inspect(x)
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

  def maply(idx, data, map) do
    map |> Map.update(idx, [data], &update_list(&1, data))
  end

  def update_list(existing_list, new_element) do
    case Enum.find_index(existing_list, &(elem(new_element, 0) == elem(&1, 0))) do
      nil -> existing_list ++ [new_element]
      idx -> List.replace_at(existing_list, idx, new_element)
    end
  end

  def mremove(idx, data, map) do
    map |> Map.update(idx, [], &remove_list(&1, data))
  end

  def remove_list(list, element) do
    case Enum.find_index(list, &(elem(&1, 0) == element)) do
      nil -> list
      idx -> elem(List.pop_at(list, idx, 0), 1)
    end
  end

  def do_map(word, map) do
    case {String.contains?(word, "="), String.contains?(word, "-")} do
      {true, false} ->
        maply(
          solve_one(List.first(String.split(word, "="))),
          {
            List.first(String.split(word, "=")),
            List.last(String.split(word, "=")) |> String.to_integer()
          },
          map
        )

      {false, true} ->
        mremove(
          solve_one(List.first(String.split(word, "-"))),
          List.first(String.split(word, "-")),
          map
        )
    end
  end

  def solution([], map) do
    map
  end

  def solution([hd | rest], map) do
    solution(rest, do_map(hd, map))
  end

  def list_operate(list, box) do
    list
    |> Enum.with_index()
    |> Enum.map(fn {{_, el}, idx} -> (box + 1) * (idx + 1) * el end)
    |> Enum.sum()
  end

  def operate(map) do
    map |> Enum.map(fn {k, v} -> list_operate(v, k) end) |> Enum.sum()
  end
end

Solve.input() |> Solve.solution(%{}) |> Solve.operate() |> Solve.print()
