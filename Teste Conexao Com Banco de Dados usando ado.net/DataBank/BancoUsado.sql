-- Exemplo de Tabela "Pai" (Categoria)
CREATE TABLE Tb_Editora
(
    -- ID (Chave Primária)
    id_editora      INT        NOT NULL    PRIMARY KEY IDENTITY(1,1),
    
    -- Colunas da Tabela
    descrição      NVARCHAR(100)  NOT NULL,
    endereço       NVARCHAR(500)  NULL, -- NULL explícito para clareza
);
GO -- Comando para separar lotes no SQL Server

CREATE TABLE Tb_Livro
(
    -- ID (Chave Primária)
    id_livro       INT        NOT NULL    PRIMARY KEY IDENTITY(1,1),
    
    -- Colunas da Tabela
    título         NVARCHAR(200)   NOT NULL,
    preco          DECIMAL(10,2)   NOT NULL, 
    id_editora     INT             NOT NULL, -- Chave Estrangeira
    
    -- Definição da Chave Estrangeira
    CONSTRAINT FK_Livro_Editora FOREIGN KEY (id_editora)
        REFERENCES Tb_Editora(id_editora)
        ON DELETE CASCADE -- Ação de exclusão em cascata
);
GO

CREATE TABLE TB_Autor (

    id_autor INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    nome NVARCHAR(100) NOT NULL,
    SEXO CHAR(1) NOT NULL,
    data_nascimento DATE NOT NULL

);
GO

CREATE TABLE TB_Autoria (

    id_autoria INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    id_livro INT NOT NULL,
    id_autor INT NOT NULL,

    CONSTRAINT FK_Autoria_Livro FOREIGN KEY (id_livro)
        REFERENCES Tb_Livro(id_livro)
        ON DELETE CASCADE,

    CONSTRAINT FK_Autoria_Autor FOREIGN KEY (id_autor)
        REFERENCES TB_Autor(id_autor)
        ON DELETE CASCADE

);
GO

CREATE TABLE Tb_Funcionario(

    id_funcionario INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    nome NVARCHAR(100) NOT NULL,
    sexo CHAR(1) NOT NULL,
);
GO

INSERT INTO Tb_Editora (descrição, endereço) VALUES
('Campus', 'Rua do Timbó'),
('Abril', null),
('Globo', null),
('Teste', null);
GO

INSERT INTO Tb_Livro (título, preco, id_editora) VALUES
('Banco de Dados', 100.00, 1),
('SGBD', 120.00, 2),
('Redes de Computadores', 90.00, 2);
GO

INSERT INTO TB_Autor (nome, sexo, data_nascimento) VALUES
('João', 'M', '1970-01-01'),
('Maria', 'F', '1974-05-17'),
('José', 'M', '1977-10-10'),
('Carla', 'F', '1964-12-08');
GO

INSERT INTO TB_Autoria (id_livro, id_autor) VALUES
(1, 1),
(1, 2),
(2, 2),
(2, 4),
(3, 3);
GO

INSERT INTO Tb_Funcionario (nome, sexo) VALUES
('João', 'M'),
('Carla', 'F'),
('Osvaldo', 'M');

select * from tb_editora;
SELECT * FROM tb_livro;
SELECT * FROM TB_Autor;
SELECT * FROM TB_Autoria;
SELECT * FROM Tb_Funcionario;

/*1. Reajustar os preços de todos livros em 10%*/
UPDATE Tb_Livro
SET preco = preco / 1.10;
GO
SELECT * FROM Tb_Livro;

-- 2. Atualizar o endereço da Editora Campus para ‘Av.ACM’
UPDATE Tb_Editora
SET endereço = 'Av.ACM'
WHERE descrição = 'Campus';
GO
SELECT * FROM Tb_Editora;

-- 4. Apresentar o nome e data de nascimento de todos os autores
SELECT NOME, data_nascimento FROM TB_Autor;
GO

-- 5. Apresentar o nome e data de nascimento de todos os autores em ordem alfabética
SELECT NOME, data_nascimento FROM TB_Autor
ORDER BY NOME ASC;
GO

-- 6. Apresentar o nome e data de nascimento de todas as autoras do sexo feminino em ordem alfabética
SELECT NOME, DATA_NASCIMENTO FROM TB_Autor
WHERE SEXO = 'F'
ORDER BY NOME ASC;
GO

-- 7. Apresentar a descrição das editoras que não possuem endereço cadastrado
SELECT descrição FROM Tb_Editora
WHERE endereço IS NULL;
GO

-- 8. Apresentar o título dos livros juntamente com a descrição da editora correspondente
SELECT L.título, E.DESCRIÇÃO FROM Tb_Editora E
JOIN Tb_Livro L ON E.id_editora = L.id_editora;
GO

-- 9. Apresentar o título dos livros juntamente com a descrição das editoras que não possuem livros cadastrados
SELECT L.título, E.DESCRIÇÃO FROM Tb_Editora E
LEFT JOIN Tb_Livro L ON E.id_editora = L.id_editora
WHERE L.id_livro IS NULL;
GO

-- 10. Apresentar o título dos livros juntamente com o nome dos autores correspondentes
SELECT L.título, R.nome FROM Tb_Editora E
JOIN Tb_Livro L ON E.id_editora = L.id_editora
JOIN TB_Autoria A ON L.id_livro = A.id_livro
JOIN TB_Autor R ON A.id_autor = R.id_autor;
GO

-- 11. Apresentar a descrição das editoras juntamente com o nome dos autores correspondentes
SELECT E.descrição, R.nome FROM Tb_Editora E
JOIN Tb_Livro L ON E.id_editora = L.id_editora
JOIN TB_Autoria A ON L.id_livro = A.id_livro
JOIN TB_Autor R ON A.id_autor = R.id_autor;
GO

-- 12. Apresentar todos os dados dos livros cujo título inicia com a palavra 'BANCO'
SELECT * FROM Tb_Livro L
WHERE L.título LIKE 'BANCO%';
GO

-- 13. Apresentar todos os dados dos livros cujo título contém a palavra 'do'
SELECT * FROM Tb_Livro L
WHERE L.título LIKE '%do%';
GO

-- 14. Apresentar o título, preço e o preço reajustado (com aumento de 10%) de todos os livros utilizando subconsulta
SELECT L2.título, L2.preco, (
    SELECT L1.preco * 1.10 
    FROM Tb_Livro L1
    WHERE L1.id_livro = L2.id_livro
) AS precoreajustado 
FROM Tb_Livro L2;
GO

-- 15.	Apresentar o nome dos autores que nasceram no mês de outubro
SELECT nome FROM TB_Autor
WHERE MONTH(data_nascimento) = 10;
GO

-- 16. Apresentar a quantidade total de editoras cadastradas
SELECT COUNT(*) AS TotalLivros FROM Tb_Livro;
GO

-- 17. Apresentar a quantidade de autores que escreveram o livro 'BANCO DE DADOS' juntamente com o título do livro
SELECT COUNT(R.id_autor) AS QNT_AUTOR, L.TÍTULO FROM TB_Autoria A
JOIN Tb_Livro L ON A.id_livro = L.id_livro
JOIN TB_Autor R ON A.id_autor = R.id_autor
WHERE L.TÍTULO LIKE 'BANCO DE DADOS'
GROUP BY L.título;
GO

-- 18. Apresentar a soma dos preços de todos os livros cadastrados
SELECT SUM(preco) AS SomaPrecos FROM Tb_Livro;
GO

-- 19. Apresentar a média dos preços de todos os livros cadastrados
SELECT AVG(preco) AS MediaPrecos FROM Tb_Livro;
GO

-- 20. Apresentar o maior preço entre todos os livros cadastrados
SELECT MAX(preco) AS PrecoMaximo FROM Tb_Livro;
GO

-- 21. Apresentar o nome do autor mais velho

SELECT * FROM TB_Autor
WHERE data_nascimento = (
    SELECT MIN(data_nascimento) FROM TB_Autor
);
GO

SELECT TOP 1 * FROM TB_Autor
ORDER BY data_nascimento ASC
GO

-- 22. Apresentar a quantidade de livros cadastrados para cada editora juntamente com a descrição da editora
SELECT COUNT(L.id_livro), E.DESCRIÇÃO FROM TB_LIVRO L
JOIN Tb_Editora E ON L.id_editora = E.id_editora
GROUP BY E.DESCRIÇÃO;
GO

-- 23. Apresentar a soma das médias dos preços dos livros para cada editora
SELECT SUM(MEDIA.PRECOMEDIO) FROM (
    SELECT AVG(L.PRECO) AS PRECOMEDIO, E.DESCRIÇÃO FROM TB_LIVRO L
    JOIN Tb_Editora E ON L.id_editora = E.id_editora
    GROUP BY E.DESCRIÇÃO
) AS MEDIA;
GO

-- 24. Apresentar o nome dos autores que escreveram mais de um livro juntamente com a quantidade de livros escritos por cada autor
SELECT R.NOME, COUNT(L.id_livro) AS qntlivro FROM TB_Autoria A
JOIN Tb_Livro L ON A.id_livro = L.id_livro
JOIN TB_Autor R ON A.id_autor = R.id_autor
GROUP BY R.NOME
HAVING COUNT(L.id_livro) > 1;
GO

-- 25. Apresentar a média dos preços dos livros para cada editora, considerando apenas as editoras cuja média dos preços dos livros seja superior a R$120,00
SELECT AVG(L.PRECO) AS PRECOMEDIO, E.DESCRIÇÃO FROM TB_LIVRO L
JOIN Tb_Editora E ON L.id_editora = E.id_editora
GROUP BY E.DESCRIÇÃO
HAVING AVG(L.PRECO) > 120.00;
GO

-- 26. Apresentar o nome e o sexo de todos os funcionários e autores, eliminando os registros duplicados
SELECT NOME, SEXO FROM Tb_Funcionario
UNION SELECT NOME, SEXO FROM TB_Autor;
GO

-- 27. Apresentar o nome dos funcionários que também são autores
SELECT NOME FROM Tb_Funcionario F
INTERSECT SELECT NOME FROM TB_Autor A;
GO

-- 28. Apresentar o nome dos funcionários que não são autores
SELECT NOME FROM Tb_Funcionario F
EXCEPT SELECT NOME FROM TB_Autor A;
GO

-- 29. Apresentar o nome dos autores juntamente com o título dos livros que eles escreveram, exceto os autores do livro 'BANCO DE DADOS'
SELECT R.NOME FROM TB_Autoria A
JOIN Tb_Livro L ON A.id_livro = L.id_livro
JOIN TB_Autor R ON A.id_autor = R.id_autor
GROUP BY R.NOME, L.TÍTULO
HAVING L.TÍTULO NOT LIKE 'BANCO DE DADOS';
GO

-- 30. Apresentar a quantidade de livros cadastrados para as editoras 'Campus' e 'Abril'
SELECT * FROM (
    SELECT COUNT(L.id_livro) AS Campus FROM Tb_Editora E
    JOIN Tb_Livro L ON E.id_editora = L.id_editora
    WHERE E.descrição = 'Campus'
) AS Campus, (
    SELECT COUNT(L.id_livro) AS Abril FROM Tb_Editora E
    JOIN Tb_Livro L ON E.id_editora = L.id_editora
    WHERE E.descrição = 'Abril'
) AS Abril;
GO

