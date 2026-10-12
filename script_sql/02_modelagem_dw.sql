-- Projeto: Panorama do Mercado de Estética em Belo Horizonte
-- Objetivo: Criar modelagem Star Schema (Fato e Dimensões) a partir da tabela de Staging.
-- Banco de Dados: Microsoft SQL Server
-- O DB  MarketIntelligence_Estetica foi criado apartir do arquivo CSV importando os dados do BigQuery
-- Autor: Kelvin Albert Boanerges Gonçalves Rosa

USE MarketIntelligence_Estetica;
GO

-- =====================================================================
-- 1. CRIAÇÃO DAS DIMENSÕES (Tabelas de Contexto)
-- =====================================================================

-- Dimensão Geografia (Bairros)
IF OBJECT_ID('Dim_Geografia', 'U') IS NOT NULL DROP TABLE Dim_Geografia;
CREATE TABLE Dim_Geografia (
    ID_Bairro INT IDENTITY(1,1) PRIMARY KEY,
    Nome_Bairro VARCHAR(150) NOT NULL
);

-- Inserindo os bairros únicos da nossa staging
INSERT INTO Dim_Geografia (Nome_Bairro)
SELECT DISTINCT bairro 
FROM stg_cnpj 
WHERE bairro IS NOT NULL;

-- Dimensão Status (Ativa, Baixada, etc)
IF OBJECT_ID('Dim_Status', 'U') IS NOT NULL DROP TABLE Dim_Status;
CREATE TABLE Dim_Status (
    ID_Status INT IDENTITY(1,1) PRIMARY KEY,
    Descricao_Status VARCHAR(50) NOT NULL
);

-- Inserindo os status únicos
INSERT INTO Dim_Status (Descricao_Status)
SELECT DISTINCT status_cnpj 
FROM stg_cnpj;

-- =====================================================================
-- 2. CRIAÇÃO DA TABELA FATO (Tabela de Métricas)
-- =====================================================================

IF OBJECT_ID('Fato_Estabelecimentos', 'U') IS NOT NULL DROP TABLE Fato_Estabelecimentos;
CREATE TABLE Fato_Estabelecimentos (
    CNPJ_Completo VARCHAR(14) PRIMARY KEY,
    ID_Bairro INT,
    ID_Status INT,
    Data_Inicio_Atividade DATE,
    Data_Situacao_Cadastral DATE,
    Capital_Social FLOAT,
    CNAE_Principal VARCHAR(10),
    FOREIGN KEY (ID_Bairro) REFERENCES Dim_Geografia(ID_Bairro),
    FOREIGN KEY (ID_Status) REFERENCES Dim_Status(ID_Status)
);
--Obs: Foi adicionado o ROW_NUMBER pois é possível que as clínicas apareçam repetidamente na tabve
WITH CTE_Staging AS (
    SELECT 
        s.cnpj_completo,
        g.ID_Bairro,
        st.ID_Status,
        CAST(s.data_inicio_atividade AS DATE) as Data_Inicio_Atividade,
        CAST(s.data_situacao_cadastral AS DATE) as Data_Situacao_Cadastral,
        CAST(s.capital_social AS FLOAT) as Capital_Social,
        s.cnae_fiscal_principal,
        ROW_NUMBER() OVER(PARTITION BY s.cnpj_completo ORDER BY s.data_situacao_cadastral DESC) as rn
    FROM stg_cnpj s
    LEFT JOIN Dim_Geografia g ON s.bairro = g.Nome_Bairro
    LEFT JOIN Dim_Status st ON s.status_cnpj = st.Descricao_Status
)
INSERT INTO Fato_Estabelecimentos (
    CNPJ_Completo, 
    ID_Bairro, 
    ID_Status, 
    Data_Inicio_Atividade, 
    Data_Situacao_Cadastral, 
    Capital_Social, 
    CNAE_Principal
)
SELECT 
    cnpj_completo,
    ID_Bairro,
    ID_Status,
    Data_Inicio_Atividade,
    Data_Situacao_Cadastral,
    Capital_Social,
    cnae_fiscal_principal
FROM CTE_Staging
WHERE rn = 1;

-- =====================================================================
-- FIM DA MODELAGEM
-- Agora o banco está pronto para ser consumido pelo Power BI!
-- =====================================================================

-- =====================================================================
-- OBJETIVO E RESUMO
/*
Essas Queries foram criadas para modelar os dados, ou seja, facilitar o consumo dentro do Power BI,
foi utilizado em todas as queries as condicionais para a validação da existência da coluna e posteriormente a importação dos dados.
Criando tabelas de dimesão e tabelas de fato. O DB criado foi stg (staging) uma criação intermediaria para o consumo efetivo dos dados.
A tabela de fato precisou de utilizar a contagem de ROW_NUMBER e ordenação DESC para organizar os fatos mais recentes, pois as clínicas
podem ter os seus status alterado ao longo do tempo e nessa analise é necessário apenas 

Em resumo, foi organizado os dados em um Star Scheme
*/
-- =====================================================================