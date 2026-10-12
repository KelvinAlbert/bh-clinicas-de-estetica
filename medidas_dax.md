# 📊 Documentação das Medidas DAX e Regras de Negócio

Este documento detalha as fórmulas DAX construídas no Power BI para o projeto de Inteligência de Mercado no setor de Estética em Belo Horizonte. Mais do que um repositório de código, este ficheiro regista as tomadas de decisão analítica e as lógicas de negócio aplicadas.

---

## 1. Métricas de Base (Fundação)
Para garantir a escalabilidade do modelo e evitar a repetição de código, foi criada uma medida base que contabiliza a granularidade principal do modelo (o CNPJ único). 

**Fórmula:**
```dax
Total Estabelecimentos = COUNTROWS('Fato_Estabelecimentos')
```
> **Decisão Técnica:** A utilização de `COUNTROWS` na tabela Fato é mais eficiente em termos de processamento (Motor VertiPaq) do que utilizar `COUNT` numa coluna específica, servindo de base para todas as medidas subsequentes.

---

## 2. Métricas de Viabilidade (Status)

```dax
Qtd Ativos = 
CALCULATE(
    [Total Estabelecimentos],
    'Dim_Status'[Descricao_Status] = "Ativa"
)
```

```dax
Qtd Baixados = 
CALCULATE(
    [Total Estabelecimentos],
    'Dim_Status'[Descricao_Status] = "Baixada"
)
```

---

## 3. Métricas de Risco (Mortalidade)
O objetivo de negócio principal para um investidor é compreender o risco da região. A taxa de mortalidade calcula o rácio de empresas que faliram em relação ao volume histórico total.

```dax
Taxa de Mortalidade = 
DIVIDE(
    [Qtd Baixados],
    [Total Estabelecimentos],
    0
)
```
> **Decisão Técnica:** A utilização da função `DIVIDE` em vez do operador padrão de divisão (`/`) foi uma escolha propositada para garantir a segurança da aplicação, evitando o erro de "divisão por zero" (Infinity) em bairros que possam não ter histórico registado, retornando `0` como tratamento de erro.

---

## 4. Métricas Financeiras e Outliers

```dax
Capital Social Mediano = 
CALCULATE(
    MEDIAN('Fato_Estabelecimentos'[Capital_Social]),
    'Dim_Status'[Descricao_Status] = "Ativa"
)
```
> **Decisão Analítica:** Em vez de eliminar o registo da base de dados e perder a contagem da empresa no volume de mercado, a regra de negócio para a métrica financeira foi alterada de Média para Mediana. Como a mediana é resistente a valores extremos (outliers), o indicador passou a refletir o investimento real de micro e pequenos empresários (que se fixou em cerca de R$ 20.000,00), garantindo total integridade à análise.