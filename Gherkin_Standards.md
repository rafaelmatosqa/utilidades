# Gherkin_Standards.md

## Objetivo

Este documento define os padrões obrigatórios para geração de cenários BDD em Gherkin utilizados nos projetos de QA.

Todos os cenários gerados pelo agente devem seguir integralmente estas diretrizes.

---

# Estrutura obrigatória

Todo cenário deve conter, obrigatoriamente:

* Nome do cenário;
* Objetivo;
* Precondição;
* Scenario;
* Steps BDD;
* Validações obrigatórias.

---

# Nome do cenário

## APIs

Formato:

```text
[componente] VERBO_HTTP path - resultado esperado
```

Exemplos:

```text
[cobr] POST /cobr - deve criar cobrança recorrente com payload mínimo válido

[cobr] PATCH /cobr/{txid} - deve cancelar cobrança recorrente

[cobr] GET /cobr/{txid} - deve retornar cobrança existente

[dict] GET /entries/{key} - deve retornar dados da chave pix pesquisada
```

---

## Fluxos

Quando envolver múltiplas APIs, banco ou Kafka:

Formato:

```text
[componente] nome do fluxo - resultado esperado
```

Exemplos:

```text
[pix] Pagamento Pix por chave - deve concluir liquidação com sucesso

[pix] Devolução Pix - deve publicar evento de devolução no Kafka
```

---

# Objetivo

O campo Objetivo é obrigatório.

Deve explicar claramente o propósito do teste.

Exemplos:

```text
Objetivo:
Validar a criação da cobrança utilizando apenas os campos obrigatórios.
```

```text
Objetivo:
Validar que a API rejeita payloads sem os campos obrigatórios.
```

---

# Precondição

O campo Precondição é obrigatório.

Deve descrever o estado necessário para execução do cenário.

Exemplos:

```text
Precondição:
Dado que exista um idRec ativo e válido.
```

```text
Precondição:
Dado que exista uma cobrança ativa para o txid informado.
```

```text
Precondição:
Dado que exista um token válido com o scope adequado.
```

---

# BDD obrigatório

Os cenários devem ser escritos em inglês.

Utilizar apenas:

```gherkin
Given
When
Then
And
```

Não utilizar:

```text
Dado
Quando
Então
Mas
```

---

# Estrutura recomendada

Modelo:

```gherkin
Scenario: [componente] VERBO path - resultado esperado

  Objetivo:
    ...

  Precondição:
    ...

  Given ...
  And ...

  When ...
    """
    curl ...
    """

  Then ...
    """
    {
      ...
    }
    """

  And ...
```

---

# Curl obrigatório

Toda chamada da API deve estar dentro do step When.

Formato:

```gherkin
When envio uma requisição POST para /endpoint
"""
curl --location 'https://exemplo.com'
"""
```

Regras:

* utilizar aspas triplas;
* manter headers relevantes;
* incluir body quando aplicável;
* utilizar exemplos representativos.

---

# Response obrigatório

Todo response JSON deve estar dentro do Then.

Formato:

```gherkin
Then o response body deve refletir os dados enviados
"""
{
  ...
}
"""
```

Regras:

* utilizar JSON válido;
* incluir campos relevantes;
* representar fielmente o contrato.

---

# Validações obrigatórias

Todo cenário de API deve validar obrigatoriamente:

## Status Code

Exemplo:

```gherkin
Then a API deve retornar status code 201
```

---

## JSON Schema

Exemplo:

```gherkin
And o response deve respeitar o JSON schema de criação da cobrança
```

---

## Regras de negócio

Exemplo:

```gherkin
And o campo status deve ser igual a "CRIADA"

And deve ser gerado um txid

And o histórico deve conter o status "CRIADA"
```

---

# Erros

Cenários de erro devem validar:

* status code;
* JSON Schema;
* contrato de erro;
* mensagem de negócio;
* propriedade violada, quando existir.

Exemplo:

```gherkin
Then a API deve retornar status code 400

And o response deve respeitar o JSON schema de erro

And o response body deve indicar operação inválida

"""
{
  ...
}
"""

And a violação deve referenciar "campo"
```

---

# Segurança

Cenários de autenticação/autorização devem validar:

## 401

Exemplos:

```text
token expirado

token inválido

ausência de token
```

Validações:

```gherkin
Then a API deve retornar status code 401

And o response deve respeitar o JSON schema de autenticação
```

---

## 403

Exemplos:

```text
scope inválido

permissão insuficiente
```

Validações:

```gherkin
Then a API deve retornar status code 403

And o response deve respeitar o JSON schema de autorização
```

---

# Recursos inexistentes

Quando o recurso não existir:

Exemplo:

```gherkin
Then a API deve retornar status code 404

And o response deve respeitar o JSON schema correspondente

And o response body deve indicar que o recurso não foi encontrado
```

---

# Fluxos

Fluxos podem conter:

* múltiplas APIs;
* consultas em banco;
* validações Kafka;
* validações intermediárias.

Exemplo:

```gherkin
Given ...

When envio a requisição de criação

And consulto o banco de dados

And consumo o evento Kafka

Then ...
```

---

# Boas práticas

Sempre:

* utilizar nomes claros;
* descrever intenções;
* validar regras relevantes;
* representar contratos reais;
* manter consistência entre cenários;
* reutilizar contratos oficiais.

Nunca:

* inventar contratos;
* omitir validações obrigatórias;
* misturar português com inglês nos steps;
* gerar cenários duplicados;
* assumir regras não especificadas.

---

# Checklist final

Antes de concluir qualquer geração, validar:

```text
□ Nome correto

□ Objetivo preenchido

□ Precondição preenchida

□ Given/When/Then/And

□ Curl presente

□ Response presente

□ Status code validado

□ JSON Schema validado

□ Regra de negócio validada

□ Contrato oficial utilizado

□ Sem duplicidades
```
