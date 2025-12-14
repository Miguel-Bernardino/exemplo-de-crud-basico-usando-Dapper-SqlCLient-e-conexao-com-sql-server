# Teste de Conexão com Banco de Dados - Dapper & SqlClient

Projeto de exemplo em C# demonstrando operações CRUD (Create, Read, Update, Delete) em um banco de dados SQL Server utilizando **Dapper** e **Microsoft.Data.SqlClient**.

## ?? Pré-requisitos

- **.NET 9.0 SDK** ou superior
- **SQL Server** (local ou remoto)
- **Visual Studio 2022** ou **Visual Studio Code**

## ?? Tecnologias Utilizadas

- **C# 13.0**
- **.NET 9.0**
- **Dapper 2.1.66** - Micro ORM para mapeamento objeto-relacional
- **Microsoft.Data.SqlClient 6.1.3** - Provider ADO.NET para SQL Server

## ?? Estrutura do Projeto

```
Teste Conexao Com Banco de Dados usando ado.net/
?
??? Model/
?   ??? Editora.cs              # Modelo de dados da entidade Editora
?
??? DataBank/
?   ??? BancoUsado.sql          # Scripts SQL de criação e exemplos de consultas
?
??? Program.cs                   # Aplicação principal com operações CRUD
??? Teste Conexao Com Banco de Dados usando dapper, sqlClient.csproj
```

## ??? Modelo de Dados

### Entidade: Editora

```csharp
public class Editora
{
    public int? id_editora { get; set; }
    public string descrição { get; set; }
    public string endereço { get; set; }
}
```

### Schema do Banco de Dados

O projeto utiliza um banco de dados relacional com as seguintes tabelas:

- **Tb_Editora** - Armazena informações de editoras
- **Tb_Livro** - Armazena informações de livros (relacionada com Editora)
- **TB_Autor** - Armazena informações de autores
- **TB_Autoria** - Tabela de relacionamento muitos-para-muitos entre Livro e Autor
- **Tb_Funcionario** - Armazena informações de funcionários

## ?? Configuração

### 1. Configurar o Banco de Dados

Execute o script SQL localizado em `DataBank/BancoUsado.sql` no seu SQL Server para criar as tabelas e inserir dados de exemplo.

### 2. Configurar a String de Conexão

No arquivo `Program.cs`, atualize a connection string com suas credenciais:

```csharp
string connectionString = "Data Source=localhost,1433; Initial Catalog=teste; User ID=sa; Password=SUA_SENHA; TrustServerCertificate=True";
```

### 3. Restaurar Pacotes NuGet

```bash
dotnet restore
```

### 4. Compilar o Projeto

```bash
dotnet build
```

### 5. Executar a Aplicação

```bash
dotnet run
```

## ?? Funcionalidades Implementadas

### ? Criar Editora (INSERT)

```csharp
static void CriarEditora(SqlConnection connection, Editora novaEditora)
{
    const string insertQuery = @"
        INSERT INTO Tb_Editora 
        VALUES (@descrição, @endereço)";
    
    var rowsAffected = connection.Execute(insertQuery, new
    {
        novaEditora.descrição,
        novaEditora.endereço
    });
    
    Console.WriteLine($"{rowsAffected} linha(s) inserida(s) com sucesso.");
}
```

### ?? Atualizar Editora (UPDATE)

```csharp
static void AtualizarEditora(SqlConnection connection, Editora editoraAtualizada)
{
    const string updateQuery = @"
        UPDATE TB_EDITORA 
        SET descrição = @descrição, endereço = @endereço
        WHERE id_editora = @id_editora";
    
    var rowsAffected = connection.Execute(updateQuery, new
    {
        editoraAtualizada.id_editora,
        editoraAtualizada.descrição,
        editoraAtualizada.endereço
    });
    
    Console.WriteLine($"{rowsAffected} linha(s) atualizada(s) com sucesso.");
}
```

### ?? Listar Editoras (SELECT)

```csharp
static void ListarEditoras(SqlConnection connection)
{
    var editoras = connection.Query<Editora>("SELECT * FROM TB_EDITORA");
    
    foreach (var editora in editoras)
    {
        Console.WriteLine($"{editora.id_editora} - {editora.descrição} - {editora.endereço}");
    }
}
```

## ?? Exemplo de Uso

```csharp
var novaEditora = new Editora
{
    descrição = "Editora TESTE",
    endereço = "Rua de teste, 1234"
};

using (var connection = new SqlConnection(connectionString))
{
    CriarEditora(connection, novaEditora);
    
    AtualizarEditora(connection, new Editora
    {
        id_editora = 8,
        descrição = "Editora ATUALIZADA",
        endereço = "Rua Atualizada, 5678"
    });
    
    connection.Open();
    Console.WriteLine("Conexão aberta com sucesso!");
    ListarEditoras(connection);
}
```

## ?? Problemas Conhecidos e Soluções

### ExecutionEngineException com .NET 10

Se você encontrar `System.ExecutionEngineException`, verifique se está usando .NET 10 com `Microsoft.Data.SqlClient 6.1.3`.

**Causa:** O `Microsoft.Data.SqlClient 6.1.3` só possui assemblies compilados para .NET 9.0, causando incompatibilidade de ABI com .NET 10.

**Solução:** Use .NET 9.0 no projeto:

```xml
<TargetFramework>net9.0</TargetFramework>
```

Limpe e reconstrua:

```bash
dotnet clean
dotnet build
```

## ?? Consultas SQL Disponíveis

O arquivo `BancoUsado.sql` contém 30 exemplos de consultas SQL, incluindo:

- Operações CRUD básicas
- JOINs (INNER, LEFT)
- Subconsultas
- Funções de agregação (COUNT, SUM, AVG, MAX, MIN)
- GROUP BY e HAVING
- Operadores de conjunto (UNION, INTERSECT, EXCEPT)
- LIKE para busca de padrões
- E muito mais...

## ?? Contribuindo

Contribuições são bem-vindas! Sinta-se à vontade para:

1. Fazer um fork do projeto
2. Criar uma branch para sua feature (`git checkout -b feature/NovaFuncionalidade`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova funcionalidade'`)
4. Push para a branch (`git push origin feature/NovaFuncionalidade`)
5. Abrir um Pull Request

## ?? Licença

Este projeto é de código aberto e está disponível sob a licença MIT.

## ?? Autor

Desenvolvido como projeto de exemplo para demonstrar operações de banco de dados em C# com Dapper.

---

**? Se este projeto foi útil para você, considere dar uma estrela!**
