# Spec de Produto: Funcionalidades Vendaveis do MatApp Pro

## Objetivo

Definir um conjunto de funcionalidades adicionais que o MatApp pode vender como parte da assinatura Pro.

A meta desta spec e responder tres perguntas:

- quais funcionalidades fazem sentido para o dominio do app
- quais delas tem valor comercial real para uma assinatura
- em que ordem vale implementar para maximizar conversao, retencao e LTV

## Premissas

- O MatApp ja tem o nucleo de calculo de primos.
- O modelo `free`, `rewarded` e `pro` ja foi introduzido.
- A assinatura Pro nao deve vender apenas "remocao de Ads".
- Funcionalidade vendavel precisa ter utilidade recorrente ou valor academico claro.

## Criterios para decidir se uma funcionalidade entra no Pro

Uma funcionalidade deve entrar no Pro quando atende pelo menos dois destes criterios:

- aumenta a frequencia de uso
- aumenta a profundidade de uso
- resolve uma tarefa academica real
- economiza tempo do usuario
- gera artefato exportavel ou reutilizavel
- diferencia o app de uma calculadora simples

## Taxonomia de Funcionalidades Pro

## 1. Funcionalidades de Calculo Avancado

Essas funcionalidades aumentam o valor matematico do app.

### 1.1 Fatoracao de numeros inteiros

Descricao:

- fatorar um numero em fatores primos
- exibir decomposicao em formato legivel
- opcionalmente exibir potencia de cada fator

Exemplo:

- `360 = 2^3 x 3^2 x 5`

Valor comercial:

- alto
- util para estudantes, professores e uso didatico

Modelo recomendado:

- `free`: fatoracao simples com limite de tamanho
- `pro`: fatoracao de numeros maiores, historico e exportacao

Prioridade:

- muito alta

### 1.2 Verificacao de primalidade individual

Descricao:

- validar rapidamente se um numero especifico e primo

Valor comercial:

- medio

Observacao:

- isoladamente nao sustenta assinatura
- funciona melhor como complemento da fatoracao

Prioridade:

- media

### 1.3 Estatisticas do intervalo

Descricao:

- quantidade de primos
- maior primo do intervalo
- menor primo do intervalo
- media entre primos
- distribuicao por blocos

Valor comercial:

- medio a alto

Prioridade:

- alta

### 1.4 Primos gemeos

Descricao:

- identificar pares de primos gemeos no intervalo

Valor comercial:

- medio

Prioridade:

- alta

### 1.5 Gaps entre primos consecutivos

Descricao:

- calcular diferenca entre primos consecutivos
- destacar maior gap do intervalo

Valor comercial:

- medio

Prioridade:

- media

### 1.6 Goldbach experimental

Descricao:

- para numeros pares, apresentar decomposicoes em soma de dois primos

Valor comercial:

- baixo a medio

Risco:

- pode ser interessante academicamente, mas nao e funcionalidade base para monetizacao

Prioridade:

- baixa

## 2. Funcionalidades de Exportacao

Essas funcionalidades transformam o app em ferramenta de estudo e trabalho.

### 2.1 Exportacao de lista de primos do intervalo

Descricao:

- exportar resultado para:
  - CSV
  - TXT
  - PDF
  - formato tabular para planilha

Valor comercial:

- muito alto

Razao:

- converte o resultado em artefato util fora do app

Prioridade:

- muito alta

### 2.2 Exportacao de numeros selecionados

Descricao:

- o usuario marca numeros especificos do resultado
- exporta apenas os selecionados

Valor comercial:

- alto

Razao:

- agrega controle fino
- muito util para trabalhos, listas e estudos

Prioridade:

- muito alta

### 2.3 Exportacao de fatoracao

Descricao:

- exportar numeros com seus fatores primos

Exemplo:

- numero
- ePrimo
- fatoracao

Valor comercial:

- alto

Prioridade:

- alta

### 2.4 Exportacao em LaTeX

Descricao:

- gerar saida formatada para artigos, relatorios e listas academicas

Valor comercial:

- alto para nicho especifico

Prioridade:

- alta

### 2.5 Exportacao com metadados

Descricao:

- incluir:
  - intervalo
  - data
  - quantidade de primos
  - parametros usados

Valor comercial:

- medio a alto

Prioridade:

- alta

## 3. Funcionalidades de Organizacao e Retorno

Essas funcionalidades aumentam retencao e LTV.

### 3.1 Historico de consultas

Descricao:

- salvar consultas feitas
- reabrir consulta anterior com um toque

Valor comercial:

- alto para retencao

Prioridade:

- muito alta

### 3.2 Favoritos

Descricao:

- favoritar intervalos
- favoritar numeros individuais
- favoritar fatoracoes relevantes

Valor comercial:

- alto para retencao

Prioridade:

- alta

### 3.3 Colecoes ou listas nomeadas

Descricao:

- criar agrupamentos como:
  - "Lista de exercicios"
  - "Aula sobre fatoracao"
  - "Experimentos"

Valor comercial:

- medio a alto

Prioridade:

- media

### 3.4 Notas do usuario

Descricao:

- anexar observacoes a uma consulta, numero ou favorito

Valor comercial:

- medio

Prioridade:

- media

## 4. Funcionalidades de Visualizacao e Insight

Essas funcionalidades aumentam profundidade de uso e diferenciais do Pro.

### 4.1 Grafico de densidade de primos

Descricao:

- plotar a distribuicao dos primos no intervalo

Valor comercial:

- alto como diferencial visual

Prioridade:

- alta

### 4.2 Heatmap ou distribuicao por blocos

Descricao:

- mostrar concentracao de primos em subfaixas

Valor comercial:

- medio

Prioridade:

- media

### 4.3 Painel de insights automaticos

Descricao:

- resumo textual com:
  - quantidade de primos
  - primos gemeos encontrados
  - maior gap
  - fatoracoes relevantes

Valor comercial:

- alto

Prioridade:

- alta

## 5. Funcionalidades de Usabilidade Premium

Essas funcionalidades nao vendem sozinhas, mas reforcam o Pro.

### 5.1 Consultas maiores sem rewarded

Descricao:

- ampliar limite de intervalo

Valor comercial:

- alto, mas deve vir junto com features de valor

Prioridade:

- muito alta

### 5.2 Sem anuncios

Descricao:

- remover banner e interstitial

Valor comercial:

- medio sozinho

Observacao:

- importante como beneficio, insuficiente como proposta unica

Prioridade:

- muito alta

### 5.3 Processamento prioritario

Descricao:

- caminho mais rapido para calculos maiores
- feedback de progresso melhor

Valor comercial:

- medio

Prioridade:

- media

## Elenco Recomendado para Venda do Pro

## Pacote minimo que realmente vende assinatura

Este e o conjunto mais coerente para vender o Pro sem parecer "paywall artificial":

1. Sem anuncios
2. Limite maior de consulta
3. Exportacao de resultados
4. Exportacao de numeros selecionados
5. Fatoracao
6. Historico de consultas

Razao:

- combina conveniencia, produtividade e valor academico

## Pacote Pro forte

Se quiser posicionar melhor a assinatura:

1. Sem anuncios
2. Limite maior de consulta
3. Fatoracao completa
4. Exportacao CSV/PDF/LaTeX
5. Exportacao de selecionados
6. Historico
7. Favoritos
8. Insights do intervalo
9. Grafico de densidade

Razao:

- aqui o Pro para de ser "desbloqueio" e vira ferramenta de trabalho/estudo

## Priorizacao Recomendada

## Prioridade 1

Implementar primeiro porque impacta conversao de forma mais direta:

- fatoracao
- exportacao de lista de primos
- exportacao de numeros selecionados
- historico
- sem anuncios
- limite expandido

## Prioridade 2

Implementar em seguida porque aumenta retencao e uso recorrente:

- favoritos
- exportacao de fatoracao
- estatisticas do intervalo
- primos gemeos
- painel de insights

## Prioridade 3

Implementar depois como refinamento e diferenciacao:

- LaTeX
- grafico de densidade
- colecoes nomeadas
- notas do usuario
- gaps entre primos

## Prioridade 4

Implementar apenas se houver justificativa clara:

- Goldbach experimental
- heatmaps mais complexos
- recursos de nicho sem forte sinal de uso

## Funcionalidades Free vs Pro

## Free recomendado

- consulta de intervalos pequenos
- visualizacao basica do resultado
- rewarded para acesso expandido pontual
- verificacao simples de primalidade

## Pro recomendado

- sem anuncios
- intervalos maiores
- fatoracao completa
- exportacao completa
- exportacao de selecionados
- historico
- favoritos
- insights e visualizacoes

## Estrutura Tecnica Sugerida

- `lib/app/module/premium_features/`
- `lib/app/module/premium_features/factorization/`
- `lib/app/module/premium_features/export/`
- `lib/app/module/premium_features/history/`
- `lib/app/module/premium_features/favorites/`
- `lib/app/module/premium_features/insights/`

## Contratos sugeridos

### `FactorizationResult`

Campos:

- `int number`
- `bool isPrime`
- `Map<int, int> factors`
- `String formattedExpression`

### `ExportSelection`

Campos:

- `List<int> selectedNumbers`
- `String exportFormat`
- `bool includeMetadata`
- `bool includeFactorization`

### `SavedPrimeQuery`

Campos:

- `int start`
- `int end`
- `DateTime createdAt`
- `int resultCount`

## Criterios de Aceite

- o Pro tem pelo menos tres funcionalidades com valor academico claro
- ha pelo menos uma feature de exportacao
- ha pelo menos uma feature de organizacao e retorno
- ha pelo menos uma feature de calculo alem da simples listagem de primos
- o paywall consegue comunicar essas funcionalidades sem promessas vagas

## Sequencia Recomendada de Implementacao

1. Fatoracao
2. Exportacao da lista de primos
3. Exportacao de numeros selecionados
4. Historico
5. Favoritos
6. Estatisticas e primos gemeos
7. Exportacao de fatoracao
8. LaTeX e graficos

## Recomendacao Final

Se a pergunta for "o que realmente vende assinatura no MatApp", a resposta mais defensavel e:

- fatoracao
- exportacao
- historico
- favoritos
- insights
- sem anuncios
- limite expandido

Se a pergunta for "o que implementar primeiro", a resposta mais pragmatica e:

1. fatoracao
2. exportacao de selecionados
3. historico
4. favoritos
