defmodule InvoiceValidator do
  @moduledoc """
    This is InvoiceValidator.
    This module is commissioned from compare two dates with an interval of 72 hours,
    the first date is emisor_date and the second date is pac_date,
    each with time zone different. 
  """
  def validate_dates(%DateTime{} = emisor_date, %DateTime{} = pac_date) do
    difm = DateTime.diff(emisor_date, pac_date) / 60
    difh = DateTime.diff(pac_date, emisor_date) / 60 / 60

    case DateTime.compare(emisor_date, pac_date) do
      :eq ->
        :ok

      :gt ->
        if difm <= 5 do
          :ok
        else
          {:error, "Invoice is more than 5 mins ahead in time"}
        end

      :lt ->
        if difh <= 72 do
          :ok
        else
          {:error, "Invoice was issued more than 72 hrs before received by the PAC"}
        end
    end
  end
end
