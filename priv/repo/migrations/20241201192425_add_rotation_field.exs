defmodule Snowbonker.Repo.Migrations.AddRotationField do
  use Ecto.Migration

  def change do
    alter table(:locations) do
      add :rotation, :integer, default: 0
    end
  end
end
