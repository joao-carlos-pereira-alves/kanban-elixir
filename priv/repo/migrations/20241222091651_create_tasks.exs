defmodule Kanban.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :name, :string
      add :execution_date, :date
      add :execution_location, :string
      add :priority, :string, default: "low"
      add :description, :text
      add :attachments, {:array, :string}, default: []

      timestamps(type: :utc_datetime)
    end
  end
end
