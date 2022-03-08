defmodule MyListTest do 
    use ExUnit.Case
    import ExUnit.CaptureIO

    test "test map" do
        assert MyList.map([2, 3, 4], fn x -> x-1 end) == [1, 2, 3]
    end

    test "test zip" do
        assert MyList.zip([1,2,3], [:a, :b, :c]) == [{1, :a}, {2, :b}, {3, :c}]
    end  

    test "zip_with" do 
        assert MyList.zip_with([2,4,6],[3,5,7], fn x, y -> x+y end) == [5, 9, 13]
    end
    
    test "test reduce" do
        assert MyList.reduce([5,10,15], 0, fn x, acc -> x + acc end) == 30
    end

    test "test each" do
        fun = fn -> assert MyList.each([1, 2, 3, 4], fn x -> x-1 end) == 3 end
        assert capture_io(fun) == "0\n1\n2\n"
    end
 end
    
