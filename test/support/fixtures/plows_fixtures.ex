defmodule Snowbonker.PlowsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Snowbonker.Plows` context.
  """

  @doc """
  Generate a location.
  """
  def location_fixture(attrs \\ %{}) do
    {:ok, location} =
      attrs
      |> Enum.into(%{
        location: [1.0, 2.0]
      })
      |> Snowbonker.Plows.create_location()

    location
  end
end
