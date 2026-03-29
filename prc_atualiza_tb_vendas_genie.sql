CREATE OR REPLACE PROCEDURE `prc_atualiza_tb_vendas_genie`()
BEGIN
BEGIN TRANSACTION;

-- DELETA OS ÚLTIMOS 30 DIAS DA TABELA, POIS VAMOS REPROCESSÁ-LOS NO INSERT

DELETE FROM `tb_vendas_genie`
WHERE data_venda >= CURRENT_DATE() - 30;


-- INSERE OS DADOS DE VENDAS DOS ÚLTIMOS 30 DIAS NA TABELA

INSERT INTO `tb_vendas_genie` (
    codigo_unidade_negocio, codigo_pedido, data_venda, data_hora_venda, ciclo, 
    ano_ciclo, descricao_ciclo, codigo_produto, codigo_produto_pai, nome_marca, 
    nome_categoria, produto_combo_kit, estado_uf, nome_regiao, nome_cidade, 
    valor_receita_bruta, valor_receita_faturada, valor_venda_pago, valor_venda_desconto, 
    status_pedido, pedido_faturado, pedido_aprovado, pedido_faturado_aprovado, 
    nome_canal_venda, origem_trafego, canal_midia, grupo_canal_midia, nome_cupom, tipo_entrega, 
    cpf_consumidor_anonimizado
  )


  SELECT

  -- INFORMAÇÕES DE UNIDADE DE NEGÓCIO E PEDIDO
    cod_un_negocio AS codigo_unidade_negocio,
    cod_pedido AS codigo_pedido,

  -- DATAS E CICLOS
    CAST(dt_venda AS DATE) AS data_venda,
    dt_hora_venda AS data_hora_venda,
    CONCAT('CICLO ',SUBSTR(CAST(cod_ciclo AS STRING), 5)) AS ciclo, /* TRANSFORMA O COD_CICLO NO FORMATO 'CICLO XX' SEM O ANO */
    CAST(SUBSTR(CAST(cod_ciclo AS STRING), 1, 4) AS INT64) AS ano_ciclo,
    UPPER(TRIM(des_ciclo)) AS descricao_ciclo,

  -- INFORMAÇÕES SOBRE O PRODUTO 
    cod_material AS codigo_produto,
    cod_material_pai AS codigo_produto_pai,
    UPPER(TRIM(marca_ind)) AS nome_marca,
    UPPER(TRIM(categoria_final_nivel1)) AS nome_categoria,    
    CASE 
      WHEN UPPER(TRIM(apresentacao_combo)) = 'INDIVIDUAL' THEN FALSE 
      ELSE TRUE
    END AS produto_combo_kit, /* FLAG BOOLEANA INDICANDO SE O PRODUTO É UM KIT.*/

  -- INFORMACÕES GEOGRÁFICAS
    UPPER(TRIM(uf)) AS estado_uf,
    UPPER(TRIM(regiao)) AS nome_regiao,
    UPPER(TRIM(des_cidade)) AS nome_cidade,

  -- MÉTRICAS FINANCEIRAS
    CAST(vlr_receita_bruta_omni AS FLOAT64) AS valor_receita_bruta,
    CAST(vlr_receita_faturada AS FLOAT64) AS valor_receita_faturada,
    CAST(vlr_venda_pago AS FLOAT64) AS valor_venda_pago,
    CAST(vlr_venda_desconto AS FLOAT64) AS valor_venda_desconto,

  --STATUS DO PEDIDO
    UPPER(TRIM(REGEXP_EXTRACT(status_oms, r'\.(.*)'))) AS status_pedido,
    CASE 
      WHEN flg_faturada = 1 THEN TRUE 
      ELSE FALSE 
    END AS pedido_faturado,
    CASE 
      WHEN flg_aprovada = 1 THEN TRUE 
      ELSE FALSE 
    END AS pedido_aprovado,
    CASE 
      WHEN flg_faturada = 1 AND flg_aprovada = 1 THEN TRUE 
      ELSE FALSE 
    END AS pedido_faturado_aprovado, /* FLAG BOOLEANA INDICANDO SE O PEDIDO ESTÁ FATURADO E APROVADO */

  -- INFORMAÇÕES CANAIS DE VENDA, MARKETING E CUPONS 
    REPLACE(UPPER(TRIM(des_canal_venda_final)),'MKTP','MARKETPLACE') AS nome_canal_venda,
    UPPER(TRIM(REGEXP_EXTRACT(fonte_de_trafego_nivel_1, r'\.(.*)'))) AS origem_trafego,
    CASE
      WHEN des_midia_canal IS NULL THEN 'NÃO RASTREADO'
      WHEN LOWER(des_midia_canal) = '(direct)' THEN 'ACESSO DIRETO'
      WHEN LOWER(des_midia_canal) LIKE '%facebook%' THEN 'FACEBOOK'
      WHEN LOWER(des_midia_canal) LIKE '%twitter%' THEN 'TWITTER'
      WHEN LOWER(des_midia_canal) LIKE '%tiktok%' THEN 'TIK TOK'
      WHEN LOWER(des_midia_canal) LIKE '%instagram%' THEN 'INSTAGRAM'
      WHEN LOWER(des_midia_canal) LIKE '%youtube%' THEN 'YOUTUBE'
      WHEN LOWER(des_midia_canal) LIKE '%chatgpt%' THEN 'CHAT GPT'
      WHEN LOWER(des_midia_canal) LIKE '%perplexity%' THEN 'PERPLEXITY'
      WHEN LOWER(des_midia_canal) LIKE '%gemini%' THEN 'GEMINI'
      WHEN LOWER(des_midia_canal) LIKE '%google%' THEN 'GOOGLE'
      WHEN LOWER(des_midia_canal) LIKE '%yahoo%' THEN 'YAHOO'
      WHEN LOWER(des_midia_canal) LIKE '%bing%' THEN 'BING'
      WHEN LOWER(des_midia_canal) LIKE '%salesforce%' OR LOWER(des_midia_canal) LIKE '%salesfoce%' THEN 'SALESFORCE'
      WHEN LOWER(des_midia_canal) LIKE '%affiliate%' THEN 'AFILIADO'
      WHEN LOWER(des_midia_canal) LIKE '%rtbhouse%' THEN 'RTB HOUSE'
      WHEN LOWER(des_midia_canal) LIKE '%socialorganico%' THEN 'SOCIAL ORGANICO'
      WHEN LOWER(des_midia_canal) LIKE '%transacional%' THEN 'TRANSACIONAL'
      WHEN LOWER(des_midia_canal) LIKE '%app%' THEN 'APP'
      ELSE UPPER(des_midia_canal)
    END AS canal_midia, /* MAPEAMENTO DE CANAIS DE MÍDIA */
    CASE
      WHEN des_midia_canal IS NULL THEN 'NÃO RASTREADO'
      WHEN LOWER(des_midia_canal) = '(direct)' THEN 'ACESSO DIRETO'
      WHEN 
        LOWER(des_midia_canal) LIKE '%facebook%' 
        OR LOWER(des_midia_canal) LIKE '%twitter%'
        OR LOWER(des_midia_canal) LIKE '%tiktok%'
        OR LOWER(des_midia_canal) LIKE '%instagram%'
        OR LOWER(des_midia_canal) LIKE '%youtube%'
      THEN 'REDES SOCIAIS'
      WHEN 
        LOWER(des_midia_canal) LIKE '%chatgpt%'
        OR LOWER(des_midia_canal) LIKE '%perplexity%'
        OR LOWER(des_midia_canal) LIKE '%gemini%' 
      THEN 'BUSCADORES DE IA'      
      WHEN 
        LOWER(des_midia_canal) LIKE '%google%'
        OR LOWER(des_midia_canal) LIKE '%yahoo%'
        OR LOWER(des_midia_canal) LIKE '%bing%'
      THEN 'MECANISMOS DE BUSCA'
      WHEN LOWER(des_midia_canal) LIKE '%salesforce%' OR LOWER(des_midia_canal) LIKE '%salesfoce%' THEN 'SALESFORCE'
      WHEN LOWER(des_midia_canal) LIKE '%affiliate%' THEN 'AFILIADO'
      WHEN LOWER(des_midia_canal) LIKE '%rtbhouse%' THEN 'RTB HOUSE'
      WHEN LOWER(des_midia_canal) LIKE '%socialorganico%' THEN 'SOCIAL ORGANICO'
      WHEN LOWER(des_midia_canal) LIKE '%transacional%' THEN 'TRANSACIONAL'
      WHEN LOWER(des_midia_canal) LIKE '%app%' THEN 'APP'
      ELSE UPPER(des_midia_canal)
    END AS grupo_canal_midia, /* MAPEAMENTO DE GRUPOS DE CANAIS DE MÍDIA */
      UPPER(TRIM(des_cupom)) AS nome_cupom,

  -- INFORMAÇÕES DE LOGÍSTICA 
    CASE
      WHEN flg_pedidos_cd = 1 THEN 'ENTREGA PADRÃO'
      WHEN flg_pedidos_pickup = 1 THEN 'RETIRADO NA LOJA'
      ELSE 'NÃO ENTREGUE'
    END as tipo_entrega, 
    
  -- INFORMAÇÃO CONSUMIDOR
    cpf_hash AS cpf_consumidor_anonimizado  /* SOMENTE CPF ANONIMIZADO POR QUESTÕES DE SEGURANÇA */

  FROM 
    `tb_vendas`
  WHERE 
    dt_venda >= CURRENT_DATE() - 30  /* REPROCESSAMOS SOMENTE OS ÚLTIMOS 30 DIAS DE VENDAS */
;
COMMIT TRANSACTION; 
END;