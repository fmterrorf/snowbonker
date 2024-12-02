defmodule SnowbonkerWeb.SnowcrewLive.Index do
  alias Snowbonker.Plows
  alias Phoenix.PubSub
  use SnowbonkerWeb, :live_view

  @plow_names Application.app_dir(:snowbonker, "priv/plow_names.csv")
              |> File.stream!()
              |> Stream.drop(1)
              |> Stream.map(fn item ->
                item = String.trim(item, "\n")

                case String.split(item, ",") do
                  [id, ""] -> {id, nil}
                  [id, label] -> {id, label}
                end
              end)
              |> Map.new()

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      PubSub.subscribe(Snowbonker.PubSub, "location_update")
    end

    {:ok, socket, layout: {SnowbonkerWeb.Layouts, :map}}
  end

  @impl true
  def handle_info(:location_update, socket) do
    {:noreply,
     socket
     |> push_event("locations", %{locations: fetch_plow_list()})}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Plows")
    |> push_event("locations", %{locations: fetch_plow_list()})
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id="map" phx-update="ignore" phx-hook="Map"></div>
    <div
      id="map_tool_tip"
      class="top-2 right-3 text-sm rounded-lg p-1 bg-brand/5 text-brand rounded-full font-medium leading-6 cursor-pointer"
      phx-click={JS.navigate("https://github.com/fmterrorf/snowbonker")}
    >
      <.icon name="hero-question-mark-circle" class="h-10 w-10" />
    </div>
    """
  end

  def fetch_plow_list() do
    Plows.list_locations()
    |> location_ui_to_map()
  end

  def location_ui_to_map(locations) do
    Enum.map(locations, &Map.take(&1, [:id, :location, :rotation]))
    |> Enum.map(&add_label/1)
  end

  defp add_label(location) do
    Map.put(location, :label, @plow_names[location.id])
  end
end
