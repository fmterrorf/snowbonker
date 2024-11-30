defmodule Snowbonker.PlowsTest do
  use Snowbonker.DataCase

  alias Snowbonker.Plows

  describe "locations" do
    test "batch_insert/1 inserts plows" do
      Plows.batch_insert([
        %{id: "hello", location: [0.0, 0.0]},
        %{id: "hello", location: [0.0, 0.1]}
      ])
      |> dbg

      Plows.list_locations()
    end

    # test "list_locations/0 returns all locations" do
    #   location = location_fixture()
    #   assert Plows.list_locations() == [location]
    # end

    # test "get_location!/1 returns the location with given id" do
    #   location = location_fixture()
    #   assert Plows.get_location!(location.id) == location
    # end

    # test "create_location/1 with valid data creates a location" do
    #   valid_attrs = %{locations: ["option1", "option2"]}

    #   assert {:ok, %Location{} = location} = Plows.create_location(valid_attrs)
    #   assert location.locations == ["option1", "option2"]
    # end

    # test "create_location/1 with invalid data returns error changeset" do
    #   assert {:error, %Ecto.Changeset{}} = Plows.create_location(@invalid_attrs)
    # end

    # test "update_location/2 with valid data updates the location" do
    #   location = location_fixture()
    #   update_attrs = %{locations: ["option1"]}

    #   assert {:ok, %Location{} = location} = Plows.update_location(location, update_attrs)
    #   assert location.locations == ["option1"]
    # end

    # test "update_location/2 with invalid data returns error changeset" do
    #   location = location_fixture()
    #   assert {:error, %Ecto.Changeset{}} = Plows.update_location(location, @invalid_attrs)
    #   assert location == Plows.get_location!(location.id)
    # end

    # test "delete_location/1 deletes the location" do
    #   location = location_fixture()
    #   assert {:ok, %Location{}} = Plows.delete_location(location)
    #   assert_raise Ecto.NoResultsError, fn -> Plows.get_location!(location.id) end
    # end

    # test "change_location/1 returns a location changeset" do
    #   location = location_fixture()
    #   assert %Ecto.Changeset{} = Plows.change_location(location)
    # end
  end
end
