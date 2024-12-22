defmodule Kanban.TasksTest do
  use Kanban.DataCase

  alias Kanban.Tasks

  describe "tasks" do
    alias Kanban.Tasks.Task

    import Kanban.TasksFixtures

    @invalid_attrs %{name: nil, priority: nil, description: nil, execution_date: nil, execution_location: nil, attachments: nil}

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Tasks.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Tasks.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      valid_attrs = %{name: "some name", priority: "some priority", description: "some description", execution_date: ~D[2024-12-21], execution_location: "some execution_location", attachments: "some attachments"}

      assert {:ok, %Task{} = task} = Tasks.create_task(valid_attrs)
      assert task.name == "some name"
      assert task.priority == "some priority"
      assert task.description == "some description"
      assert task.execution_date == ~D[2024-12-21]
      assert task.execution_location == "some execution_location"
      assert task.attachments == "some attachments"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      update_attrs = %{name: "some updated name", priority: "some updated priority", description: "some updated description", execution_date: ~D[2024-12-22], execution_location: "some updated execution_location", attachments: "some updated attachments"}

      assert {:ok, %Task{} = task} = Tasks.update_task(task, update_attrs)
      assert task.name == "some updated name"
      assert task.priority == "some updated priority"
      assert task.description == "some updated description"
      assert task.execution_date == ~D[2024-12-22]
      assert task.execution_location == "some updated execution_location"
      assert task.attachments == "some updated attachments"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Tasks.update_task(task, @invalid_attrs)
      assert task == Tasks.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Tasks.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Tasks.change_task(task)
    end
  end
end
