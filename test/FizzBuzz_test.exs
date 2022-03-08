defmodule FizzBuzzTest do 
    use ExUnit.Case
    import ExUnit.CaptureIO

    test "fizzbuzz" do 
        fun =  fn -> assert FizzBuzz.fizzbuzz(15) == :ok end 
        assert capture_io(fun) == "1\n2\nFizz\n4\nBuzz\nFizz\n7\n8\nFizz\nBuzz\n11\nFizz\n13\n14\nFizzBuzz\n"
    end
end

    

