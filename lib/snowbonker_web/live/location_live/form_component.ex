defmodule SnowbonkerWeb.LocationLive.FormComponent do
  use SnowbonkerWeb, :live_component

  alias Snowbonker.Plows

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Name your plow</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="location-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:label]} label="Label"/>
        <:actions>
          <.button phx-disable-with="Saving...">Save Location</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{location: location} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Plows.change_location(location))
     end)}
  end

  @impl true
  def handle_event("validate", %{"location" => location_params}, socket) do
    changeset = Plows.change_location(socket.assigns.location, location_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"location" => location_params}, socket) do
    save_location(socket, socket.assigns.action, location_params)
  end

  defp save_location(socket, :edit, location_params) do
    case Plows.update_location(socket.assigns.location, location_params) do
      {:ok, location} ->
        notify_parent({:saved, location})

        {:noreply,
         socket
         |> put_flash(:info, "Location updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_location(socket, :new, location_params) do
    case Plows.create_location(location_params) do
      {:ok, location} ->
        notify_parent({:saved, location})

        {:noreply,
         socket
         |> put_flash(:info, "Location created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
