defmodule SnowbonkerWeb.SnowcrewLive.Index do
  alias Snowbonker.Plows
  alias Phoenix.PubSub
  use SnowbonkerWeb, :live_view

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
     |> push_event("locations", %{locations: Plows.list_locations()})}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Plows")
    |> push_event("locations", %{locations: Plows.list_locations()})
  end

  @impl true
  def render(assigns) do
    ~H|<div id="map" phx-update="ignore" phx-hook="Map"></div>|
  end
end
