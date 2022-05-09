defmodule MyList do 

    #Funcion each
    def each([x], fun) do
        [h | _] = [x]
        fun.(h)
    end
    def each([h | t], fun) do
        IO.puts(fun.(h))
        each(t, fun)
    end

    #Funcion map 
    def map([], _), do: []
    def map([h | t], fun), do: [fun.(h) | map(t,fun)]

    #Funcion zip 
    def zip([], _), do: []
    def zip(_, []), do: []
    def zip([h | t],[h1 | t1]), do: [{h, h1} | zip(t,t1)]

    #Funcion zip_with
    def zip_with([],_, fun), do: []
    def zip_with(_,[], fun), do: []
    def zip_with([h | t],[h1 | t1], fun), do: [fun.(h,h1) | zip_with(t, t1, fun)]

    #Funcion reduce
    def reduce([], acc, _), do: acc
    def reduce([h|t], acc, fun), do: reduce(t, fun.(h, acc), fun)

end



defmodule CardGameWar.Game do

  # feel free to use these cards or use your own data structure"
  def suits, do: [:spade, :club, :diamond, :heart]
  def ranks, do: [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace]
  def cards do
    for suit <- suits,
        rank <- ranks do
      {suit, rank}
    end
  end

end