defmodule InvoiceValidatorTest do
    use ExUnit.Case
    import InvoiceValidator
    Calendar.put_time_zone_database(Tzdata.TimeZoneDatabase)  

    @pacdate DateTime.from_naive!(~N[2022-03-23 15:06:35], "Mexico/General")

    data = [
        {"72 hrs before",    "Mexico/BajaNorte", ~N[2022-03-20 13:06:31], "{:error, Invoice was issued more than 72 hrs before received by the PAC}"},
        {"72 hrs before",	"Mexico/BajaSur", ~N[2022-03-20 14:06:31], "{:error, Invoice was issued more than 72 hrs before received by the PAC}" },
        {"72 hrs before",	"Mexico/General", ~N[2022-03-20 15:06:31], "{:error, Invoice was issued more than 72 hrs before received by the PAC}" },
        {"72 hrs before",	"America/Cancun", ~N[2022-03-20 16:06:31], "{:error, Invoice was issued more than 72 hrs before received by the PAC}" },
        {"72 hrs before",	"Mexico/BajaNorte", ~N[2022-03-20 14:06:35], ":ok"},
        {"72 hrs before",	"Mexico/BajaSur", ~N[2022-03-20 14:06:35], ":ok"},
        {"72 hrs before",	"Mexico/General", ~N[2022-03-20 15:06:35], ":ok"},
        {"72 hrs before",	"America/Cancun", ~N[2022-03-20 16:06:35], ":ok"},
        {"5 mns after",	"Mexico/BajaNorte", ~N[2022-03-23 13:11:35], ":ok"},
        {"5 mns after",	"Mexico/BajaSur", ~N[2022-03-23 14:11:35], ":ok"},
        {"5 mns after",	"Mexico/General", ~N[2022-03-23 15:11:35], ":ok"},
        {"5 mns after",	"America/Cancun", ~N[2022-03-23 16:11:35], ":ok"},
        {"5 mns after",	"Mexico/BajaNorte", ~N[2022-03-23 14:11:36], "{:error, Invoice is more than 5 mins ahead in time}"},
        {"5 mns after",	"Mexico/BajaSur", ~N[2022-03-23 14:11:36], "{:error, Invoice is more than 5 mins ahead in time}"},
        {"5 mns after",	"Mexico/General", ~N[2022-03-23 15:11:36], "{:error, Invoice is more than 5 mins ahead in time}"},
        {"5 mns after",	"America/Cancun", ~N[2022-03-23 16:11:36], "{:error, Invoice is more than 5 mins ahead in time}"}        
    ]

    for {instruction, zona, hour, ouput} <- data do
        @a instruction
        @b zona
        @c hour
        @d ouput 

        test "#{@a}, emisor in #{@b} at #{@c} returns #{@d}" do 
           if @a == "5 mns after" do
               if @d == "{:error, Invoice is more than 5 mins ahead in time}" do
                   assert {:error, "Invoice is more than 5 mins ahead in time"} == InvoiceValidator.validate_dates(datetime(@c, @b), @pacdate)
               else 
                   assert :ok == InvoiceValidator.validate_dates(datetime(@c, @b), @pacdate)
               end
           end
           if @a == "72 hrs before" do 
               if @d == "{:error, Invoice was issued more than 72 hrs before received by the PAC}" do
                   assert {:error, "Invoice was issued more than 72 hrs before received by the PAC"} == InvoiceValidator.validate_dates(datetime(@c, @b), @pacdate)
               else 
                   assert :ok == InvoiceValidator.validate_dates(datetime(@c, @b), @pacdate)
               end
           end
        end
    end

    defp datetime(%NaiveDateTime{} = ndt, tz) do
        DateTime.from_naive!(ndt, tz)
    end
end    

