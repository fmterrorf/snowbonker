defmodule Snowbonker.Plows.Location do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, except: [:__meta__]}
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "locations" do
    field(:location, {:array, :float})
    field(:label, :string)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [:label])
    |> validate_required([:label])
    |> validate_length(:label, max: 20)
  end
end
