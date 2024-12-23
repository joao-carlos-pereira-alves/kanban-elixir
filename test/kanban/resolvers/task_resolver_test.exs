defmodule Kanban.Resolvers.TaskResolverTest do
  use KanbanWeb.ConnCase, async: true

  alias Kanban.Tasks
  alias Kanban.Tasks.Task

  @valid_attrs %{
    name: "Tarefa 1",
    priority: :high,
    description: "Descrição da tarefa",
    execution_date: ~D[2024-12-24],
    execution_location: "remote",
    status: "to_do",
    files: [
      %{file_name: "example_image.jpeg", updated_at: ~N[2024-12-23 14:17:33]},
      %{file_name: "example_pdf.pdf", updated_at: ~N[2024-12-23 14:17:33]}
    ]
  }

  setup do
    {:ok, task} = Tasks.create(@valid_attrs)
    {:ok, task: task}
  end

  test "getTask query returns a single task with processed files", %{task: task} do
    query = """
    query GetTask($id: ID!) {
      task(id: $id) {
        id
        name
        files {
          url
          filename
        }
      }
    }
    """

    variables = %{"id" => "#{task.id}"}

    conn = build_conn()
    response = post(conn, "/api/graphql", %{query: query, variables: variables})

    task_result = json_response(response, 200)["data"]["task"]

    assert task_result["id"] == "#{task.id}"
    assert task_result["name"] == task.name
    assert length(task_result["files"]) == 2

    assert Enum.all?(task_result["files"], fn file ->
             file["url"] != nil && file["filename"] != nil
           end)
  end

  test "tasks query returns a list of tasks with processed files", %{task: task} do
    {:ok, task2} =
      %{
        name: "Tarefa 2",
        priority: :low,
        status: :to_do,
        description: "Descrição da tarefa 2",
        execution_date: ~D[2024-12-25],
        execution_location: "remote",
        attachments: [],
        files: [
          %{file_name: "example_image2.jpeg", updated_at: ~N[2024-12-23 14:17:33]},
          %{file_name: "example_pdf2.pdf", updated_at: ~N[2024-12-23 14:17:33]}
        ]
      }
      |> Tasks.create()

    query = """
    query GetTasks($pageSize: Int, $page: Int) {
      tasks(pageSize: $pageSize, page: $page) {
        pagination {
          page
          perPage
          totalItems
        }
        tasks {
          id
          name
          files {
            url
            filename
          }
        }
      }
    }
    """

    conn = build_conn()
    # Aqui você pode passar as variáveis de página e tamanho
    variables = %{"pageSize" => 10, "page" => 1}

    response = post(conn, "/api/graphql", %{query: query, variables: variables})

    tasks = json_response(response, 200)["data"]["tasks"]["tasks"]

    # Verificando se a primeira tarefa foi retornada
    assert Enum.any?(tasks, fn t ->
      t["id"] == "#{task.id}" && t["name"] == task.name
    end)

    # Verificando se a segunda tarefa foi retornada
    assert Enum.any?(tasks, fn task ->
             task["id"] == "#{task2.id}" && task["name"] == task2.name
           end)

    # Verificando se os arquivos da primeira tarefa estão corretos
    assert Enum.any?(tasks, fn t ->
             t["id"] == "#{task.id}" &&
               Enum.any?(t["files"], fn file -> file["filename"] == "example_image.jpeg" end) &&
               Enum.any?(t["files"], fn file -> file["filename"] == "example_pdf.pdf" end)
           end)

    # Verificando se os arquivos da segunda tarefa estão corretos
    assert Enum.any?(tasks, fn t ->
             t["id"] == "#{task2.id}" &&
               Enum.any?(t["files"], fn file -> file["filename"] == "example_image2.jpeg" end) &&
               Enum.any?(t["files"], fn file -> file["filename"] == "example_pdf2.pdf" end)
           end)
  end

  test "tasks query returns a list of tasks with processed files and pagination", %{task: task} do
    {:ok, task2} =
      %{
        name: "Tarefa 2",
        priority: :low,
        status: :to_do,
        description: "Descrição da tarefa 2",
        execution_date: ~D[2024-12-25],
        execution_location: "remote",
        attachments: [],
        files: [
          %{file_name: "example_image2.jpeg", updated_at: ~N[2024-12-23 14:17:33]},
          %{file_name: "example_pdf2.pdf", updated_at: ~N[2024-12-23 14:17:33]}
        ]
      }
      |> Tasks.create()

    query = """
    query GetTasks($pageSize: Int, $page: Int) {
      tasks(pageSize: $pageSize, page: $page) {
        pagination {
          page
          perPage
          totalItems
        }
        tasks {
          id
          name
          files {
            url
            filename
          }
        }
      }
    }
    """

    conn = build_conn()
    variables = %{"pageSize" => 1, "page" => 1}
    response = post(conn, "/api/graphql", %{query: query, variables: variables})

    tasks = json_response(response, 200)["data"]["tasks"]["tasks"]
    pagination = json_response(response, 200)["data"]["tasks"]["pagination"]

    assert Enum.any?(tasks, fn t -> t["id"] == "#{task.id}" && t["name"] == task.name end)

    assert Enum.any?(tasks, fn t ->
             t["id"] == "#{task.id}" &&
               Enum.any?(t["files"], fn file -> file["filename"] == "example_image.jpeg" end) &&
               Enum.any?(t["files"], fn file -> file["filename"] == "example_pdf.pdf" end)
           end)

    assert pagination["page"] == 1
    assert pagination["perPage"] == 1
    assert pagination["totalItems"] == 2
  end
end
