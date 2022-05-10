defmodule WordCountTask do
  @moduledoc """
    This is module Word Count Task.
    This get a list and word frequency using 
    process and task to manage computer memory
  """
  def frequencies_tasks(path) do
    map_in_parts =
      path
      |> File.stream!()
      |> Enum.chunk_every(1_000)
      |> Enum.map(fn lines -> Task.async(fn -> word_count(Enum.join(lines)) end) end)
      |> Enum.map(fn task -> Task.await(task) end)

    # Join the maps
    Enum.reduce(map_in_parts, %{}, fn map, acc ->
      Map.merge(map, acc, fn _k, word1, word2 ->
        word1 + word2
      end)
    end)
  end

  def word_count(archivo) do
    texto =
      String.downcase(archivo)
      |> String.normalize(:nfd)
      |> String.replace(~r/[^a-z0-9\s]/, "")
      |> String.replace("\n", " ")
      |> String.split(" ")
      |> Enum.reduce(%{}, fn x, y -> Map.update(y, x, 1, fn x -> x + 1 end) end)
  end
end
