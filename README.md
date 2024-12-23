# Kanban API com Elixir

Este projeto consiste em uma API de um sistema Kanban desenvolvido com **Elixir**, utilizando o framework **Phoenix**, **GraphQL** (via Absinthe) e **PostgreSQL** (gerenciado com Ecto). O sistema permite listar tarefas (“tasks”), oferecendo funcionalidades como paginação, filtros por texto e anexação de arquivos.

## Decisões Técnicas

- **Framework**: O Phoenix foi escolhido pela sua integração robusta com GraphQL via Absinthe e suporte a sistemas de alta performance.
- **Banco de Dados**: PostgreSQL, devido à sua confiabilidade e recursos avançados.
- **Paginação**: Implementada para otimizar a consulta de grandes conjuntos de dados.
- **Validações**: Realizadas nos `changesets` do Ecto para garantir consistência dos dados (e.g., campos obrigatórios, valores permitidos para `status` e `priority`).
- **Anexos**: Cada tarefa pode ter um ou mais anexos associados.

## Estrutura das Entidades

### Schema: Task

```elixir
schema "tasks" do
  field :name, :string
  field :priority, Ecto.Enum, values: @priorities # Valores permitidos: "low", "high", "critical"
  field :status, Ecto.Enum, values: @statuses # Valores permitidos: "to_do", "in_progress", "finished"
  field :execution_date, :date
  field :description, :string
  field :execution_date, :date
  field :execution_location, Ecto.Enum, values: @execution_locations
  field :attachments, {:array, :string}, default: []
  field :files, {:array, Kanban.Task.Type}

  timestamps()
end
```

## Endpoints da API

A API disponibiliza um único endpoint GraphQL:

### Endpoint Base

```
POST http://localhost:4000/api/graphql
```

### Exemplos de Requisições

#### Listar Tasks (com paginação e filtros)

```graphql
query Tasks {
  tasks(page: 1, pageSize: 10) {
    pagination {
      page
      perPage
      totalItems
    }
    tasks {
      id
      name
      description
      priority
      status
      executionDate
      executionLocation
      insertedAt
      updatedAt
      attachments
      files {
        filename
        url
      }
    }
  }
}
```

#### Resposta:

```json
{
  "data": {
    "tasks": {
      "pagination": {
        "page": 1,
        "perPage": 10,
        "totalItems": 15
      },
      "tasks": [
        {
          "id": "1",
          "name": "Criar sistema de login",
          "description": "Desenvolver autenticação com JWT.",
          "priority": "critical",
          "status": "to_do",
          "executionDate": "2024-12-24",
          "executionLocation": "remote",
          "insertedAt": "2024-12-23T15:11:39Z",
          "updatedAt": "2024-12-23T15:11:39Z",
          "attachments": ["https://example.com/jwt_doc.pdf"],
          "files": [
            {
              "filename": "example_image.jpeg",
              "url": "http://localhost:4000/uploads/example_image.jpeg?v=63902185899"
            }
          ]
        }
      ]
    }
  }
}
```

#### Consultar Detalhes de uma Task

```graphql
query Task {
  task(id: "2") {
    id
    name
    description
    priority
    status
    executionDate
    executionLocation
    insertedAt
    updatedAt
    attachments
    files {
      filename
      url
    }
  }
}
```

#### Resposta:

```json
{
  "data": {
    "task": {
      "id": "2",
      "name": "Configurar banco de dados",
      "description": "Adicionar PostgreSQL com migrações.",
      "priority": "high",
      "status": "to_do",
      "executionDate": "2024-12-20",
      "executionLocation": "remote",
      "insertedAt": "2024-12-23T15:11:39Z",
      "updatedAt": "2024-12-23T15:11:39Z",
      "attachments": ["https://example.com/db_config.png"],
      "files": [
        {
          "filename": "example_image.jpeg",
          "url": "http://localhost:4000/uploads/example_image.jpeg?v=63902185899"
        }
      ]
    }
  }
}
```

## Instalação e Configuração

1. Clone o repositório:

```bash
git clone <URL_DO_REPOSITORIO>
cd <NOME_DO_REPOSITORIO>
```

2. Instale as dependências:

```bash
mix deps.get
```

3. Configure o Docker para subir o PostgreSQL:

```bash
docker-compose -f docker-compose.dev.yml up --build
```

4. Crie o banco de dados e rode as migrações:

```bash
mix ecto.setup
```

5. Inicie o servidor Phoenix:

```bash
mix phx.server
```

A API estará disponível em `http://localhost:4000`.

## Testes

Execute os testes com o seguinte comando:

```bash
mix test
```
