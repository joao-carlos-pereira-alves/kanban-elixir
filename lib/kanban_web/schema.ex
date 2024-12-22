defmodule KanbanWeb.Schema do
  use Absinthe.Schema

  alias KanbanWeb.Resolvers.TaskResolver

  query do
    @desc "Listagem de tarefas com paginação e filtros"
    field :tasks, list_of(:task) do
      arg :page, :integer, default_value: 1
      arg :page_size, :integer, default_value: 10
      arg :priority, :string, default_value: nil
      arg :execution_location, :string, default_value: nil
      arg :execution_date, :string, default_value: nil
      arg :name, :string, default_value: nil
      arg :description, :string, default_value: nil

      resolve &TaskResolver.list_tasks/3
    end

    @desc "Busca uma tarefa pelo ID"
    field :task, :task do
      arg :id, non_null(:id)
      resolve &TaskResolver.show_task/3
    end
  end

  object :task do
    field :id, :id
    field :name, :string
    field :priority, :string
    field :description, :string
    field :execution_date, :string
    field :execution_location, :string
    field :attachments, list_of(:string)
    field :files, list_of(:string)
    field :inserted_at, :string
    field :updated_at, :string
  end
end
