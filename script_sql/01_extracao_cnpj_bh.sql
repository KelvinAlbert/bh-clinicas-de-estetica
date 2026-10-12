-- Projeto: Panorama do Mercado de Estética em Belo Horizonte
-- Objetivo: Extrair dados de estabelecimentos de estética e beleza (Ativos e Baixados) em BH.
-- Fonte: Base dos Dados (Google BigQuery)
-- Autor: [Kelvin Albert Boanerges Gonçalves Rosa]


/*Está query tem como objetivo selecionar as clinicas de atividades estéticas e relacionados a pesquisa deste projeto
Obtei por utilizar um CTE para economizar processamento e fazer uma busca mais rápida e precisa dos dados*/
WITH Estabelecimentos_BH AS (
  SELECT 
    cnpj_basico,
    cnpj_ordem,
    cnpj_dv,
    identificador_matriz_filial,
    situacao_cadastral,
    data_situacao_cadastral,
    data_inicio_atividade,
    cnae_fiscal_principal,
    id_municipio,
    bairro
  FROM `basedosdados.br_me_cnpj.estabelecimentos`
  WHERE 
    id_municipio = '3106200' -- Código IBGE para Belo Horizonte
    AND cnae_fiscal_principal IN (
      '9602502', -- Atividades de estética e outros serviços de cuidados com a beleza
      '9602501'  -- Cabeleireiros, manicure e pedicure (frequentemente integrados às clínicas)
    )
)

/* Utiliza a CTE criada no passo acima para filtrar as empresas  */
SELECT 
  est.cnpj_basico || est.cnpj_ordem || est.cnpj_dv AS cnpj_completo,
  est.identificador_matriz_filial AS tipo_estabelecimento,
  CASE 
    WHEN est.situacao_cadastral = '2' THEN 'Ativa'
    WHEN est.situacao_cadastral = '8' THEN 'Baixada'
    WHEN est.situacao_cadastral = '3' THEN 'Suspensa'
    WHEN est.situacao_cadastral = '4' THEN 'Inapta'
    ELSE 'Outros'
  END AS status_cnpj,
  est.data_inicio_atividade,
  est.data_situacao_cadastral,
  est.cnae_fiscal_principal,
  est.bairro,
  emp.capital_social
FROM Estabelecimentos_BH est
LEFT JOIN `basedosdados.br_me_cnpj.empresas` emp
  ON est.cnpj_basico = emp.cnpj_basico
ORDER BY est.data_inicio_atividade DESC;