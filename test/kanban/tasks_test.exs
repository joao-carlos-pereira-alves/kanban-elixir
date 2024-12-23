defmodule Kanban.TaskTest do
  use Kanban.DataCase, async: true

  alias Kanban.Tasks
  alias Kanban.Tasks.Task

  @valid_attrs %{
    name: "Tarefa 1",
    priority: :high,
    description: "Descrição da tarefa",
    execution_date: ~D[2024-12-24],
    execution_location: :remote,
    status: :to_do,
    files: [
      %{file_name: "example_image.jpeg", updated_at: ~N[2024-12-23 14:17:33]},
      %{file_name: "example_pdf.pdf", updated_at: ~N[2024-12-23 14:17:33]}
    ]
  }

  test "creates a task with valid attributes" do
    {:ok, task} = Tasks.create(@valid_attrs)

    assert task.name == @valid_attrs[:name]
    assert task.priority == @valid_attrs[:priority]
    assert task.description == @valid_attrs[:description]
    assert task.execution_date == @valid_attrs[:execution_date]
    assert task.execution_location == @valid_attrs[:execution_location]
    assert task.status == @valid_attrs[:status]

    assert length(task.files) == 2
    assert Enum.any?(task.files, fn file -> file.file_name == "example_image.jpeg" end)
    assert Enum.any?(task.files, fn file -> file.file_name == "example_pdf.pdf" end)
  end
end
