-- Cria a estrutura vazia da tabela com particionamento e clusterização
CREATE TABLE `tb_vendas_genie`
(
  codigo_unidade_negocio STRING,
  codigo_pedido STRING,
  data_venda DATE,
  data_hora_venda TIMESTAMP,
  ciclo STRING,
  ano_ciclo INT64,
  descricao_ciclo STRING,
  codigo_produto STRING,
  codigo_produto_pai STRING,
  nome_marca STRING,
  nome_categoria STRING,
  produto_combo_kit BOOLEAN,
  estado_uf STRING,
  nome_regiao STRING,
  nome_cidade STRING,
  valor_receita_bruta FLOAT64,
  valor_receita_faturada FLOAT64,
  valor_venda_pago FLOAT64,
  valor_venda_desconto FLOAT64,
  status_pedido STRING,
  pedido_faturado BOOLEAN,
  pedido_aprovado BOOLEAN,
  pedido_faturado_aprovado BOOLEAN,
  nome_canal_venda STRING,
  origem_trafego STRING,
  canal_midia STRING,
  grupo_canal_midia STRING,
  nome_cupom STRING,
  tipo_entrega STRING,
  cpf_consumidor_anonimizado STRING
)
PARTITION BY data_venda
CLUSTER BY nome_marca, nome_categoria, nome_canal_venda, canal_midia;