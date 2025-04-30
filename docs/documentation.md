# MatApp - Aplicativo de Matemática

## Objetivo
O MatApp é um aplicativo móvel desenvolvido em Flutter que tem como objetivo principal auxiliar no cálculo e visualização de números primos. O aplicativo foi desenvolvido para ser uma ferramenta educativa e prática para estudantes e entusiastas de matemática.

## Funcionalidades Principais

### Cálculo de Números Primos
O aplicativo permite calcular números primos dentro de um intervalo definido pelo usuário. As principais características incluem:

1. **Interface Intuitiva**: Permite inserir um intervalo de números para cálculo
2. **Processamento Eficiente**: Utiliza diferentes estratégias de processamento para web e dispositivos móveis
3. **Visualização Clara**: Apresenta os resultados de forma organizada e fácil de entender

## Fórmulas e Algoritmos

### Definição de Números Primos
Um número primo é um número natural maior que 1 que possui exatamente dois divisores positivos: 1 e ele mesmo.

### Algoritmo de Verificação
O aplicativo utiliza um algoritmo otimizado para verificar números primos, que inclui:

1. **Tratamento de Exceções**: Os números 1, 2, 3 e 5 são tratados como casos especiais
2. **Verificação de Divisibilidade**: Para cada número, verifica-se se ele é divisível apenas por 1 e por ele mesmo
3. **Otimização de Processamento**: 
   - Em dispositivos móveis: Utiliza Isolates para processamento paralelo
   - Na web: Implementa chunking para processar números em blocos

### Fórmula de Verificação
Para um número n, a verificação de primalidade é feita através da seguinte lógica:
- Se n ≤ 1: Não é primo
- Se n ≤ 3: É primo
- Se n é divisível por 2 ou 3: Não é primo
- Para todos os números i de 5 até √n, incrementando de 6 em 6:
  - Se n é divisível por i ou por (i + 2): Não é primo
- Caso contrário: É primo

## Arquitetura Técnica

### Estrutura do Projeto
- **Módulos**: Organização em módulos para melhor manutenção e escalabilidade
- **Serviços**: Separação de lógica de negócio em serviços especializados
- **Widgets**: Componentes reutilizáveis para interface do usuário

### Tecnologias Utilizadas
- Flutter/Dart para desenvolvimento multiplataforma
- Modular para gerenciamento de estado e injeção de dependências
- Isolates para processamento paralelo em dispositivos móveis

## Como Usar

1. Abra o aplicativo
2. Insira o intervalo desejado (exemplo: 1 a 100)
3. Clique em "Calcular"
4. Visualize os números primos encontrados no intervalo especificado

## Considerações de Performance

O aplicativo foi otimizado para lidar com diferentes cenários:
- **Dispositivos Móveis**: Utiliza processamento paralelo para melhor performance
- **Web**: Implementa chunking para evitar travamentos do navegador
- **Grandes Intervalos**: Processamento em blocos para melhor gerenciamento de memória

## Versão Atual
Versão: 1.0.6 (202503181) 