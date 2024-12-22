defmodule KanbanWeb.Resolvers.TaskResolver do
  alias Kanban.Tasks

  def list_tasks(_parent, args, _resolution) do
    case Tasks.list_tasks(%{
           "page" => Integer.to_string(args[:page] || 1),
           "page_size" => Integer.to_string(args[:page_size] || 10),
           "priority" => args[:priority],
           "execution_location" => args[:execution_location],
           "execution_date" => args[:execution_date],
           "name" => args[:name],
           "description" => args[:description],
         }) do
      {:ok, tasks, _pagination, _offset} ->
        tasks = Enum.map(tasks, fn task ->
          updated_files = if task.files do
            Kanban.Task.url({task.files, task})  # Gera a URL do arquivo
          else
            nil
          end

          # Atualiza o campo `files` com a URL gerada (ou nil, se não houver arquivo)
          Map.put(task, :files, updated_files)
        end)

        {:ok, tasks}

      {:error, :not_found} ->
        {:ok, []}
    end
  end

  def show_task(_parent, %{id: id}, _resolution) do
    case Tasks.show(id) do
      {:error, :not_found} ->
        {:error, "Task not found"}

      {:ok, task} ->
        updated_task =
          case task.files do
            nil -> Map.put(task, :files, nil)
            %{} = file_map ->
              file_url = Kanban.Task.url({file_map, task})
              Map.put(task, :files, file_url)
            _ -> Map.put(task, :files, nil)
          end

        {:ok, updated_task}
    end
  end
end
