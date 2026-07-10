# Spec de Implementacao: Ads, Assinatura e LTV do MatApp

## Objetivo

Definir uma spec unica para:

- integracao de anuncios no MatApp
- assinatura para remover anuncios e desbloquear beneficios Pro
- instrumentacao e funcionalidades que aumentem e tornem mensuravel o LTV do assinante

Esta spec assume o estado atual do projeto, incluindo:

- fundacao tecnica da Fase 1 ja implementada
- gating de acesso `free`, `rewarded` e `pro` ja introduzido
- fluxo principal de calculo e resultado ja desacoplado da UI

## Resultado Esperado

Ao final desta iniciativa, o MatApp deve:

- monetizar usuarios gratuitos com Ads sem degradar o fluxo principal
- converter parte dos usuarios para assinatura Pro
- persistir e restaurar entitlement de assinatura
- medir receita indireta e direta por usuario
- criar mecanismos para aumentar recorrencia, retencao e valor de vida do assinante

## Escopo

### Incluido

- banner, interstitial e rewarded ads
- assinatura Pro para remover anuncios
- paywall com comparativo Free vs Pro
- persistencia local de entitlement
- analytics de monetizacao
- eventos para cohorts, conversao e retencao
- funcionalidades iniciais para elevar LTV

### Nao incluido nesta entrega

- backend financeiro completo
- sync cross-device com conta obrigatoria
- multiplos niveis de assinatura complexos
- desconto via cupom
- plano familiar
- dashboard administrativo externo

## Principios de Produto

- Ads nunca devem interromper digitacao ou processamento em andamento.
- A assinatura deve vender valor, nao apenas remocao de Ads.
- Rewarded access deve ser tratado como ponte para conversao, nao destino final.
- Toda decisao de monetizacao precisa ser mensuravel por evento.
- LTV deve ser desenhado desde a instrumentacao, nao apenas medido depois.

## Arquitetura de Monetizacao

## 1. Modelo de Acesso

### Estados de acesso

- `free`
- `rewarded`
- `pro`

### Regras de alto nivel

- `free`:
  - anuncios ativos
  - limite soft de consulta
  - acesso expandido apenas via rewarded
- `rewarded`:
  - libera consulta expandida temporaria
  - anuncios continuam ativos
  - nao remove banner/interstitial
- `pro`:
  - remove anuncios
  - desbloqueia limite maior de consulta
  - habilita recursos Pro

### Decisao de produto

O estado `rewarded` nao substitui a assinatura. Ele apenas destrava uma janela de uso expandido com friccao controlada para estimular upgrade.

## 2. Ads

## 2.1 Tipos de anuncio

### Banner

Uso:

- apenas em tela de resultado
- abaixo do conteudo principal
- nunca cobrindo CTA de navegacao ou botao de novo calculo

Objetivo:

- monetizacao passiva do usuario gratuito

### Interstitial

Uso:

- somente apos o usuario concluir um fluxo
- preferencialmente quando ele sair da tela de resultado ou iniciar nova consulta apos uma sequencia de uso

Objetivo:

- elevar ARPDAU do usuario gratuito sem sabotar a primeira impressao

Regra:

- nao mostrar em toda consulta
- aplicar frequencia controlada

### Rewarded

Uso:

- quando o intervalo exceder o limite gratuito e estiver dentro do limite expandido

Objetivo:

- permitir consulta maior
- criar momento de venda para assinatura

Regra:

- um rewarded libera apenas uma janela temporaria de acesso expandido
- se nao houver anuncio disponivel, oferecer fallback para paywall

## 2.2 Provedor recomendado

### Mobile

- AdMob como primeira integracao

### Camada de abstracao recomendada

- `AdsService`
- `BannerAdController`
- `InterstitialAdController`
- `RewardedAdController`

### Objetivo da abstracao

- evitar acoplamento da UI ao SDK de anuncios
- permitir mock em testes
- facilitar fallback quando anuncio falha ou nao carrega

## 2.3 Estrutura sugerida

- `lib/app/module/ads/`
- `lib/app/module/ads/services/`
- `lib/app/module/ads/controllers/`
- `lib/app/module/ads/widgets/`
- `lib/app/module/ads/models/`

### Contratos sugeridos

#### `AdsAvailability`

Campos:

- `bool bannerAvailable`
- `bool interstitialAvailable`
- `bool rewardedAvailable`

#### `RewardedAccessGrant`

Campos:

- `DateTime grantedAt`
- `DateTime expiresAt`
- `String source`

#### `AdsService`

Metodos:

- `Future<void> initialize()`
- `Future<bool> preloadInterstitial()`
- `Future<bool> preloadRewarded()`
- `Future<bool> showInterstitialIfEligible()`
- `Future<bool> showRewardedForExpandedAccess()`
- `bool shouldShowBanner(UserAccessState accessState)`

## 2.4 Regras de elegibilidade

### Banner

- exibir apenas para `free` e `rewarded`
- ocultar para `pro`

### Interstitial

- exibir apenas para `free`
- aplicar cooldown por tempo ou por numero de consultas
- nunca mostrar na primeira consulta da sessao

### Rewarded

- exibir apenas quando `UsageGateDecision` for `requireRewardedAccess`
- se rewarded falhar:
  - exibir mensagem amigavel
  - exibir CTA para assinatura

## 3. Assinatura Pro

## 3.1 Objetivo

Oferecer assinatura simples que:

- remove Ads
- aumenta o limite de consulta
- habilita beneficios adicionais com valor academico

## 3.2 Modelo recomendado

### Primeira versao

- 1 plano mensal
- 1 plano anual

### Beneficios do Pro

- remocao total de banner e interstitial
- sem necessidade de rewarded para consulta expandida
- limite maior de processamento
- exportacao academica
- historico/favoritos quando forem entregues
- acesso prioritario a recursos de analise

## 3.3 Plataforma de compra

### Recomendacao principal

- Android/iOS: compra nativa via in-app purchase

### Observacao

Nao assumir Stripe como caminho principal do app mobile. Stripe pode existir depois para web, landing page externa ou backoffice.

## 3.4 Estrutura sugerida

- `lib/app/module/premium/`
- `lib/app/module/premium/services/`
- `lib/app/module/premium/models/`
- `lib/app/module/premium/stores/`
- `lib/app/module/premium/pages/`

### Contratos sugeridos

#### `SubscriptionPlan`

Campos:

- `String productId`
- `String title`
- `String description`
- `String billingPeriod`
- `String priceLabel`
- `bool isHighlighted`

#### `EntitlementState`

Campos:

- `bool isActive`
- `String source`
- `String? productId`
- `DateTime? activatedAt`
- `DateTime? expiresAt`
- `bool willRenew`

#### `SubscriptionService`

Metodos:

- `Future<void> initialize()`
- `Future<List<SubscriptionPlan>> loadPlans()`
- `Future<bool> purchase(String productId)`
- `Future<bool> restorePurchases()`
- `Future<EntitlementState> refreshEntitlement()`

## 3.5 Paywall

### Entradas do paywall

- tentativa de calcular acima do limite expandido
- fallback do rewarded indisponivel
- CTA persistente na tela de calculo
- CTA sutil na tela de resultado

### Conteudo minimo

- headline clara
- comparativo Free vs Pro
- destaque para "sem anuncios"
- destaque para limite expandido
- destaque para recurso Pro real
- CTA mensal
- CTA anual
- restaurar compra

### Regras de UX

- nao abrir paywall sem contexto
- explicar o motivo do bloqueio
- permitir fechar sem travar o usuario

## 4. Persistencia de Entitlement

## Objetivo

Persistir o estado Pro localmente para que o app reabra corretamente mesmo antes de refresh online.

### Estrutura recomendada

- `EntitlementRepository`
- persistencia local simples

### Fluxo

1. app inicia
2. carrega entitlement local
3. ajusta `UserAccessStore`
4. tenta refresh com provider de compra
5. reconcilia estado

### Criterios de aceite

- usuario Pro reabre o app sem ver Ads enquanto o entitlement estiver valido
- restaurar compra repoe o estado corretamente

## 5. Analytics de Monetizacao

## 5.1 Objetivo

Medir receita, conversao, recorrencia e sinais de LTV.

## 5.2 Eventos obrigatorios

### Ads

- `ad_banner_impression`
- `ad_interstitial_impression`
- `ad_interstitial_click`
- `ad_rewarded_offer_shown`
- `ad_rewarded_started`
- `ad_rewarded_completed`
- `ad_rewarded_failed`
- `ad_rewarded_access_granted`

### Assinatura

- `paywall_viewed`
- `paywall_closed`
- `paywall_plan_selected`
- `subscription_checkout_started`
- `subscription_purchase_success`
- `subscription_purchase_failed`
- `subscription_restored`
- `subscription_renewal_detected`
- `subscription_canceled_detected`

### Valor e retencao

- `first_value_moment`
- `pro_feature_used`
- `export_used`
- `favorite_saved`
- `history_revisited`
- `session_depth_reached`
- `return_after_1d`
- `return_after_7d`
- `return_after_30d`

## 5.3 Propriedades recomendadas dos eventos

- `plan_state`
- `interval_length`
- `gate_action`
- `result_count`
- `session_index`
- `days_since_install`
- `paywall_entry_point`
- `selected_plan_id`
- `subscription_status`
- `rewarded_grant_source`

## 6. LTV

## 6.1 Definicao operacional

Para o MatApp, o LTV deve combinar:

- receita de Ads de usuarios gratuitos
- receita recorrente de assinatura
- retencao do usuario que leva a mais sessoes, mais consultas e mais chances de upgrade

## 6.2 Metricas base

- `ARPDAU`
- `ARPPU`
- `free_to_rewarded_rate`
- `free_to_pro_conversion_rate`
- `trial_to_paid_rate` se houver trial depois
- `D1`, `D7`, `D30 retention`
- `subscription_month_1 retention`
- `subscription_renewal_rate`
- `ad_revenue_per_free_user`
- `LTV_30`
- `LTV_90`

## 6.3 Funcionalidades para atribuir e aumentar LTV

### 1. Exportacao academica Pro

Racional:

- cria valor real e recorrente para estudante e pesquisador
- aumenta a chance de retencao e renovacao

Eventos:

- `export_paywall_shown`
- `export_completed`

### 2. Historico inteligente

Racional:

- traz o usuario de volta para consultas anteriores
- aumenta recorrencia

Escopo inicial:

- ultimas consultas
- reabrir com um toque

Eventos:

- `history_saved`
- `history_reopened`

### 3. Favoritos

Racional:

- cria investimento emocional e utilidade acumulada

Eventos:

- `favorite_created`
- `favorite_opened`

### 4. Insights Pro

Racional:

- aumenta profundidade de uso
- diferencia o Pro de "so remove Ads"

Escopo:

- primos gemeos
- densidade de primos
- estatisticas do intervalo

Eventos:

- `insight_viewed`
- `insight_paywall_shown`

### 5. Nudge de retorno

Racional:

- aumenta frequencia de sessao
- empurra mais usuarios ao momento de valor

Escopo futuro:

- lembrete de consulta recente
- destaque de historico
- sugestao de explorar intervalo maior

## 6.4 Segmentos de LTV

### Segmentos recomendados

- usuario gratuito leve
- usuario gratuito recorrente
- usuario que usa rewarded
- usuario Pro novo
- usuario Pro recorrente
- usuario Pro em risco de churn

### Sinais de risco de churn

- queda de frequencia de sessao
- ausencia de uso de recursos Pro
- ausencia de retorno apos compra
- uso baixo apos renovacao

## 7. Ordem Recomendada de Implementacao

1. Integrar analytics minimo para Ads e assinatura.
2. Implementar `AdsService` com banner e rewarded.
3. Conectar rewarded ao `UserAccessStore`.
4. Criar `PremiumModule` e paywall inicial.
5. Integrar compra nativa e restauracao de compra.
6. Persistir entitlement localmente.
7. Ocultar Ads para `pro`.
8. Implementar interstitial com frequencia controlada.
9. Entregar primeiro recurso Pro de valor recorrente.
10. Introduzir eventos de LTV e segmentacao.

## 8. Backlog Tecnico Recomendado

### Core

- `EntitlementRepository`
- `MonetizationAnalyticsService`
- `MonetizationExperimentConfig`

### Ads

- widget de banner desacoplado
- controlador de rewarded
- politica de frequencia de interstitial

### Premium

- store do paywall
- modelos de plano
- repositorio de entitlement

### LTV

- repositorio de historico
- repositorio de favoritos
- event schema centralizado

## 9. Criterios de Aceite

### Ads

- banner aparece apenas para usuarios nao Pro na tela correta
- rewarded realmente libera acesso expandido temporario
- falha de anuncio nao quebra o fluxo

### Assinatura

- compra ativa o estado Pro
- restaurar compra recupera estado
- usuario Pro nao ve anuncios

### LTV

- eventos de monetizacao sao rastreados
- e possivel comparar receita por segmento
- existe ao menos um recurso Pro com potencial real de retencao

## 10. MVP Recomendado

Se o objetivo for colocar monetizacao com medicao minima no ar, o MVP desta spec deve incluir:

- banner na tela de resultado
- rewarded para expanded access
- paywall simples
- assinatura mensal e anual
- persistencia local de entitlement
- remocao de Ads para Pro
- eventos de Ads e assinatura
- primeiro recurso Pro com valor recorrente: exportacao ou historico

## 11. Fora do MVP

- multiplas experiencias de paywall em teste A/B
- trial gratuita complexa
- notificacoes inteligentes automatizadas
- sistema completo de churn prediction
- dashboard de BI dentro do app

## 12. Proxima Entrega Recomendada

A proxima spec tecnica derivada desta deve detalhar:

- contratos do `AdsService`
- contratos do `SubscriptionService`
- desenho do `PremiumModule`
- schema de eventos de monetizacao e LTV

Depois disso, a primeira implementacao ideal e:

1. Ads base
2. Paywall
3. Assinatura
4. Persistencia de entitlement
5. Primeiro recurso Pro de retencao
