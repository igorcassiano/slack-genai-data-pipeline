# slack-genai-data-pipeline
Fundação de dados (camada semântica) robusta e otimizada para alimentar Inteligência Artificial (LLM) integrada ao Slack.

# 📊 Projeto: Camada Semântica da Tabela de Vendas (tb_vendas_genie)

## 🎯 Visão Geral do Projeto

Este projeto tem como objetivo criar a camada semântica da tabela `tb_vendas` para que os dados sejam apropriados para a utilização de uma GenAI integrada ao Slack.  
A tabela `tb_vendas_genie` possui tratamento, modelagem e documentação otimizados para o consumo do LLM.

---

## ⚙️ Procedimentos e Arquitetura

A construção e manutenção desta tabela são divididas em duas etapas principais:

### 1. Criação da Tabela (`prc_cria_tb_vendas_genie.sql`)
A estrutura inicial da tabela foi desenhada focando em alta performance e redução de custos no banco de dados:
* **Particionamento:** A tabela é particionada pela coluna `data_venda`. Isso significa que consultas filtradas por data lerão apenas os dados necessários, não a tabela inteira.
* **Clusterização:** Os dados são fisicamente organizados pelas colunas `nome_marca`, `nome_categoria`, `nome_canal_venda` e `canal_midia`, acelerando drasticamente os filtros mais comuns usados pelos analistas.
* **Carga Histórica:** Na criação da tabela são carregados os dados históricos da `tb_vendas` desde 2022. 
  
### 2. Atualização Diária (`prc_atualiza_tb_vendas_genie.sql`)
A rotina de atualização (ETL) foi construída para ser segura e podendo ser rodada várias vezes sem duplicação dos dados.
* **Janela Móvel de 30 Dias:** O script apaga os dados dos últimos 30 dias de venda (`CURRENT_DATE() - 30`) e os insere novamente. Isso garante que qualquer mudança de status do pedido (ex: de "pendente" para "faturado" ou "cancelado") seja atualizada retroativamente.
* **Campos com nomes semânticos:** O código transforma os nomes dos campos para nomes semânticos visando a melhor interpretação do LLM. Além de ter uma performance melhor, isso garante menos alucinações por parte da IA. 
* **Transformações e Limpeza:** O código padroniza textos (com `UPPER` e `TRIM`), extrai informações de fontes complexas (`REGEXP_EXTRACT`), converte ciclos para o formato amigável e agrupa informações. Estas transformações garantem que os dados serão encontrados de forma mais rápida e precisa pelo agente de LLM.

---

## 🔄 Informações Adicionadas ou Transformadas

Para garantir a melhor performance de interpretação do LLM, os seguintes campos sofreram engenharia de recursos (feature engineering) a partir da tabela bruta:

* **`ciclo` e `ano_ciclo`:** Quebra o campo `cod_ciclo` para facilitar o entendimento do LLM (geralmente as perguntas se referem ao 'Ciclo 01' do ano atual e não ao ciclo '202601').
* **`produto_combo_kit`:** Criado para indicar se o produto é kit ou não (facilidade para coletar as vendas deste tipo de produto).
* **`pedido_faturado` e `pedido_aprovado`:** Transforma os campos `flg_faturada` e `flg_aprovada`, respectivamente, em campos booleanos com nomes semânticos para serem melhor relacionados com as perguntas.
* **`pedido_faturado_aprovado`:** Agrupa pedidos que estão aprovados e faturados, pois é um tipo de pergunta recorrente, deixando mais simples o filtro destes pedidos na IA.
* **`nome_canal_venda`:** Tratamento dos nomes com a abreviação 'MKTP' para 'MARKETPLACE'. Desta forma fica mais legível para identificação do LLM.
* **`status_pedido` e `origem_trafego`:** Extração dos números dos campos para facilitar a compreensão (ex: De '1. CANCELADO' para 'CANCELADO' ou '1. PAGOS' para 'PAGOS').
* **`canal_midia`:** Mapeamento de diferentes nomes para normalização do canal. Ex.: 'Facebook.com' e 'facebookads' são mapeados de forma unificada como 'FACEBOOK'.
* **`grupo_canal_midia`:** Agrupa canais de mídias em grupos maiores como 'BUSCADORES DE IA' (para Gemini, ChatGPT, Perplexity), 'REDES SOCIAIS' (para 'Instagram', 'Facebook', 'TikTok'), entre outros.
* **`tipo_entrega`:** Unifica as informações de `flg_pedidos_cd` e `flg_pedidos_pickup` em um campo só, trazendo o tipo final da entrega.

---

## 🗑️ Informações Excluídas da Tabela Nativa

Com o objetivo de manter a tabela limpa, performática e aderente às políticas de privacidade, os seguintes campos da tabela de origem não foram levados para a camada semântica:

* **`apresentacao_combo`:** Transformado no campo booleano `produto_combo_kit`.
* **`cod_ciclo`:** Substituído pela quebra nos campos mais claros `ciclo` e `ano_ciclo`.
* **`flg_pedidos_cd` e `flg_pedidos_pickup`:** Removidos individualmente pois foram unificados no campo `tipo_entrega`.
* **`cpf_consumidor_full`:** Retirado da base por conter informações de dados pessoais sensíveis, respeitando as diretrizes de privacidade e segurança (LGPD). Em seu lugar, levamos apenas o campo `cpf_hash` (`cpf_consumidor_anonimizado`) para permitir a contagem de clientes únicos sem expor suas identidades.

---

## ⚠️ Limitações e Trabalhos Futuros

* **Cálculo de ROI:** A base atual de vendas (`tb_vendas`) contém informações detalhadas de receita e os cupons aplicados, mas **não possui os dados de custo de campanha (investimento em mídia/marketing)**. 
* **Decisão:** Para evitar alucinações da IA, deixamos explícito nos campos que envolvem informações de marketing e cupons que, caso seja questionado sobre o ROI, declarar que só pode fornecer a receita bruta/líquida gerada.
* **Próximo Passo (Fase 2):** Será necessária a ingestão e o cruzamento dos dados das plataformas de Ads (Google Ads, Meta Ads) com esta camada semântica para viabilizar o cálculo exato do ROI.

---

## 📖 Metadata Schema

O projeto possui o Metadata Schema em duas linguagens (português e inglês).
A versão em português facilita o entendimento e manutenção de descrições ou regras de negócio que podem ser necessárias com a evolução do projeto.
A versão em inglês é a mais adequada para ser inserida no prompt do LLM por ser o idioma que a maioria dos agentes interpreta melhor. Com o json em inglês os resultados tendem a ser mais precisos e com menos alucinações.

Em caso de manutenção dos metadados, é necessário ajustar nos dois arquivos para não ter divergências entre as versões. 

---

## 🛠️ Como Implementar (Instruções de Uso)

1. **Criação da tabela e carga histórica:** Rode o script `prc_cria_tb_vendas_genie.sql` no seu ambiente de banco de dados (ex: BigQuery). Isso criará a estrutura da tabela com as partições corretas e fará a carga histórica da `tb_vendas` desde 2022.
2. **Carga Diária:** Agende o script `prc_atualiza_tb_vendas_genie.sql` em sua ferramenta de execução de rotinas (como Airflow ou tarefas agendadas nativas do seu banco), atualizando os dados dos últimos 30 dias.
