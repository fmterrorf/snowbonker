defmodule SnowbonkerWeb.LocationLive.Index do
  use SnowbonkerWeb, :live_view

  alias Snowbonker.Plows

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :locations, Plows.list_locations())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Location")
    |> assign(:location, Plows.get_location!(id))
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Locations")
    |> assign(:location, nil)
  end

  @impl true
  def handle_info({SnowbonkerWeb.LocationLive.FormComponent, {:saved, location}}, socket) do
    {:noreply, stream_insert(socket, :locations, location)}
  end
end
