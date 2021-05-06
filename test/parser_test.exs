defmodule FreelaReport.ParserTest do
  use ExUnit.Case
  alias FreelaReports.Parser

  describe "parse_file/1" do
    test "given a filename, should parse the file" do
      filename = "sample.csv"

      response =
        filename
        |> Parser.parse_file()
        |> Enum.map(& &1)

      expected = [
        ["Daniele", 7, 29, "abril", "2018"],
        ["Mayk", 4, 9, "dezembro", "2019"],
        ["Daniele", 5, 27, "dezembro", "2016"],
        ["Mayk", 1, 2, "dezembro", "2017"],
        ["Giuliano", 3, 13, "fevereiro", "2017"],
        ["Cleiton", 1, 22, "junho", "2020"],
        ["Giuliano", 6, 18, "fevereiro", "2019"],
        ["Jakeliny", 8, 18, "julho", "2017"],
        ["Joseph", 3, 17, "março", "2017"],
        ["Jakeliny", 6, 23, "março", "2019"],
        ["Cleiton", 3, 20, "junho", "2016"],
        ["Daniele", 5, 1, "maio", "2016"],
        ["Giuliano", 1, 2, "abril", "2020"],
        ["Daniele", 3, 5, "maio", "2017"],
        ["Daniele", 1, 26, "junho", "2020"],
        ["Diego", 3, 11, "setembro", "2016"],
        ["Mayk", 7, 28, "julho", "2017"],
        ["Mayk", 7, 3, "setembro", "2016"],
        ["Danilo", 6, 28, "fevereiro", "2019"],
        ["Diego", 4, 15, "agosto", "2017"]
      ]

      assert response == expected
    end
  end
end
