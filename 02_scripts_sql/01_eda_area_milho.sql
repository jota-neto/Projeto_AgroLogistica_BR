-- ==========================================================
-- PROJETO: AGROLOGÍSTICA BRASIL S.A.
-- ARQUIVO: eda_area_milho.sql
-- ETAPA: Análise Exploratória de Dados (EDA)
-- OBJETIVO: Entender distribuição, qualidade e concentração da produção de milho
-- ==========================================================


-- ==========================================================
-- 1. VISÃO INICIAL DOS DADOS
-- ==========================================================

SELECT * 
FROM area_milho
LIMIT 5;

-- Estrutura identificada:
-- cod_municipio → identificador único
-- municipio → nome
-- estado → UF
-- valor → área plantada (hectares)


-- ==========================================================
-- 2. VERIFICAÇÃO DE QUALIDADE DOS DADOS
-- ==========================================================

-- 2.1 Valores Nulos
SELECT 
    COUNT(*) FILTER (WHERE cod_municipio IS NULL) AS nulos_cod,
    COUNT(*) FILTER (WHERE municipio IS NULL) AS nulos_municipio,
    COUNT(*) FILTER (WHERE valor IS NULL) AS nulos_valor
FROM area_milho;

-- Resultado: Não existem valores nulos


-- 2.2 Duplicidade
SELECT 
    COUNT(*) AS total_linhas,
    COUNT(DISTINCT cod_municipio) AS codigos_unicos,
    (COUNT(*) - COUNT(DISTINCT cod_municipio)) AS duplicados
FROM area_milho;

-- Resultado: Não existem duplicados


-- ==========================================================
-- 3. ESTATÍSTICAS DESCRITIVAS POR ESTADO
-- ==========================================================

SELECT
    estado,
    MIN(valor) AS min_area,
    ROUND(AVG(valor), 2) AS media_area,
    MAX(valor) AS max_area,
    ROUND(STDDEV(valor), 2) AS desv_padrao
FROM area_milho
GROUP BY estado
ORDER BY desv_padrao DESC;

-- Insight:
-- Alta heterogeneidade entre municípios dentro do mesmo estado,
-- com presença de pequenos e grandes produtores.


-- ==========================================================
-- 4. PRODUÇÃO TOTAL POR ESTADO
-- ==========================================================

-- 4.1 Maiores produtores
SELECT 
    estado,
    SUM(valor) AS area_total
FROM area_milho
GROUP BY estado
ORDER BY area_total DESC
LIMIT 10;

-- Insight:
-- Forte concentração no Centro-Oeste (MT, MS, GO)


-- 4.2 Menores produtores
SELECT 
    estado,
    SUM(valor) AS area_total
FROM area_milho
GROUP BY estado
ORDER BY area_total ASC
LIMIT 10;


-- ==========================================================
-- 5. ESTATÍSTICAS GERAIS
-- ==========================================================

SELECT
    MIN(valor) AS min_area,
    ROUND(AVG(valor), 2) AS media_area,
    MAX(valor) AS max_area,
    ROUND(STDDEV(valor), 2) AS desv_padrao
FROM area_milho;

-- Insight:
-- Distribuição altamente assimétrica (skewed)
-- poucos municípios concentram grande parte da produção


-- ==========================================================
-- 6. TOP MUNICÍPIOS PRODUTORES
-- ==========================================================

SELECT 
    municipio,
    estado,
    SUM(valor) AS area_plantada
FROM area_milho
GROUP BY municipio, estado
ORDER BY area_plantada DESC
LIMIT 10;

-- Insight:
-- Forte concentração no Mato Grosso
-- Destaque: Sorriso (MT) como principal polo produtivo


-- ==========================================================
-- 7. CONCLUSÃO DA EDA (MILHO)
-- ==========================================================

/*
- A produção de milho está amplamente distribuída no Brasil
- Porém, altamente concentrada em poucos municípios
- A região Centro-Oeste domina a produção
- O estado do Mato Grosso é o principal polo agrícola
- Existe grande desigualdade entre pequenos e grandes produtores

IMPLICAÇÃO LOGÍSTICA:
- Possibilidade de criação de hubs logísticos em regiões estratégicas
- Priorização de grandes polos produtivos
- Redução de custos operacionais com rotas otimizadas
*/