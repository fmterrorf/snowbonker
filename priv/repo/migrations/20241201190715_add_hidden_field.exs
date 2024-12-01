defmodule Snowbonker.Repo.Migrations.AddHiddenField do
  use Ecto.Migration

  def change do
    alter table(:locations) do
      add :hidden, :boolean, default: false
    end
  end
end
