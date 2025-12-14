using Microsoft.Data.SqlClient;
using System;
using Dapper;
using TesteConexaoDB.Model;

namespace TesteConexaoDB
{
    internal class Program
    {
        static void Main(string[] args)
        {
            string connectionString = "Data Source=localhost,1433; Initial Catalog=teste; User ID=sa; Password=teste@123; TrustServerCertificate=True";


            var novaEditora = new Editora
            {
                descrição = "Editora Band",
                endereço = "Rua da Band"
            };

            using (var connection = new SqlConnection(connectionString))
            {

                //CriarEditora(connection, novaEditora);
                //DeletarMuitasEditoras(connection, new List<int> { 1, 2, 3, 4, 5 });
                //ExecutarProcedureDeletarEditora(connection, 7);
                ExcutarProcedureObterLivroPorAutor(connection, "Maria");

                AtualizarEditora(connection, new Editora
                {
                    id_editora = 6,
                    descrição = "Editora ATUALIZADA",
                    endereço = "Rua Atualizada, 5678"
                });

                connection.Open();

                Console.WriteLine("Conexão aberta com sucesso!");
                ListarEditoras(connection);
            }

            static void ListarEditoras(SqlConnection connection)
            {
                var editoras = connection.Query<Editora>("SELECT * FROM TB_EDITORA");
                foreach (var editora in editoras)
                {
                    Console.WriteLine($"{editora.id_editora} - {editora.descrição} - {editora.endereço}");
                }
            }

            static void CriarEditora(SqlConnection connection, Editora novaEditora)
            {
                const string insertQuery = @"
                INSERT INTO Tb_Editora 
                VALUES (
                    @descrição, 
                    @endereço
                )";
                var rowsAffected = connection.Execute(insertQuery, new
                {

                    novaEditora.descrição,
                    novaEditora.endereço

                });
                Console.WriteLine($"{rowsAffected} linha(s) inserida(s) com sucesso.");

            }

            static void CriarMuitasEditoras(SqlConnection connection, List<Editora> novasEditoras)
            {
                const string insertQuery = @"
                INSERT INTO Tb_Editora 
                VALUES (
                    @descrição, 
                    @endereço
                )";
                var rowsAffected = connection.Execute(insertQuery, novasEditoras);
                Console.WriteLine($"{rowsAffected} linha(s) inserida(s) com sucesso.");
            }

            static void AtualizarEditora(SqlConnection connection, Editora editoraAtualizada)
            {
                const string updateQuery = @"
                UPDATE TB_EDITORA 
                SET 
                    descrição = @descrição, 
                    endereço = @endereço
                WHERE 
                    id_editora = @id_editora";

                var rowsAffected = connection.Execute(updateQuery, new
                {

                    editoraAtualizada.id_editora,
                    editoraAtualizada.descrição,
                    editoraAtualizada.endereço

                });
                Console.WriteLine($"{rowsAffected} linha(s) atualizada(s) com sucesso.");
            }

            static void DeletarEditora(SqlConnection connection, int id_editora)
            {
                const string deleteQuery = @"
                DELETE FROM TB_EDITORA 
                WHERE 
                    id_editora = @id_editora";

                var rowsAffected = connection.Execute(deleteQuery, new
                {

                    id_editora

                });
                Console.WriteLine($"{rowsAffected} linha(s) deletada(s) com sucesso.");
            }

            static void DeletarMuitasEditoras(SqlConnection connection, List<int> ids_editoras)
            {
                const string deleteQuery = @"
                DELETE FROM TB_EDITORA 
                WHERE 
                    id_editora = @id_editora";

                var rowsAffected = connection.Execute(deleteQuery, ids_editoras.Select(id => new { id_editora = id }));

                Console.WriteLine($"{rowsAffected} linha(s) deletada(s) com sucesso.");
            }

            static void ExecutarProcedureDeletarEditora(SqlConnection connection, int id)
            {
                const string storedProcedureName = "SP_DELETAR_EDITORA";
                var parameters = new { IdEditora = id };
                var rowsAffected = connection.Execute(storedProcedureName, parameters, commandType: System.Data.CommandType.StoredProcedure);

            }

            static void ExcutarProcedureObterLivroPorAutor(SqlConnection connection, string nomeAutor)
            {
                const string storedProcedureName = "sp_ObterLivrosPorAutor";
                var parameters = new { NomeAutor = nomeAutor };
                var livros = connection.Query(storedProcedureName, parameters, commandType: System.Data.CommandType.StoredProcedure);
                foreach (var livro in livros)
                {
                    Console.WriteLine($"{livro.nome} - {livro.título} - {livro.preco}");
                }
            }
        }
    }
}