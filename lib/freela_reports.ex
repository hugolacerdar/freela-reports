defmodule FreelaReports do
  alias FreelaReports.Parser

  @years ["2016", "2017", "2018", "2019", "2020"]
  @months [
    "janeiro",
    "fevereiro",
    "março",
    "abril",
    "maio",
    "junho",
    "julho",
    "agosto",
    "setembro",
    "outubro",
    "novembro",
    "dezembro"
  ]
  @freelancers [
    "Cleiton",
    "Daniele",
    "Danilo",
    "Diego",
    "Giuliano",
    "Jakeliny",
    "Joseph",
    "Mayk",
    "Rafael",
    "Vinicius"
  ]

  def build(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.reduce(report_acc(), fn line, report -> sum_values(line, report) end)
  end

  def build_from_many(filenames) when not is_list(filenames) do
    {:error, "Invalid: a list of strings is required"}
  end

  def build_from_many(filenames) do
    result =
      filenames
      |> Task.async_stream(&build/1)
      |> Enum.reduce(report_acc(), fn {:ok, result}, report -> sum_reports(report, result) end)

    {:ok, result}
  end

  defp sum_reports(
         %{
           "all_hours" => all_hours1,
           "hours_per_month" => hours_per_month1,
           "hour_per_year" => hours_per_year1
         },
         %{
           "all_hours" => all_hours2,
           "hours_per_month" => hours_per_month2,
           "hour_per_year" => hours_per_year2
         }
       ) do
    all_hours = merge_maps(all_hours1, all_hours2, 1)

    hours_per_month = merge_maps(hours_per_month1, hours_per_month2, 2)

    hours_per_year = merge_maps(hours_per_year1, hours_per_year2, 2)

    build_report(all_hours, hours_per_month, hours_per_year)
  end

  defp merge_maps(map1, map2, sum_at) when sum_at == 1 do
    Map.merge(map1, map2, fn _key, value1, value2 -> value1 + value2 end)
  end

  defp merge_maps(map1, map2, sum_at) when sum_at == 2 do
    Map.merge(map1, map2, fn _key, value1, value2 -> merge_maps(value1, value2, 1) end)
  end

  defp sum_values([worker, hours, _day, month, year], %{
         "all_hours" => all_hours,
         "hours_per_month" => hours_per_month,
         "hour_per_year" => hours_per_year
       }) do
    all_hours = Map.put(all_hours, worker, all_hours[worker] + hours)

    update_hours_per_month =
      Map.put(hours_per_month[worker], month, hours_per_month[worker][month] + hours)

    hours_per_month = Map.put(hours_per_month, worker, update_hours_per_month)

    update_hours_per_year =
      Map.put(hours_per_year[worker], year, hours_per_year[worker][year] + hours)

    hours_per_year = Map.put(hours_per_year, worker, update_hours_per_year)

    build_report(all_hours, hours_per_month, hours_per_year)
  end

  def report_acc do
    all_hours = Enum.into(@freelancers, %{}, &{&1, 0})
    hours_per_month = Enum.into(@freelancers, %{}, &{&1, months_map()})
    hours_per_year = Enum.into(@freelancers, %{}, &{&1, years_map()})

    build_report(all_hours, hours_per_month, hours_per_year)
  end

  defp build_report(all_hours, hours_per_month, hours_per_year) do
    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hour_per_year" => hours_per_year
    }
  end

  defp months_map, do: Enum.into(@months, %{}, &{&1, 0})
  defp years_map, do: Enum.into(@years, %{}, &{&1, 0})
end
