defmodule Kanban.TasksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Kanban.Tasks` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        attachments: "some attachments",
        description: "some description",
        execution_date: ~D[2024-12-21],
        execution_location: "some execution_location",
        name: "some name",
        priority: "some priority"
      })
      |> Kanban.Tasks.create_task()

    task
  end
end
