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
        }
    }
}