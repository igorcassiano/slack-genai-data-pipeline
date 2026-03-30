Olá, equipe! 👋

Tenho o prazer de anunciar o lançamento da versão 1.0 da nova tabela analítica tb_vendas_genie.

Este projeto foi desenvolvido do zero com um objetivo claro: criar uma fundação de dados (camada semântica) robusta e otimizada para alimentar o E-comm Genie, nossa Inteligência Artificial (LLM) integrada ao Slack.

✨ O que há de novo e quais os benefícios?

Zero Alucinações para a IA: Os dados de vendas passaram por um rigoroso processo de limpeza, padronização e renomeação semântica. Isso significa que a nossa GenAI agora consegue interpretar as informações de vendas com muito mais precisão e segurança.

Alta Performance e Baixo Custo: A arquitetura da tabela conta com particionamento por data de venda e clusterização inteligente de atributos. Na prática, nossas consultas ficaram muito mais rápidas e baratas.

Agrupamentos de marketing:  Mapeamento de diferentes nomes para normalização dos canais de mídia. Ex.: 'Facebook.com' e 'facebookads' são mapeados de forma unificada como 'FACEBOOK'. Da mesma forma, criamos um agrupamento em um nível acima para centralizar o que são canais de 'REDES SOCIAIS', 'BUSCADORES DE IA' e 'MECANISMOS DE BUSCAS'. Assim garantimos que os canais ou agrupamentos destes sejam interpretados de forma clara e completa pelo E-comm Genie.

Obs.: A tabela não possui dados de custo de mídia. Desta forma, perguntas relacionados ao ROI (Retorno sobre Investimento), por exemplo, não retornarão resultados.

Privacidade do nosso consumidor: Em total conformidade com a LGPD e nossas políticas de segurança, os dados sensíveis dos consumidores (como o CPF) foram anonimizados. Dessa forma, a nossa GenAI pode ranquear e identificar perfis de compra com segurança. Caso alguma análise gere ações direcionadas a clientes específicos (como o envio de brindes aos top compradores), é necessário acionar o time de CRM. Eles utilizarão os identificadores anonimizados para consultar os dados reais dos clientes de forma segura e em ambiente controlado.

Metadados em dois idiomas e com termos de pesquisa em destaque: Criamos um esquema de metadados completo em Português (para facilitar a manutenção) e traduzido em Inglês (otimizado para o prompt do LLM, garantindo melhores respostas). Além disso, trazemos os possíveis valores que são encontrados nos campos. Isso direciona melhor de onde a IA coletará as respostas e traz resultados mais precisos.

Atualização Segura: Nossa nova pipeline de ETL atualiza os dados diariamente de forma segura, garantindo que mudanças de status de pedidos sejam refletidas de forma retroativa sem o risco de duplicidade.

A documentação completa e os scripts de implementação já estão disponíveis no nosso repositório.

Vamos juntos transformar a forma como consumimos dados! 📊🤖
