defmodule Snowbonker.Plows do
  @moduledoc """
  The Plows context.
  """

  import Ecto.Query, warn: false
  alias Snowbonker.Repo

  alias Snowbonker.Plows.Location

  def list_locations do
    from(l in Location, where: l.hidden == false)
    |> Repo.all()
  end

  def get_location!(id), do: Repo.get!(Location, id)

  def create_location(attrs \\ %{}) do
    %Location{}
    |> Location.changeset(attrs)
    |> Repo.insert()
  end

  def update_location(%Location{} = location, attrs) do
    location
    |> Location.changeset(attrs)
    |> Repo.update()
  end

  def delete_location(%Location{} = location) do
    Repo.delete(location)
  end

  def change_location(%Location{} = location, attrs \\ %{}) do
    Location.changeset(location, attrs)
  end

  def batch_insert(locations) do
    now = date_now_sec()

    inserts =
      Enum.map(locations, fn item ->
        Map.merge(
          %{inserted_at: now, updated_at: now, hidden: false},
          Map.take(item, [:id, :location])
        )
      end)

    Snowbonker.Repo.insert_all(Location, inserts,
      on_conflict: {:replace_all_except, [:id, :inserted_at, :label]}
    )

    ids = Enum.map(locations, & &1.id)

    from(l in Location, where: l.id not in ^ids, update: [set: [hidden: true]])
    |> Snowbonker.Repo.update_all([])
  end

  defp date_now_sec() do
    DateTime.utc_now() |> DateTime.truncate(:second)
  end
end
