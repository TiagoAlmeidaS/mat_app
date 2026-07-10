# Spec de Implementacao: Monetizacao e Recursos Pro do MatApp

## Objetivo

Transformar o MatApp em um produto freemium com limite de processamento no plano gratuito, anuncios bem posicionados e upgrade Pro com beneficios reais para estudantes e usuarios avancados.

Esta spec parte do estado atual do projeto Flutter e organiza a implementacao em uma ordem segura, com menor risco tecnico e melhor capacidade de validacao incremental.

## Estado Atual do Projeto

Com base no codigo atual:

- O app possui uma experiencia simples para calcular numeros primos em um intervalo.
- O calculo acontece localmente via `PrimesNumberService`.
- Nao existe camada formal de estado para sessao, premium, paywall ou anuncios.
- Nao existe persistencia local, autenticacao, analytics, backend ou pagamentos.
- A UX atual nao trata validacao de entrada, loading, erro, limites de uso ou resultados parciais.
- O projeto usa `flutter_modular`, o que ajuda a isolar novos modulos.

## Direcao de Produto

### Plano Gratuito

- Calculo de intervalos pequenos liberado sem atrito.
- Banner discreto apenas na tela de resultado.
- Para intervalos acima do limite gratuito:
  - bloquear o processamento completo, ou
  - liberar uma execucao maior via anuncio recompensado.

### Plano Pro

- Remocao de anuncios.
- Limite de processamento expandido ou ilimitado.
- Exportacao de resultados em formatos academicos.
- Analises matematicas avancadas sobre o intervalo.
- Historico e favoritos como etapa posterior.

## Principios de Implementacao

- Nao introduzir monetizacao antes de estabilizar o fluxo base de calculo.
- Separar regras de negocio de UI antes de adicionar ads e paywall.
- Evitar acoplamento direto entre tela de calculo e SDKs de monetizacao.
- Liberar primeiro o nucleo do modelo freemium, depois os recursos Pro avancados.
- Medir antes de escalar: eventos e conversao precisam existir desde as primeiras fases.

## Ordem Recomendada de Implementacao

## Fase 1: Fundacao Tecnica

### Objetivo

Preparar o app para suportar monetizacao sem crescer desorganizado.

### Escopo

- Criar uma camada de dominio para calculo de primos e regras de limite.
- Introduzir um estado global minimo para sessao do usuario e flags de premium.
- Estruturar modulos novos:
  - `premium_module`
  - `ads_module`
  - `analytics_module`
- Padronizar modelos:
  - `UserAccessState`
  - `PrimeCalculationRequest`
  - `PrimeCalculationResult`
  - `UsageGateDecision`
- Adicionar validacoes de entrada:
  - intervalo invalido
  - numeros negativos
  - inicio maior que fim
  - campos vazios
- Adicionar estados visuais:
  - carregando
  - erro
  - resultado vazio

### Ajustes importantes no codigo atual

- Revisar `PrimesNumberService`, pois hoje ele mistura geracao, validacao e filtragem em uma implementacao dificil de evoluir.
- Corrigir a navegacao para manter consistencia entre rotas com hifen e underscore.
- Preparar o calculo para execucao assincrona e futura migracao para isolate.
- Criar testes unitarios para a regra de primalidade e para os limites do plano gratuito.

### Criterios de aceite

- O usuario consegue calcular um intervalo com validacao adequada.
- O app diferencia sucesso, erro e processamento.
- Existe uma fonte unica para saber se o usuario e gratuito, recompensado temporariamente ou Pro.
- As regras de bloqueio nao ficam espalhadas pelas telas.

## Fase 2: Limites do Plano Gratuito

### Objetivo

Introduzir o modelo freemium sem ainda depender do pagamento completo.

### Escopo

- Definir limites configuraveis:
  - `freeMaxRangeSoft`
  - `freeMaxRangeRewarded`
  - `proMaxRange`
- Criar uma politica de acesso:
  - ate o limite gratuito: executa normalmente
  - acima do limite gratuito e ate o limite recompensado: exibe CTA para anuncio recompensado
  - acima do limite recompensado: exibe CTA de upgrade Pro
- Exibir resumo antes do calculo:
  - tamanho do intervalo
  - custo estimado de processamento
  - acao necessaria para continuar
- Implementar resultado parcial opcional:
  - mostrar primeiros N primos
  - ocultar restante com CTA de desbloqueio

### Decisao recomendada

Para a primeira versao, prefira bloqueio antes do processamento pesado em vez de calcular tudo e borrar depois. Isso reduz custo, simplifica regras e evita consumo excessivo no plano gratuito.

### Criterios de aceite

- O usuario gratuito entende por que o intervalo foi limitado.
- Existe um caminho claro entre "calcular gratis", "assistir anuncio" e "virar Pro".
- Os limites podem ser alterados sem reescrever a UI.

## Fase 3: Isolates e Performance

### Objetivo

Garantir que intervalos maiores nao degradem a experiencia.

### Escopo

- Migrar calculos pesados para isolate.
- Criar thresholds de processamento:
  - calculo inline para intervalos pequenos
  - isolate para intervalos medios e grandes
- Adicionar feedback de progresso:
  - spinner inicial
  - mensagens de status
  - tempo estimado simples, se viavel
- Medir tempo de execucao por faixa de intervalo.

### Criterios de aceite

- A UI continua responsiva durante calculos grandes.
- O tempo de calculo e capturado para analytics.
- O limite do plano gratuito pode ser justificado por custo de processamento real.

## Fase 4: Infra de Analytics

### Objetivo

Medir o funil antes de otimizar monetizacao.

### Eventos minimos

- `prime_calculation_started`
- `prime_calculation_completed`
- `prime_calculation_failed`
- `free_limit_hit`
- `rewarded_offer_shown`
- `rewarded_offer_accepted`
- `rewarded_offer_completed`
- `paywall_viewed`
- `paywall_cta_clicked`
- `premium_activated`

### Criterios de aceite

- Toda decisao de paywall gera evento.
- Toda tentativa de calculo grande pode ser analisada por faixa de intervalo.
- E possivel comparar uso gratuito versus conversao.

## Fase 5: Anuncios

### Objetivo

Monetizar usuarios gratuitos sem quebrar a UX principal.

### Escopo

- Integrar AdMob.
- Banner apenas na tela de resultado e fora da area critica de acao.
- Intersticial apenas depois de o usuario concluir um fluxo, nunca antes do calculo.
- Rewarded ad para liberar uma execucao acima do limite gratuito.
- Fallbacks:
  - sem anuncio carregado -> oferecer tentar novamente ou upgrade Pro

### Regras de UX

- Nao mostrar anuncio durante digitacao.
- Nao interromper um calculo em andamento.
- Nao mostrar intersticial em excesso.

### Criterios de aceite

- Usuarios gratuitos veem banner apenas em contexto apropriado.
- O rewarded ad realmente destrava uma execucao delimitada.
- O app se comporta bem mesmo quando o SDK de anuncio falha.

## Fase 6: Paywall e Assinatura/Compra

### Objetivo

Criar o fluxo de conversao para o MatApp Pro.

### Escopo

- Criar `PremiumModule` com:
  - tela de paywall
  - comparativo Free vs Pro
  - FAQ curta
  - restaurar compra
- Escolher provedor de compra in-app:
  - Android/iOS: compra nativa/in-app purchase
  - Web: tratar separadamente; Stripe nao deve ser assumido como solucao unica para mobile
- Salvar estado de entitlement localmente e sincronizar quando houver backend.

### Observacao importante

O conceito original cita AdMob e Stripe, mas para Flutter mobile a estrategia mais segura e usar compra nativa nas lojas para desbloqueio Pro. Stripe pode ser avaliado depois para web ou backoffice, nao como primeira aposta para o app mobile.

### Criterios de aceite

- O usuario consegue abrir o paywall de varios pontos do app.
- O estado Pro persiste apos reiniciar o app.
- Restaurar compra funciona para usuarios elegiveis.

## Fase 7: Recursos Pro de Alto Valor

### Objetivo

Fazer o upgrade vender por valor, nao apenas por remocao de ads.

### Ordem recomendada

1. Exportacao academica
2. Insights matematicos
3. Historico e favoritos
4. Sincronizacao em nuvem

### 7.1 Exportacao academica

- Exportar resultado para:
  - PDF
  - CSV
  - formato compativel com planilha
  - LaTeX
- Permitir incluir metadados:
  - intervalo consultado
  - quantidade de primos
  - data da geracao

### 7.2 Insights matematicos

- Quantidade de primos no intervalo
- Densidade aproximada
- Primos gemeos
- Fatoracao de numeros selecionados
- Goldbach como funcionalidade experimental, apenas se a implementacao estiver correta e testada

### 7.3 Historico e favoritos

- Salvar consultas recentes
- Favoritar intervalos
- Favoritar numeros ou resultados especiais

### Criterios de aceite

- Pelo menos um recurso Pro tem valor academico claro e comunicavel no paywall.
- Os recursos Pro nao aparecem como promessas vazias; todos devem estar ligados a dados reais.

## Backlog Tecnico Recomendado

### Estrutura de pastas sugerida

- `lib/app/core/`
- `lib/app/core/models/`
- `lib/app/core/services/`
- `lib/app/core/stores/`
- `lib/app/module/premium/`
- `lib/app/module/ads/`
- `lib/app/module/analytics/`
- `lib/app/module/prime_numbers/domain/`
- `lib/app/module/prime_numbers/presentation/`

### Dependencias provaveis

- gerenciamento de estado leve ou store reativa compativel com a arquitetura atual
- pacote de ads
- pacote de compras in-app
- persistencia local
- geracao de PDF/CSV
- graficos para visualizacao

## Riscos e Alertas

- O algoritmo atual de primos precisa ser validado antes de virar base de funcionalidades pagas.
- O app ainda nao demonstra infraestrutura para webhooks, backend de entitlements ou sync em nuvem.
- Stripe para mobile pode complicar compliance e fluxo; compras nativas tendem a ser melhores inicialmente.
- Mostrar resultado borrado apos calcular intervalos enormes pode gerar custo sem retorno; o bloqueio antecipado e mais seguro.

## MVP Recomendado

Se quisermos colocar monetizacao no ar com menor risco, o MVP deve incluir apenas:

- refatoracao do fluxo de calculo
- validacao e estados de loading/erro
- limite gratuito configuravel
- analytics basico
- banner na tela de resultado
- rewarded ad para uma execucao expandida
- paywall simples
- desbloqueio Pro sem anuncios e com limite maior

## Fora do MVP

- sincronizacao em nuvem
- multiplos planos de assinatura
- dashboard administrativo
- Goldbach e visualizacoes avancadas sem validacao matematica forte
- blur sofisticado com processamento completo no plano gratuito

## Sequencia Pratica de Execucao

1. Refatorar `PrimesNumberService` e criar testes.
2. Criar modelos de request/result/access e camada de regra de limites.
3. Melhorar UX da tela de calculo e da tela de resultado.
4. Introduzir analytics basico.
5. Implementar gating do plano gratuito.
6. Migrar calculos pesados para isolate.
7. Integrar banner e rewarded ad.
8. Criar paywall e desbloqueio Pro.
9. Entregar o primeiro recurso Pro real: exportacao.
10. Iterar com insights matematicos e historico.

## Proxima Entrega Recomendada

A proxima tarefa ideal de implementacao e uma spec tecnica menor para a Fase 1, detalhando:

- refatoracao do servico de primos
- contratos de estado do usuario
- regras de limite do free/pro
- ajustes de navegacao e UX das telas atuais

Essa etapa cria a base certa para que anuncios, paywall e premium entrem depois sem retrabalho grande.
