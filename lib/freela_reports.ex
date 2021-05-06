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

    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hour_per_year" => hours_per_year
    }
  end

  def report_acc do
    all_hours = Enum.into(@freelancers, %{}, &{&1, 0})
    hours_per_month = Enum.into(@freelancers, %{}, &{&1, months_map()})
    hours_per_year = Enum.into(@freelancers, %{}, &{&1, years_map()})

    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hour_per_year" => hours_per_year
    }
  end

  defp months_map, do: Enum.into(@months, %{}, &{&1, 0})
  defp years_map, do: Enum.into(@years, %{}, &{&1, 0})
end
