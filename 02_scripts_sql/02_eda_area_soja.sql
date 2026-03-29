-- ==========================================================
-- PROJETO: AGROLOGÍSTICA BRASIL S.A.
-- ARQUIVO: eda_area_soja.sql
-- ETAPA: Análise Exploratória de Dados (EDA)
-- OBJETIVO: Entender distribuição, qualidade e concentração
--           da ÁREA PLANTADA de soja no Brasil
-- ==========================================================


-- ==========================================================
-- 1. VISÃO INICIAL DOS DADOS
-- ==========================================================

SELECT *
FROM area_soja
LIMIT 5;

-- Estrutura:
-- cod_municipio → identificador único
-- municipio     → nome do município
-- estado        → UF
-- valor         → área plantada (hectares)


-- ==========================================================
-- 2. QUALIDADE DOS DADOS
-- ==========================================================

-- 2.1 Valores nulos
SELECT 
    COUNT(*) FILTER (WHERE cod_municipio IS NULL) AS nulos_cod_municipio,
    COUNT(*) FILTER (WHERE municipio IS NULL) AS nulos_municipio,
    COUNT(*) FILTER (WHERE estado IS NULL) AS nulos_estado,
    COUNT(*) FILTER (WHERE valor IS NULL) AS nulos_valor
FROM area_soja;

-- Resultado esperado: sem valores nulos


-- 2.2 Duplicidade
SELECT 
    COUNT(*) AS total_linhas,
    COUNT(DISTINCT cod_municipio) AS municipios_unicos,
    COUNT(*) - COUNT(DISTINCT cod_municipio) AS registros_duplicados
FROM area_soja;

-- Resultado esperado: sem duplicados


-- ==========================================================
-- 3. ESTATÍSTICAS DESCRITIVAS POR ESTADO
-- ==========================================================

SELECT
    estado,
    MIN(valor) AS area_min_ha,
    ROUND(AVG(valor), 2) AS area_media_ha,
    MAX(valor) AS area_max_ha,
    ROUND(STDDEV(valor), 2) AS desvio_padrao_ha
FROM area_soja
GROUP BY estado
ORDER BY desvio_padrao_ha DESC;

-- Insight esperado:
-- Alta heterogeneidade → coexistência de pequenos e grandes produtores


-- ==========================================================
-- 4. DISTRIBUIÇÃO DA ÁREA PLANTADA POR ESTADO
-- ==========================================================

-- 4.1 Maiores estados produtores (área total)
SELECT 
    estado,
    SUM(valor) AS area_total_ha
FROM area_soja
GROUP BY estado
ORDER BY area_total_ha DESC
LIMIT 10;

-- Insight:
-- Presença relevante do Sul (RS, PR) junto ao Centro-Oeste


-- 4.2 Menores estados produtores
SELECT 
    estado,
    SUM(valor) AS area_total_ha
FROM area_soja
GROUP BY estado
ORDER BY area_total_ha ASC
LIMIT 10;


-- ==========================================================
-- 5. ESTATÍSTICAS GERAIS
-- ==========================================================

SELECT
    MIN(valor) AS area_min_ha,
    ROUND(AVG(valor), 2) AS area_media_ha,
    MAX(valor) AS area_max_ha,
    ROUND(STDDEV(valor), 2) AS desvio_padrao_ha
FROM area_soja;

-- Insight:
-- Distribuição assimétrica (skewed)
-- poucos municípios concentram grande área plantada


-- ==========================================================
-- 6. PRINCIPAIS MUNICÍPIOS (CONCENTRAÇÃO)
-- ==========================================================

SELECT 
    municipio,
    estado,
    SUM(valor) AS area_total_ha
FROM area_soja
GROUP BY municipio, estado
ORDER BY area_total_ha DESC
LIMIT 10;

-- Insight:
-- Forte concentração no Mato Grosso
-- Destaque para grandes polos agrícolas (ex: Sorriso - MT)

-- Interpretação estratégica:
-- Centro-Oeste e MATOPIBA → produção em larga escala (agronegócio industrial)
-- Sul → produção mais fragmentada (muitos municípios médios)


-- ==========================================================
-- 7. COMPARAÇÃO ENTRE CULTURAS (ÁREA PLANTADA)
-- ==========================================================

SELECT 
    'Milho' AS cultura, 
    SUM(valor) AS area_total_ha, 
    COUNT(*) AS qtd_municipios 
FROM area_milho

UNION ALL

SELECT 
    'Soja' AS cultura, 
    SUM(valor) AS area_total_ha, 
    COUNT(*) AS qtd_municipios 
FROM area_soja

ORDER BY area_total_ha DESC;

-- Interpretação:
-- Soja → maior área total e menor número de municípios (alta concentração)
-- Milho → menor área total e maior capilaridade territorial


-- ==========================================================
-- 8. CONCLUSÕES E IMPLICAÇÕES LOGÍSTICAS
-- ==========================================================

/*
1. ESPECIALIZAÇÃO (SOJA)
   - Alta densidade produtiva
   - Menor número de municípios
   - Forte presença em polos agrícolas (MT, BA)

2. CAPILARIDADE (MILHO)
   - Presente na maior parte do território
   - Produção mais distribuída

3. HETEROGENEIDADE
   - Grande variação entre municípios (pequenos vs gigantes)

4. ESTRUTURA REGIONAL
   - Centro-Oeste / MATOPIBA → produção concentrada e escalável
   - Sul → produção fragmentada

IMPLICAÇÕES LOGÍSTICAS:

- HUBS DE ALTA CAPACIDADE:
  Foco em regiões de alta densidade (ex: MT e oeste da BA)

- LOGÍSTICA DISTRIBUÍDA:
  Necessária para regiões fragmentadas (Sul e milho em geral)

- OTIMIZAÇÃO DE ROTAS:
  Aproveitar sobreposição entre soja e milho no Centro-Oeste
*/