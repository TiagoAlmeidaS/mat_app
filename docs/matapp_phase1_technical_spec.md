# Spec Tecnica: Fase 1 do MatApp

## Objetivo

Detalhar a Fase 1 da evolucao do MatApp para preparar o projeto para monetizacao, limites de uso e recursos Pro sem introduzir retrabalho estrutural.

O foco desta fase e estabilizar o fluxo atual de calculo de numeros primos, organizar regras de negocio e preparar a arquitetura para os proximos modulos.

## Resultado Esperado da Fase 1

Ao final desta fase, o projeto deve:

- validar corretamente a entrada do usuario
- executar o calculo de forma previsivel e testavel
- separar UI, regras de negocio e estado
- expor um estado central para acesso do usuario
- estar pronto para receber gating de free/pro e analytics

## Leitura do Estado Atual

### Problemas encontrados no codigo atual

- `PrimesNumberService` mistura varias responsabilidades:
  - validacao de primalidade
  - geracao de candidatos
  - filtragem
  - ordenacao
  - logs
- o fluxo de calculo e sincrono e fica acoplado diretamente ao clique do botao
- a tela `PrimeNumbersPage` faz parsing direto de `TextEditingController` sem validacao
- a navegacao esta inconsistente:
  - `AppModule` usa `/prime-numbers`
  - `HomePage` navega para `/prime_numbers`
  - `HomeModule` tambem usa `/prime_numbers/`
- a tela de resultado recebe um `Map` dinamico com `args.data['numbersPrime']`
- nao existe estado de loading, erro de validacao ou falha de calculo
- o componente `TextFieldComponent` nao restringe teclado numerico nem oferece tratamento de erro

## Escopo da Fase 1

### Incluido

- refatoracao do dominio de calculo
- criacao de models para request, result e access state
- criacao de store/controller da feature
- melhoria de navegacao e contratos de rota
- validacao de entrada e estados de tela
- testes unitarios e widget tests basicos

### Nao incluido

- anuncios
- paywall
- rewarded ad
- compras in-app
- analytics real com SDK externo
- persistencia em nuvem
- exportacao de arquivos

## Arquitetura Proposta

## 1. Camada de Dominio para Calculo

### Objetivo

Encapsular a logica de calculo de primos em componentes mais previsiveis e testaveis.

### Estrutura sugerida

- `lib/app/module/prime_numbers/domain/entities/`
- `lib/app/module/prime_numbers/domain/value_objects/`
- `lib/app/module/prime_numbers/domain/services/`
- `lib/app/module/prime_numbers/domain/usecases/`

### Contratos sugeridos

#### `PrimeCalculationRequest`

Responsavel por representar uma solicitacao de calculo.

Campos:

- `int start`
- `int end`

Regras:

- `start >= 0`
- `end >= 0`
- `start <= end`

Metodos sugeridos:

- `int get intervalLength`
- `bool get isValid`

#### `PrimeCalculationResult`

Responsavel por representar a saida padronizada do calculo.

Campos:

- `PrimeCalculationRequest request`
- `List<int> primeNumbers`
- `Duration? elapsedTime`
- `bool usedOptimizedPath`
- `String? warningMessage`

Metodos derivados:

- `int get totalCount`
- `bool get isEmpty`

#### `PrimeNumberCalculator`

Contrato de servico para calculo.

Metodo:

- `Future<PrimeCalculationResult> calculate(PrimeCalculationRequest request)`

### Decisao tecnica

Mesmo que a implementacao inicial continue local e simples, o contrato deve ser assincrono desde agora. Isso evita retrabalho quando o calculo migrar para isolate na Fase 3.

## 2. Refatoracao do Servico de Primos

### Objetivo

Substituir o comportamento atual por uma implementacao menor, correta e facil de validar.

### Recomendacao

Nao expandir a logica atual baseada em terminacoes e formulas auxiliares sem antes validacao matematica forte. Para esta fase, e melhor usar uma implementacao clara e confiavel.

### Caminho recomendado

Separar o comportamento em:

- `PrimeValidator`
- `PrimeRangeGenerator`
- `PrimeCalculationService`

### Contratos sugeridos

#### `PrimeValidator`

Metodos:

- `bool isPrime(int value)`

Regras:

- `0` e `1` nao sao primos
- `2` e primo
- pares maiores que `2` nao sao primos
- validar divisores ate `sqrt(n)`

#### `PrimeRangeGenerator`

Metodos:

- `List<int> generate(int start, int end)`

Responsabilidade:

- iterar no intervalo
- aplicar `PrimeValidator`
- devolver lista ordenada

#### `PrimeCalculationService`

Responsabilidade:

- receber `PrimeCalculationRequest`
- medir tempo da execucao
- selecionar estrategia de calculo
- devolver `PrimeCalculationResult`

### Criterios de aceite

- o calculo retorna primos corretos para intervalos pequenos, medios e casos de borda
- a implementacao nao modifica listas durante iteracao
- a API do servico deixa de expor detalhes internos da estrategia

## 3. Estado da Feature

### Objetivo

Retirar a logica da tela e centralizar o fluxo de calculo em um store/controller.

### Estrutura sugerida

- `lib/app/module/prime_numbers/presentation/stores/prime_numbers_store.dart`

### Responsabilidades do store

- controlar valores de entrada
- validar formulario
- iniciar calculo
- expor loading
- expor erro
- expor ultimo resultado
- preparar integracao futura com regras de gating

### Estado sugerido

#### `PrimeNumbersViewState`

Campos:

- `String startText`
- `String endText`
- `bool isLoading`
- `String? inputError`
- `String? calculationError`
- `PrimeCalculationResult? result`

Metodos derivados:

- `bool get canSubmit`
- `bool get hasResult`

### API sugerida do store

- `void updateStart(String value)`
- `void updateEnd(String value)`
- `String? validateInputs()`
- `Future<bool> submit()`
- `void clearResult()`

### Decisao tecnica

Nesta fase, um `ChangeNotifier` ou `ValueNotifier` ja e suficiente. Nao ha necessidade de introduzir uma solucao mais pesada agora, a menos que o projeto ja queira padronizar outra abordagem.

## 4. Estado Global de Acesso do Usuario

### Objetivo

Criar uma fonte unica para representar o tipo de acesso do usuario, mesmo antes da monetizacao real.

### Estrutura sugerida

- `lib/app/core/models/user_access_state.dart`
- `lib/app/core/stores/user_access_store.dart`

### Modelagem sugerida

#### `UserPlan`

Enum:

- `free`
- `rewarded`
- `pro`

#### `UserAccessState`

Campos:

- `UserPlan plan`
- `DateTime? rewardedAccessExpiresAt`

Metodos derivados:

- `bool get isPremium`
- `bool get hasTemporaryExpandedAccess`

### Objetivo pratico nesta fase

Mesmo sem compra ou ad, o app passa a depender de um contrato central de acesso. Isso vai permitir adicionar regras de limite na Fase 2 sem mexer em todas as telas.

## 5. Contrato de Regra de Limite

### Objetivo

Definir desde ja a interface da politica de acesso, mesmo que a regra completa chegue na Fase 2.

### Estrutura sugerida

- `lib/app/core/models/usage_gate_decision.dart`
- `lib/app/core/services/usage_gate_service.dart`

### Modelagem sugerida

#### `UsageGateAction`

Enum:

- `allow`
- `requireRewardedAccess`
- `requirePremium`

#### `UsageGateDecision`

Campos:

- `UsageGateAction action`
- `String? message`
- `int? allowedRangeMax`

### Interface sugerida

- `UsageGateDecision evaluate(PrimeCalculationRequest request, UserAccessState accessState)`

### Implementacao da Fase 1

Na Fase 1, a implementacao pode retornar sempre `allow`, mas a interface ja deve existir. Isso reduz retrabalho quando os limites entrarem.

## 6. Ajustes de Navegacao

### Problema atual

As rotas de primos usam formatos diferentes com hifen e underscore, o que tende a causar bugs ou confusao.

### Padrao recomendado

Adotar um unico formato de rota com hifen:

- `/prime-numbers/`
- `/prime-numbers/result/`

### Mudancas sugeridas

- alinhar `AppModule`, `HomeModule` e `HomePage`
- mover a tela de resultado para dentro do mesmo namespace de feature
- substituir `Map` dinamico por argumento tipado ou leitura do resultado via store

### Criterios de aceite

- o app navega para a tela de calculo sem rotas duplicadas
- a tela de resultado nao depende de chave string solta em `args.data`

## 7. Ajustes de UX nas Telas Atuais

## Tela de calculo

### Melhorias necessarias

- teclado numerico nos campos
- validacao visual abaixo dos campos
- desabilitar botao quando entrada for invalida
- indicador de carregamento durante calculo
- feedback claro para intervalos sem primos

### Comportamentos esperados

- se o campo estiver vazio, mostrar mensagem amigavel
- se houver texto invalido, impedir submit
- se `start > end`, mostrar erro de intervalo
- se a execucao falhar, exibir erro recuperavel

## Tela de resultado

### Melhorias necessarias

- cabecalho com resumo do calculo
- quantidade total de primos encontrados
- estado vazio quando nao houver resultados
- CTA para novo calculo

### Modelo de exibicao sugerido

- intervalo pesquisado
- total encontrado
- grade ou lista dos primos

## 8. Contratos de Erro

### Objetivo

Evitar erros genericos de parsing ou exceptions sem contexto.

### Tipos sugeridos

- `InputValidationException`
- `PrimeCalculationException`

### Regras

- excecoes tecnicas nao devem vazar direto para a UI
- o store converte falhas para mensagens amigaveis

## 9. Testes da Fase 1

### Testes unitarios obrigatorios

#### `PrimeValidator`

- identifica `2`, `3`, `5`, `7` como primos
- rejeita `0`, `1` e negativos
- rejeita pares maiores que `2`
- aceita e rejeita compostos classicos corretamente

#### `PrimeRangeGenerator`

- retorna primos em intervalo pequeno
- lida com inicio igual ao fim
- lida com intervalo sem primos

#### `UsageGateService`

- retorna `allow` no comportamento inicial

#### `PrimeCalculationRequest`

- invalida request com `start > end`
- invalida request com numeros negativos

### Widget tests minimos

- tela mostra erro com campos vazios
- botao dispara calculo com entrada valida
- loading aparece durante submit
- resultado vazio e renderizado corretamente

## 10. Sequencia de Implementacao da Fase 1

1. Padronizar rotas e contratos de navegacao.
2. Criar models base:
   - `PrimeCalculationRequest`
   - `PrimeCalculationResult`
   - `UserAccessState`
   - `UsageGateDecision`
3. Refatorar o dominio de calculo:
   - `PrimeValidator`
   - `PrimeRangeGenerator`
   - `PrimeCalculationService`
4. Criar `PrimeNumbersStore`.
5. Atualizar `PrimeNumbersPage` para usar o store.
6. Atualizar `ViewNumbersPage` para consumir resultado tipado.
7. Adicionar tratamento de erro e estados visuais.
8. Escrever testes unitarios e widget tests basicos.

## 11. Definicao de Pronto

A Fase 1 sera considerada pronta quando:

- o fluxo de calculo estiver desacoplado da UI
- o calculo estiver coberto por testes basicos
- a entrada do usuario estiver validada
- as rotas estiverem consistentes
- existir um estado global simples para acesso do usuario
- existir a interface de gating pronta para a Fase 2

## 12. Proxima Entrega apos a Fase 1

Com esta base pronta, a proxima entrega sera a Fase 2:

- configurar limites reais do plano gratuito
- definir faixas de intervalo
- bloquear ou redirecionar antes do processamento pesado
- introduzir CTAs de rewarded e Pro na UX
