Olá, equipe! 👋

Tenho o prazer de anunciar o lançamento da versão 1.0 da nova tabela analítica tb_vendas_genie.

Este projeto foi desenvolvido do zero com um objetivo claro: criar uma fundação de dados (camada semântica) robusta e otimizada para alimentar o E-comm Genie, nossa Inteligência Artificial (LLM) integrada ao Slack.

✨ O que há de novo e quais os benefícios?

Zero Alucinações para a IA: Os dados de vendas passaram por um rigoroso processo de limpeza, padronização e renomeação semântica. Isso significa que a nossa GenAI agora consegue interpretar as informações de vendas com muito mais precisão e segurança.

Alta Performance e Baixo Custo: A arquitetura da tabela conta com particionamento por data de venda e clusterização inteligente de atributos. Na prática, nossas consultas (e as do robô) ficaram muito mais rápidas e baratas.

Metadados em dois idiomas e com termos de pesquisa em destaque: Lançamos um Dicionário de Dados (Metadata Schema) completo em Português (para a manutenção do nosso time) e em Inglês (otimizado para o prompt do LLM, garantindo melhores respostas). Além disso, termos mais buscados em possíveis perguntas dos dos usuários são destacados como valores comuns nos campos. Isso direciona melhor as respostas e traz resultados mais precisos.

Obs.: A tabela não possui dados de custo de mídia. Desta forma, perguntas como o ROI (Retorno sobre Investimento) serão respondidas como não sendo possíveis de calcular.

Privacidade e Ações Direcionadas (CRM): Em total conformidade com a LGPD e nossas políticas de segurança, os dados sensíveis dos consumidores (como o CPF) foram anonimizados. Dessa forma, a nossa GenAI pode ranquear e identificar perfis de compra com segurança. Caso alguma análise gere ações direcionadas a clientes específicos (como o envio de brindes aos top compradores), é necessário acionar o time de CRM. Eles utilizarão os identificadores anonimizados para consultar os dados reais dos clientes de forma segura e em ambiente controlado.

Atualização Segura: Nossa nova pipeline de ETL atualiza os dados diariamente de forma segura, garantindo que mudanças de status de pedidos sejam refletidas de forma retroativa sem o risco de duplicidade.

A documentação completa e os scripts de implementação já estão disponíveis no nosso repositório.

Vamos juntos transformar a forma como consumimos dados! 📊🤖