defmodule Kanban.Tasks.Task do
  use Ecto.Schema
  use Waffle.Ecto.Schema
  import Ecto.Changeset

  @required_params_create [:name, :execution_date, :status, :execution_location, :priority, :description, :attachments, :files]
  @priorities [:low, :high, :critical]
  @execution_locations [:remote, :office, :client_site, :hybrid]
  @statuses [:to_do, :in_progress, :finished]

  schema "tasks" do
    field :name, :string
    field :priority, Ecto.Enum, values: @priorities
    field :status, Ecto.Enum, values: @statuses
    field :description, :string
    field :execution_date, :date
    field :execution_location, Ecto.Enum, values: @execution_locations
    field :attachments, {:array, :string}, default: []
    field :files, Kanban.Task.Type

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params_create)
    |> do_validations(@required_params_create)
  end

  defp do_validations(changeset, fields) do
    changeset
    |> validate_required(fields)
    |> validate_length(:name, min: 3)
    |> validate_length(:name, max: 255)
    |> validate_length(:description, min: 3)
    |> validate_inclusion(:priority, @priorities)
    |> validate_inclusion(:execution_location, @execution_locations)
    |> validate_inclusion(:status, @statuses)
    # |> validate_length(:description, max: 255)
  end
end
