defmodule FreelaReports.Parser do
  def parse_file(filename) do
    "reports/#{filename}"
    |> File.stream!()
    |> Enum.map(fn line -> parse_line(line) end)
  end

  defp parse_line(line) do
    line
    |> String.trim()
    |> String.split(",")
    |> parse_fields()
  end

  defp parse_fields(line) do
    line
    |> List.update_at(1, &String.to_integer(&1))
    |> List.update_at(2, &String.to_integer(&1))
    |> List.update_at(3, &parse_month(&1))
  end

  defp parse_month("1"), do: "janeiro"
  defp parse_month("2"), do: "fevereiro"
  defp parse_month("3"), do: "março"
  defp parse_month("4"), do: "abril"
  defp parse_month("5"), do: "maio"
  defp parse_month("6"), do: "junho"
  defp parse_month("7"), do: "julho"
  defp parse_month("8"), do: "agosto"
  defp parse_month("9"), do: "setembro"
  defp parse_month("10"), do: "outubro"
  defp parse_month("11"), do: "novembro"
  defp parse_month("12"), do: "dezembro"
end
