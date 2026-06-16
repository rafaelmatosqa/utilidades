# Pix_Error_Contracts.md

## Objetivo

Este documento define os contratos oficiais de erro utilizados pelo agente durante a geração de cenários BDD para APIs Pix.

O agente deve utilizar estes contratos sempre que forem compatíveis com a especificação fornecida pelo usuário.

Caso a especificação informe um contrato diferente, o contrato informado pelo usuário prevalece.

Caso o contrato não seja conhecido e não esteja definido neste documento, o agente deve solicitar esclarecimentos ao usuário.

Nunca inventar contratos.

---

# Regras Gerais

## Prioridade dos contratos

A ordem de prioridade é:

1. Contrato explicitamente informado pelo usuário;
2. Contrato definido neste documento;
3. Solicitação de esclarecimento.

---

## Estrutura de validação

Todo cenário de erro deve validar obrigatoriamente:

* status code;
* JSON schema de erro;
* contrato do response;
* detail;
* regras de negócio;
* propriedade violada, quando existir.

---

# CobROperacaoInvalida

## Uso

Utilizar para:

* violações de schema;
* regras de negócio;
* payload inválido;
* combinações não permitidas;
* estados inválidos;
* duplicidades;
* validações funcionais.

---

## Contrato Base

```json id="y5wz9n"
{
  "type": "https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
  "title": "Operação inválida.",
  "status": 400,
  "detail": "Mensagem específica do cenário."
}
```

---

## Com violações

Quando houver indicação de propriedade inválida.

```json id="dtt4x5"
{
  "type": "https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
  "title": "Operação inválida.",
  "status": 400,
  "detail": "A cobrança não respeita o schema.",
  "violacoes": [
    {
      "razao": "Mensagem específica.",
      "propriedade": "campo"
    }
  ]
}
```

---

## Exemplos de utilização

### Payload vazio

```json id="z4v9tz"
{
  "type": "https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
  "title": "Operação inválida.",
  "status": 400,
  "detail": "A cobrança não respeita o schema.",
  "violacoes": [
    {
      "razao": "O objeto cobr não respeita o schema.",
      "propriedade": "cobr"
    }
  ]
}
```

---

### Campo obrigatório ausente

```json id="g3b7yv"
{
  "type": "https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
  "title": "Operação inválida.",
  "status": 400,
  "detail": "A cobrança não respeita o schema.",
  "violacoes": [
    {
      "razao": "O campo obrigatório não foi informado.",
      "propriedade": "campo"
    }
  ]
}
```

---

### Regra de negócio

```json id="vh7c3f"
{
  "type": "https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
  "title": "Operação inválida.",
  "status": 400,
  "detail": "Mensagem específica da regra de negócio."
}
```

---

# Recurso não encontrado

## Uso

Utilizar quando:

* txid inexistente;
* idRec inexistente;
* cobrança inexistente;
* entidade não localizada.

---

## Contrato

```json id="78krc5"
{
  "type": "https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
  "title": "Operação inválida.",
  "status": 404,
  "detail": "Mensagem específica do recurso não encontrado."
}
```

---

## Exemplos

### idRec inexistente

```json id="l8u5ci"
{
  "type": "https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
  "title": "Operação inválida.",
  "status": 404,
  "detail": "O idRec informado não foi encontrado."
}
```

---

### Cobrança inexistente

```json id="8gh48q"
{
  "type": "https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
  "title": "Operação inválida.",
  "status": 404,
  "detail": "A cobrança informada não foi encontrada."
}
```

---

# Acesso negado

## Uso

Utilizar quando:

* token inválido;
* token expirado;
* ausência de token;
* autenticação inválida.

---

## Contrato

```json id="3mnbk8"
{
  "type": "https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
  "title": "Operação inválida.",
  "status": 401,
  "detail": "Mensagem específica do erro de autenticação."
}
```

---

## Exemplos

### Token expirado

```json id="zc54mh"
{
  "type": "https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
  "title": "Operação inválida.",
  "status": 401,
  "detail": "Token de acesso expirado."
}
```

---

### Ausência de token

```json id="4r1cxe"
{
  "type": "https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
  "title": "Operação inválida.",
  "status": 401,
  "detail": "Token de acesso não informado."
}
```

---

### Token inválido

```json id="g7k6ep"
{
  "type": "https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
  "title": "Operação inválida.",
  "status": 401,
  "detail": "Token inválido."
}
```

---

# Acesso proibido

## Uso

Utilizar quando:

* scope inválido;
* permissão insuficiente;
* autorização negada.

---

## Contrato

```json id="6gm6n4"
{
  "type": "https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
  "title": "Operação inválida.",
  "status": 403,
  "detail": "Mensagem específica da autorização."
}
```

---

## Exemplos

### Scope inválido

```json id="r8xg3t"
{
  "type": "https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
  "title": "Operação inválida.",
  "status": 403,
  "detail": "O token não possui permissão para executar esta operação."
}
```

---

# Serviço indisponível

## Uso

Utilizar quando houver indisponibilidade temporária.

---

## Contrato

```json id="rqy2g8"
{
  "type": "https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
  "title": "Operação inválida.",
  "status": 503,
  "detail": "O serviço está temporariamente indisponível."
}
```

---

## Exemplo

```json id="z9gxjw"
{
  "type": "https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
  "title": "Operação inválida.",
  "status": 503,
  "detail": "O serviço está temporariamente indisponível. Tente novamente mais tarde."
}
```

---

# Regras obrigatórias do agente

O agente deve:

* reutilizar contratos definidos neste documento;
* adaptar apenas o campo `detail` quando apropriado;
* adaptar o campo `status` conforme o cenário;
* preservar `type` e `title`, salvo quando o usuário informar outro contrato.

O agente nunca deve:

* inventar estruturas de erro;
* remover validações obrigatórias;
* assumir contratos não especificados.

---

# Checklist para cenários de erro

```text id="0ukzkh"
□ Status code validado

□ JSON schema validado

□ Contrato oficial utilizado

□ Detail coerente com o cenário

□ Violação validada quando existir

□ Propriedade validada quando existir

□ Sem contratos inventados
```
