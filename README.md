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

### 2. Atualização Diária (`prc_atualiza_tb_vendas_genie.sql`)
A rotina de atualização (ETL) foi construída para ser segura e podendo ser rodada várias vezes sem duplicação dos dados.
* **Janela Móvel de 30 Dias:** O script apaga os dados dos últimos 30 dias de venda (`CURRENT_DATE() - 30`) e os insere novamente. Isso garante que qualquer mudança de status do pedido (ex: de "pendente" para "faturado" ou "cancelado") seja atualizada retroativamente.
* **Campos com nomes semânticos:** O código transforma os nomes dos campos para nomes semânticos visando a melhor interpretação do LLM. Além de ter uma performance melhor, isso garante menos alucinações por parte da IA. 
* **Transformações e Limpeza:** O código padroniza textos (com `UPPER` e `TRIM`), extrai informações de fontes complexas (`REGEXP_EXTRACT`), converte ciclos para o formato amigável ('CICLO XX') e mapeia dezenas de canais de mídia e origem de tráfego. Estas transformações garantem que os dados serão encontrados de forma mais rápida e precisa pelo agente de LLM.

---

## 📖 Metadata Schema

O projeto possui o Metadata Schema em duas linguagens (português e inglês).
A versão em português facilita o entendimento e manutenção de descrições ou regras de negócio que podem ser necessárias com a evolução do projeto.
A versão em inglês é a mais adequada para ser inserida no prompt do LLM por ser o idioma que a maioria dos agentes interpreta melhor. Com o json em inglês os resultados tendem a ser mais precisos e com menos alucinações.

Em caso de manutenção dos metadados, é necessário ajustar nos dois arquivos para não ter divergências entre as versões. 

---

## 🛠️ Como Implementar (Instruções de Uso)

1. **Primeira Execução:** Rode o script `prc_cria_tb_vendas_genie.sql` no seu ambiente de banco de dados (ex: BigQuery). Isso criará a estrutura da tabela com as partições corretas.
2. **Carga Diária:** Agende o script `prc_atualiza_tb_vendas_genie.sql` em sua ferramenta de execução de rotinas (como Airflow ou tarefas agendadas nativas do seu banco), atualizando os dados dos últimos 30 dias.
