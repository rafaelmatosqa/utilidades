# Pix_Gherkin_Patterns.feature

## Objetivo

Este arquivo contém padrões reutilizáveis para geração automática de cenários BDD relacionados às APIs Pix.

O agente deve utilizar estes padrões para sugerir cobertura, identificar cenários faltantes e manter consistência entre diferentes especificações.

---

Feature: Biblioteca de padrões Gherkin para APIs Pix

---

# Padrões de Cobertura

## APIs de criação (POST)

Ao identificar operações de criação, considerar automaticamente:

### Sucesso

```text
- payload mínimo válido
- payload completo
- campos opcionais ausentes
- campos opcionais preenchidos
- limites mínimos
- limites máximos
```

### Payload

```text
- payload vazio
- ausência de campos obrigatórios
- campos nulos
- campos vazios
- formatos inválidos
- objetos inválidos
```

### Regras de negócio

```text
- combinações não permitidas
- duplicidades
- estados inválidos
- datas inválidas
- limites funcionais
```

### Segurança

```text
- token expirado
- ausência de token
- token inválido
- scope inválido
```

### Disponibilidade

```text
- serviço indisponível
- timeout
```

---

## APIs de atualização (PUT/PATCH)

Ao identificar operações de atualização, considerar automaticamente:

### Sucesso

```text
- atualização válida
- alteração permitida pelo estado atual
```

### Payload

```text
- payload vazio
- ausência de campos obrigatórios
- campos inválidos
```

### Regras de negócio

```text
- transições de estado proibidas
- atualização em estado não elegível
- alteração não permitida
```

### Recursos inexistentes

```text
- txid inexistente
- recurso inexistente
```

### Segurança

```text
- token expirado
- ausência de token
- acesso negado
- scope inválido
```

---

## APIs de consulta (GET)

Ao identificar operações de consulta, considerar automaticamente:

### Sucesso

```text
- retorno com dados
- retorno com todos os campos
```

### Recursos inexistentes

```text
- recurso não encontrado
```

### Segurança

```text
- token expirado
- ausência de token
- scope inválido
```

### Disponibilidade

```text
- serviço indisponível
```

---

# Padrões Pix

## Cobrança recorrente

Considerar:

```text
- payload mínimo
- payload completo
- idRec válido
- idRec inexistente
- idRec cancelado
- txid válido
- txid inválido
- cobrança inexistente
- cobrança duplicada
- idempotência
```

---

## Calendário

Considerar:

```text
- data atual
- data futura
- data inválida
- data anterior à criação
```

---

## Valor

Considerar:

```text
- valor mínimo permitido
- valor máximo permitido
- valor zero
- valor negativo
- formato inválido
```

---

## Recebedor

Considerar:

```text
- recebedor válido
- recebedor ausente
- recebedor inválido
- conta não pertencente
- tipoConta inválido
```

---

## Devedor

Considerar:

```text
- devedor válido
- devedor ausente
- devedor inválido
```

---

## Informações adicionais

Considerar:

```text
- ausência do campo
- tamanho mínimo
- tamanho máximo
- acima do limite
```

---

## Cancelamento

Considerar:

```text
- cancelamento permitido
- status inválido
- cancelamento fora da janela permitida
- cobrança inexistente
```

---

# Fluxos

Quando o usuário solicitar fluxos, sugerir automaticamente validações complementares.

## Banco de dados

Exemplos:

```text
- registro persistido
- atualização realizada
- status atualizado
- histórico gravado
```

---

## Kafka

Exemplos:

```text
- evento publicado
- conteúdo do evento
- chave correta
- tópico correto
```

---

## Integrações

Exemplos:

```text
- integração acionada
- integração indisponível
- tratamento de falha
```

---

# Estratégia de quebra automática

Antes de gerar os cenários, o agente deve estimar o tamanho da resposta.

## Até 5 cenários

```text
Gerar todos.
```

---

## Entre 6 e 15 cenários

Dividir por grupos funcionais.

Exemplo:

```text
Parte 1 – Sucesso

Parte 2 – Payload

Parte 3 – Segurança
```

---

## Acima de 15 cenários

Apresentar plano antes da geração.

Formato:

```text
Foram identificados XX cenários.

Sugestão:

Parte 1 – ...

Parte 2A – ...

Parte 2B – ...

Parte 3A – ...

Parte 3B – ...

Aguarde aprovação do usuário para iniciar.
```

---

# Gestão da execução

Após finalizar uma parte, o agente deve informar:

```text
Parte X concluída.

Restam:
- Parte Y
- Parte Z
```

Nunca repetir partes já concluídas durante a mesma execução.

---

# Critérios para solicitar esclarecimentos

O agente deve interromper a geração e solicitar informações adicionais quando:

```text
- contratos de erro não forem conhecidos;
- status esperados não forem definidos;
- regras de negócio forem ambíguas;
- payloads estiverem incompletos;
- houver inconsistência entre especificação e cenários solicitados.
```

---

# Checklist interno obrigatório

Antes de responder, validar:

```text
□ Cobertura adequada sugerida

□ Estratégia de quebra aplicada

□ Parte correta sendo gerada

□ Objetivo preenchido

□ Precondição preenchida

□ BDD em inglês

□ Curl presente

□ Response presente

□ Status code validado

□ JSON Schema validado

□ Regras de negócio validadas

□ Contratos oficiais utilizados

□ Sem cenários duplicados

□ Partes restantes informadas
```

---

# Comportamento esperado

O agente deve atuar como um QA Sênior especializado em Pix.

Seu objetivo não é apenas escrever Gherkin.

Seu objetivo é:

* identificar riscos;
* propor cobertura adequada;
* organizar a geração;
* manter consistência;
* evitar truncamentos;
* produzir suítes completas e reutilizáveis para Zephyr Scale.
