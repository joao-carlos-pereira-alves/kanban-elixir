# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Kanban.Repo.insert!(%Kanban.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


alias Kanban.Repo
alias Kanban.Tasks.Task

image_file_path = "./example_file.jpeg"
pdf_file_path = "./example_pdf.pdf"

image_file = %Plug.Upload{
  filename: "example_image.jpeg",
  path: image_file_path
}

pdf_file = %Plug.Upload{
  filename: "example_pdf.pdf",
  path: pdf_file_path
}


tasks = [
  %{
    name: "Criar sistema de login",
    priority: :critical,
    description: "Desenvolver autenticação com JWT.",
    execution_date: ~D[2024-12-24],
    execution_location: "remote",
    status: "to_do",
    attachments: ["https://example.com/jwt_doc.pdf"],
    files: [image_file, pdf_file]
  },
  %{
    name: "Configurar banco de dados",
    priority: :high,
    description: "Adicionar PostgreSQL com migrações.",
    execution_date: ~D[2024-12-20],
    execution_location: "remote",
    status: "to_do",
    attachments: ["https://example.com/db_config.png"],
    files: [image_file]
  },
  %{
    name: "Implementar GraphQL",
    priority: :critical,
    description: "Criar queries e mutations básicas.",
    execution_date: ~D[2024-12-18],
    execution_location: "remote",
    status: "in_progress",
    attachments: ["https://example.com/graphql_schema.json"],
    files: [image_file]
  },
  %{
    name: "Refatorar código",
    priority: :low,
    description: "Melhorar legibilidade e otimização.",
    execution_date: ~D[2024-12-26],
    execution_location: "office",
    status: "in_progress",
    attachments: [],
    files: [pdf_file]
  },
  %{
    name: "Criar testes unitários",
    priority: :high,
    description: "Cobertura mínima de 90%.",
    execution_date: ~D[2024-12-23],
    execution_location: "office",
    status: "to_do",
    attachments: ["https://example.com/test_coverage.pdf"],
    files: [image_file]
  },
  %{
    name: "Criar documentação da API",
    priority: :low,
    description: "Usar Swagger para a documentação.",
    execution_date: ~D[2024-12-28],
    execution_location: "office",
    attachments: ["https://example.com/swagger_doc.yaml"],
    status: "finished",
    files: [image_file, pdf_file]
  },
  %{
    name: "Implementar cache",
    priority: :high,
    description: "Adicionar Redis para cache de dados.",
    execution_date: ~D[2024-12-22],
    execution_location: "office",
    attachments: ["https://example.com/redis_tutorial.pdf"],
    status: "in_progress",
    files: [image_file, pdf_file]
  },
  %{
    name: "Configurar CI/CD",
    priority: :critical,
    description: "Automatizar deploy no Heroku.",
    execution_date: ~D[2024-12-19],
    execution_location: "client_site",
    status: "to_do",
    attachments: ["https://example.com/cicd_pipeline.png"],
    files: [image_file]
  },
  %{
    name: "Criar notificações por e-mail",
    priority: :high,
    description: "Enviar e-mails para novos usuários.",
    execution_date: ~D[2024-12-30],
    execution_location: "client_site",
    status: "to_do",
    attachments: [],
    files: [pdf_file]
  },
  %{
    name: "Monitorar logs do sistema",
    priority: :low,
    description: "Configurar monitoramento com ELK Stack.",
    execution_date: ~D[2024-12-27],
    execution_location: "hybrid",
    status: "to_do",
    attachments: ["https://example.com/elk_setup.png"],
    files: [image_file]
  },
  %{
    name: "Criar painel administrativo",
    priority: :critical,
    description: "Dashboard com permissões baseadas em papéis.",
    execution_date: ~D[2024-12-21],
    execution_location: "hybrid",
    status: "finished",
    attachments: ["https://example.com/admin_ui_mockup.png"],
    files: [image_file, pdf_file]
  },
  %{
    name: "Analisar requisitos de segurança",
    priority: :high,
    description: "Revisar vulnerabilidades OWASP.",
    execution_date: ~D[2024-12-29],
    execution_location: "hybrid",
    status: "to_do",
    attachments: [],
    files: [image_file, pdf_file]
  },
  %{
    name: "Otimizar consultas SQL",
    priority: :high,
    description: "Melhorar performance com índices.",
    execution_date: ~D[2024-12-25],
    execution_location: "remote",
    status: "to_do",
    attachments: ["https://example.com/sql_optimization.pdf"],
    files: [image_file]
  },
  %{
    name: "Realizar testes de carga",
    priority: :critical,
    description: "Garantir suporte para 10k requisições por segundo.",
    execution_date: ~D[2024-12-31],
    execution_location: "client_site",
    status: "to_do",
    attachments: ["https://example.com/load_test_results.png"],
    files: [image_file, pdf_file]
  },
  %{
    name: "Criar sistema de tags",
    priority: :low,
    description: "Adicionar tags para organizar tarefas.",
    execution_date: ~D[2024-12-17],
    execution_location: "client_site",
    status: "finished",
    attachments: ["https://example.com/tagging_system.png"],
    files: [image_file, pdf_file]
  }
]

Enum.each(tasks, fn task ->
  Kanban.Tasks.create(task)
end)
