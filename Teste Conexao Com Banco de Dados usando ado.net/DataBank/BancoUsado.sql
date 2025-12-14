CREATE TABLE Tb_Editora
(
    -- ID (Chave Primária)
    id_editora          INT         NOT NULL    PRIMARY KEY IDENTITY(1,1),
    
    -- Colunas da Tabela
    descrição           NVARCHAR(100)   NOT NULL,
    endereço            NVARCHAR(500)   NULL,
);
GO 

CREATE TABLE Tb_Livro
(
    -- ID (Chave Primária)
    id_livro           INT         NOT NULL    PRIMARY KEY IDENTITY(1,1),
    
    -- Colunas da Tabela
    título             NVARCHAR(200)    NOT NULL,
    preco              DECIMAL(10,2)    NOT NULL, 
    id_editora         INT              NOT NULL, -- Chave Estrangeira
    
    -- Definição da Chave Estrangeira
    CONSTRAINT FK_Livro_Editora FOREIGN KEY (id_editora)
        REFERENCES Tb_Editora(id_editora)
        ON DELETE CASCADE
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

CREATE TABLE TB_CARGO
(
    CODIGO          SMALLINT NOT NULL PRIMARY KEY IDENTITY(1,1),
    DESCRICAO       NVARCHAR(30)            NOT NULL,
);
GO

CREATE TABLE TB_SETOR
(
    CODIGO          SMALLINT NOT NULL PRIMARY KEY IDENTITY(1,1),
    DESCRICAO           VARCHAR(30)         NOT NULL,
);
GO

CREATE TABLE TB_CIDADE
(
    CODIGO          SMALLINT NOT NULL PRIMARY KEY IDENTITY(1,1),
    DESCRICAO           NVARCHAR(30)         NOT NULL,
);
GO

CREATE TABLE TB_FUNCIONARIO
(
   MATRICULA             INT               NOT NULL,
   NOME                  VARCHAR(50)       NOT NULL,
   LOGRADOURO            VARCHAR(50)       NOT NULL,
   NUMEROENDERECO        INT               ,
   COMPLENDERECO         VARCHAR(20)       ,
   BAIRRO                VARCHAR(30)       ,
   CIDADE                SMALLINT          NOT NULL,
   CEP                   CHAR(08)          NOT NULL,
   PONTOREFERENCIA       VARCHAR(60)       ,
   TELEFONE              VARCHAR(10)       DEFAULT '0000000000',
   E_MAIL                VARCHAR(60)       ,
   SEXO                  CHAR(01)          NOT NULL,
   ESTADOCIVIL           CHAR(01)          NOT NULL,
   DATANASCIMENTO        DATE              NOT NULL,
   CPF                   CHAR(11)          NOT NULL,
   DATAADMISSAO          DATE              NOT NULL,
   DATADEMISSAO          DATE,
   
   -- Restrições Inseridas:
   CONSTRAINT PK_FUNCIONARIO PRIMARY KEY (MATRICULA),
   CONSTRAINT FK_EMPREGADOCIDADE FOREIGN KEY(CIDADE)
             REFERENCES TB_CIDADE(CODIGO)
);
GO

CREATE TABLE TB_HISTORICO
(
   ANO                   SMALLINT          NOT NULL,
   MES                   SMALLINT          NOT NULL,
   MATRICULA             INT               NOT NULL,
   CARGO                 SMALLINT          NOT NULL,
   SETOR                 SMALLINT          NOT NULL,
   HORASMENSAIS          SMALLINT          NOT NULL,
   SALARIOBASE           NUMERIC(11,2)     NOT NULL,

   -- Restrições Inseridas:
   CONSTRAINT PK_HISTORICO PRIMARY KEY (ANO, MES, MATRICULA),
   CONSTRAINT FK_HISTORICO_FUNCIONARIO FOREIGN KEY(MATRICULA)
                                     REFERENCES TB_FUNCIONARIO(MATRICULA),
   CONSTRAINT FK_HISTORICO_CARGO FOREIGN KEY(CARGO)
                                     REFERENCES TB_CARGO(CODIGO),
   CONSTRAINT FK_HISTORICO_SETOR FOREIGN KEY(SETOR)
                                     REFERENCES TB_SETOR(CODIGO)
);
GO

-- INSERTS e Consultas permanecem inalterados, mas os inserts em TB_FUNCIONARIO precisam de todos os NOT NULL
-- (Mantendo os inserts corrigidos da resposta anterior para TB_FUNCIONARIO)
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

-- ----------------------------------------------------
-- INSERÇÃO COMPLETA NA TB_FUNCIONARIO
-- Utiliza todos os campos NOT NULL e FKs
-- ----------------------------------------------------
INSERT INTO TB_FUNCIONARIO (
    MATRICULA, NOME, LOGRADOURO, NUMEROENDERECO, COMPLENDERECO, BAIRRO, 
    CIDADE, CEP, PONTOREFERENCIA, TELEFONE, E_MAIL, SEXO, 
    ESTADOCIVIL, DATANASCIMENTO, CPF, DATAADMISSAO, DATADEMISSAO
) VALUES
(
    1001, 'João Silva', 'Rua das Flores', 150, 'Apto 101', 'Pituba', 
    1, '41830000', 'Perto do mercado', '7199999999', 'joao.silva@empresa.com.br', 'M', 
    'C', '1985-05-15', '11122233344', '2018-03-01', NULL
),
(
    1002, 'Carla Santos', 'Avenida Principal', 450, NULL, 'Itaigara', 
    2, '40150100', 'Próximo ao Shopping', '7388888888', 'carla.santos@empresa.com.br', 'F', 
    'S', '1990-11-20', '55566677788', '2019-07-10', NULL
),
(
    1003, 'Osvaldo Neto', 'Travessa da Paz', 22, 'Casa', 'Centro', 
    3, '42700000', 'Em frente à praça', '7177777777', 'osvaldo.neto@empresa.com.br', 'M', 
    'D', '1976-01-08', '99900011122', '2015-01-20', '2022-12-31'
),
-- João (Intersecção com Autor)
(
    1004, 'João', 'Rua dos Saberes', 50, NULL, 'Brotas', 
    1, '40280000', 'Perto da escola', '7166666666', 'joao.autor@empresa.com.br', 'M', 
    'C', '1970-01-01', '44455566677', '2023-01-01', NULL
),
-- Carla (Intersecção com Autor)
(
    1005, 'Carla', 'Avenida das Letras', 1200, 'Sala 5', 'Comércio', 
    3, '40015000', NULL, '7155555555', 'carla.autor@empresa.com.br', 'F', 
    'S', '1964-12-08', '88899900011', '2024-06-15', NULL
);
GO

-- ----------------------------------------------------
-- INSERÇÃO COMPLETA NA TB_HISTORICO
-- Utiliza todos os campos NOT NULL e FKs
-- ----------------------------------------------------
INSERT INTO TB_HISTORICO (
    ANO, MES, MATRICULA, CARGO, SETOR, HORASMENSAIS, SALARIOBASE
) VALUES
-- Histórico de João Silva (Matrícula 1001)
(2023, 10, 1001, 1, 5, 160, 4500.00), -- Out/2023: Programador (1), Desenvolvimento (5)
(2023, 11, 1001, 2, 5, 160, 6000.00), -- Nov/2023: Promovido a Analista (2)

-- Histórico de Carla Santos (Matrícula 1002)
(2023, 10, 1002, 3, 3, 160, 9500.00), -- Out/2023: Gerente (3), Financeiro (3)

-- Histórico de Osvaldo Neto (Matrícula 1003) - Demitido
(2022, 10, 1003, 4, 1, 160, 5200.00), -- Out/2022: Administrador (4), Administração (1)
-- Histórico para João (Matrícula 1004)
(2024, 11, 1004, 3, 4, 160, 8000.00), -- Gerente (3), RH (4)
-- Histórico para Carla (Matrícula 1005)
(2024, 11, 1005, 5, 1, 160, 2500.00); -- Copeira (5), Administração (1)
GO


INSERT INTO TB_CARGO (DESCRICAO) VALUES ('PROGRAMADOR');
INSERT INTO TB_CARGO (DESCRICAO) VALUES ('ANALISTA');
INSERT INTO TB_CARGO (DESCRICAO) VALUES ('GERENTE');
INSERT INTO TB_CARGO (DESCRICAO) VALUES ('ADMINISTRADOR');
INSERT INTO TB_CARGO (DESCRICAO) VALUES ('COPEIRA');

INSERT INTO TB_SETOR (DESCRICAO) VALUES ('ADMINISTRAÇÃO');
INSERT INTO TB_SETOR (DESCRICAO) VALUES ('PRODUÇÃO');
INSERT INTO TB_SETOR (DESCRICAO) VALUES ('FINANCEIRO');
INSERT INTO TB_SETOR (DESCRICAO) VALUES ('RH');
INSERT INTO TB_SETOR (DESCRICAO) VALUES ('DESENVOLVIMENTO');

INSERT INTO TB_CIDADE (DESCRICAO) VALUES ('SALVADOR');
INSERT INTO TB_CIDADE (DESCRICAO) VALUES ('ITABUNA');
INSERT INTO TB_CIDADE (DESCRICAO) VALUES ('LAURO DE FREITAS');

COMMIT;

select * from tb_editora;
SELECT * FROM tb_livro;
SELECT * FROM TB_Autor;
SELECT * FROM TB_Autoria;
SELECT * FROM Tb_Funcionario;
SELECT * FROM TB_CARGO;
SELECT * FROM TB_SETOR;
SELECT * FROM TB_CIDADE;
SELECT * FROM TB_HISTORICO;
-- Consultas SQL

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

-- 15.  Apresentar o nome dos autores que nasceram no mês de outubro
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

CREATE OR ALTER PROCEDURE sp_ObterLivrosPorAutor
    @NomeAutor NVARCHAR(100)
AS
BEGIN
    SELECT R.nome, L.título, L.preco FROM TB_Autoria A
    JOIN Tb_Livro L ON A.id_livro = L.id_livro
    JOIN TB_Autor R ON A.id_autor = R.id_autor
    WHERE R.nome = @NomeAutor;
END
GO

CREATE OR ALTER PROCEDURE SP_DELETAR_EDITORA
    @IdEditora INT 
AS
BEGIN
    DELETE FROM Tb_Editora
    WHERE id_editora = @IdEditora;
END
GO


/*
DECLARE @kill VARCHAR(8000) = '';
SELECT @kill = @kill + 'KILL ' + CONVERT(VARCHAR(5),session_id) + '; '
FROM sys.dm_exec_sessions
WHERE database_id = DB_ID('TESTE') AND session_id <> @@SPID;
EXEC(@kill);
GO
*/
