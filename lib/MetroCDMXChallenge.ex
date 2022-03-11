defmodule MetroCDMXChallenge do
    import SweetXml

    defmodule Line do
     defstruct [:name, :stations]
    end

    defmodule Station do
     defstruct [:name, :coords]
    end
   
    def metro_lineas(xml_path) do

        xml = File.read!(xml_path)
        nombre_linea = xml |> xpath(~x"//Document/Folder[1]/Placemark/name/text()"l) |> Enum.map(fn l -> List.to_string(l) end)
        nombre_coor1 = xml |> xpath(~x"//Document/Folder[1]/Placemark/LineString/coordinates/text()"l) |> Enum.map(fn l -> List.to_string(l) 
                |> String.trim() 
                |> String.replace(" ","") 
                |> String.split("\n")
               end) 
        nombre_estacion = xml |> xpath(~x"//Document/Folder[2]/Placemark/name/text()"l) |> Enum.map(fn l -> List.to_string(l) end)
        nombre_coor2 = xml |> xpath(~x"//Document/Folder[2]/Placemark/Point/coordinates/text()"l) |> Enum.map(fn l -> List.to_string(l) 
                |> String.trim() 
                |> String.replace(" ","") 
                |> String.split("\n") 
               end) 
        estacion_coor = Enum.zip(nombre_coor2, nombre_estacion) |> Map.new()       
        linea_coor = Enum.zip(nombre_linea, nombre_coor1) |> Map.new()  

        lineas = linea_coor |> Enum.map(fn {k, v} -> Enum.map(v, fn x -> %Line{name: k, stations: %Station{name: estacion_coor[[x]], coords: x} } end) end)    

    end 

    def metro_graph(xml_path) do
    
        lineas = metro_lineas(xml_path)
        
        estaciones = lineas |> Enum.map(fn x -> x |> Enum.map(fn y -> y.stations.name end) end) 
        separar =  estaciones |> Enum.map(fn x -> x |> Enum.chunk_every(2, 1, :discard) end)
        s = List.flatten(separar) |> Enum.chunk_every(2)
        g = Graph.new(type: :undirected) 
        Enum.reduce(s, g, fn z, g ->  Graph.add_edge(g, List.first(z), List.last(z)) end) 

    end
end