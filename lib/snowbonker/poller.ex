defmodule Snowbonker.Poller do
  @moduledoc """
  Polls for the location of snow plows
  """
  alias Snowbonker.Plows
  alias Phoenix.PubSub

  @plow_names %{
    "23224" => "Scoop dog",
    "23225" => "Sled Zepplin",
    "23226" => "Snobi One Kenobi"
  }

  use GenServer

  @poll_interval :timer.minutes(20)

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_init_arg) do
    # locations = get_locations!()
    # Process.send_after(self(), :poll, @poll_interval)
    send(self(), :poll)
    {:ok, nil}
  end

  def handle_info(:poll, state) do
    get_locations!()
    |> Plows.batch_insert()
    Process.send_after(self(), :poll, @poll_interval)
    PubSub.broadcast!(Snowbonker.PubSub, "location_update", :location_update)
    {:noreply, state}
  end

  @service_vehicle_endpoint "https://hotline.gov.sk.ca/map/mapIcons/ServiceVehicles"
  def get_locations!() do
    Req.get!(@service_vehicle_endpoint).body["item2"]
    |> Enum.map(fn item ->
      %{
        id: item["itemId"],
        location: item["location"],
        label: @plow_names[item["itemId"]]
      }
    end)
  end
end
