# 📊 Inteligência de Mercado: Expansão do Setor de Estética em Belo Horizonte

![Status do Projeto](https://img.shields.io/badge/Status-Em%20Desenvolvimento-yellow)
![Ferramentas](https://img.shields.io/badge/Stack-SQL%20%7C%20Power%20BI%20%7C%20BigQuery-blue)

## 📌 O Problema de Negócio
O mercado de saúde, estética e cuidados pessoais tem apresentado forte crescimento. Este projeto tem como objetivo analisar a viabilidade e identificar as melhores regiões em Belo Horizonte e região metropolitana para a abertura de novos estabelecimentos do setor. 

A análise cruza dados demográficos com o histórico de abertura e fechamento de empresas (CNPJs) para responder:
- Qual a taxa de sobrevivência das clínicas de estética na região?
- Quais bairros possuem a maior defasagem de serviços em relação à sua população?
- Como o mercado se comportou após o ano de 2020?

## 🏗️ Arquitetura da Solução
1. **Extração na Nuvem:** Consultas SQL no Google BigQuery utilizando o datalake público da *Base dos Dados*.
2. **Modelagem:** Armazenamento e estruturação em Star Schema (Fato e Dimensão) utilizando Microsoft SQL Server.
3. **Visualização:** Dashboard interativo em Power BI para exploração executiva.

![Diagrama Relacional - Star Schema](image/modelo_star_schema.png)

**Detalhes da Modelagem:**
- **Fato_Estabelecimentos:** Tabela central contendo as métricas de negócio, datas de abertura/fecho e capital social. A granularidade é a nível de CNPJ único (garantida via tratamento de dados).
- **Dim_Geografia:** Dimensão de contexto espacial (Bairros de Belo Horizonte).
- **Dim_Status:** Dimensão que categoriza a situação cadastral (Ativa, Baixada, etc.).

## 🗂️ Fontes e Dicionário de Dados
Os dados foram extraídos do projeto [Base dos Dados](https://basedosdados.org/):
- `br_me_cnpj.empresas` e `br_me_cnpj.estabelecimentos`: Filtrado pelos CNAEs de estética (ex: 9602-5/02).
- `br_ibge_populacao.municipio`: Dados demográficos de Minas Gerais.

## 🚀 Como Executar este Projeto
1. Clone este repositório: `git clone https://github.com/KelvinAlbert/bh-clinicas-de-estetica.git`
2. Os scripts de extração do BigQuery estão na pasta `/scripts_sql`.
3. Para visualizar o dashboard, faça o download do arquivo `MarketIntelligence_Estetica.pbix` na pasta `/dashboard` e abra com o Power BI Desktop.

## 💡 Principais Insights
*(Sessão reservada para os Insights adquridos ao fim do projeto, exemplos para inserir posteriormente)*
- [Insight 1: Exemplo - O bairro X apresentou um crescimento de 15% na abertura de CNPJs, mas mantém uma relação de 1 clínica para cada 5.000 habitantes.]
- [Insight 2: Exemplo - A taxa de mortalidade de empresas do setor diminuiu 8% em 2025.]

## 👨‍💻 Autor
**[Kelvin Albert Boanerges Gonçalves Rosa]**
- [[LinkedIn](https://www.linkedin.com/in/kelvin-rosa-670a8a19b/)]
- [[GitHub](https://github.com/KelvinAlbert)]