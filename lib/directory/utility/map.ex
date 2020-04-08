defmodule Directory.Utility.Map do
  @moduledoc """
  Map utility
  """

  def to_map(struct) when is_struct(struct) do
    struct
    |> Map.keys()
    |> List.delete(:__struct__)
    |> Enum.into(%{}, fn key ->
      {key, struct |> Map.get(key) |> to_map()}
    end)
  end

  def to_map(list) when is_list(list), do: Enum.map(list, &to_map/1)
  def to_map({key, value}), do: {to_map(key), to_map(value)}
  def to_map(value), do: value

  def dig(struct, path) when is_struct(struct) and is_list(path) do
    struct
    |> to_map()
    |> dig(path)
  end

  def dig(map, path) when is_map(map) and is_list(path) do
    get_in(map, path)
  rescue
    _ -> nil
  end
end
