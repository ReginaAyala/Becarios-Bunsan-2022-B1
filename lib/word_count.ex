defmodule WordCount do 
    def count(ruta) do 
        {:ok, archivo} = File.read(ruta)
        texto = String.downcase(archivo) |> String.normalize(:nfd) |> String.replace(~r/[^a-z0-9\s]/, "") 
                |> String.replace("\n", " ") |> String.split(" ") |> Enum.reduce(%{}, fn x, y -> Map.update(y, x, 1, fn x -> x+1 end) end)
    end 
end