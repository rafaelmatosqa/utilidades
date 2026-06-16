# Zephyr_Examples.feature

## Objetivo

Este arquivo contém exemplos de cenários BDD que representam o padrão oficial utilizado nos projetos integrados ao Zephyr Scale.

O agente deve utilizar estes exemplos como referência para estrutura, formatação e nível de detalhamento.

---

Feature: Exemplos de cenários BDD para Zephyr Scale

---

Scenario: [cobr] POST /cobr - deve criar cobrança recorrente com payload mínimo válido

Objetivo:
Validar a criação de cobrança recorrente utilizando apenas os campos obrigatórios.

Precondição:
Dado que exista um idRec ativo e válido.
E o recebedor esteja autorizado para a operação.

Given que possuo um payload mínimo válido
And possuo um token válido com scope adequado

When envio uma requisição POST para /cobr
"""
curl --location 'https://pix.example.com/api/cobr' 
--header 'Authorization: Bearer {{token}}' 
--header 'Content-Type: application/json' 
--data '{
"idRec":"RR1234567820240115abcdefghijk",
"calendario":{
"dataDeVencimento":"2024-04-15"
},
"valor":{
"original":"106.07"
},
"recebedor":{
"agencia":"9708",
"conta":"012682",
"tipoConta":"CORRENTE"
}
}'
"""

Then a API deve retornar status code 201
And o response deve respeitar o JSON schema de criação da cobrança
And o response body deve refletir os dados enviados
"""
{
"idRec":"RR1234567820240115abcdefghijk",
"txid":"3136957d93134f2184b369e8f1c0729d",
"status":"CRIADA"
}
"""

And o campo status deve ser igual a "CRIADA"
And deve ser gerado um txid

---

Scenario: [cobr] POST /cobr - deve rejeitar ausência de idRec

Objetivo:
Validar que a API rejeita requisições sem o campo obrigatório idRec.

Precondição:
Dado que exista um token válido com scope adequado.

Given que possuo um payload sem o campo idRec
And possuo um token válido com scope adequado

When envio uma requisição POST para /cobr
"""
curl --location 'https://pix.example.com/api/cobr' 
--header 'Authorization: Bearer {{token}}' 
--header 'Content-Type: application/json' 
--data '{
"calendario":{
"dataDeVencimento":"2024-04-15"
},
"valor":{
"original":"106.07"
}
}'
"""

Then a API deve retornar status code 400
And o response deve respeitar o JSON schema de erro
And o response body deve indicar operação inválida
"""
{
"type":"https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
"title":"Operação inválida.",
"status":400,
"detail":"A cobrança não respeita o schema.",
"violacoes":[
{
"razao":"O campo obrigatório idRec não foi informado.",
"propriedade":"cobr.idRec"
}
]
}
"""

And a violação deve referenciar "cobr.idRec"

---

Scenario: [cobr] PATCH /cobr/{txid} - deve cancelar cobrança recorrente

Objetivo:
Validar o cancelamento de uma cobrança recorrente elegível.

Precondição:
Dado que exista uma cobrança ativa para o txid informado.

Given que possuo uma cobrança elegível para cancelamento
And possuo um token válido com scope adequado

When envio uma requisição PATCH para /cobr/{txid}
"""
curl --location --request PATCH 'https://pix.example.com/api/cobr/517bd858b59d458a841280b0f0a60bfa' 
--header 'Authorization: Bearer {{token}}' 
--header 'Content-Type: application/json' 
--data '{
"status":"CANCELADA"
}'
"""

Then a API deve retornar status code 200
And o response deve respeitar o JSON schema de cancelamento
And o response body deve refletir o cancelamento
"""
{
"txid":"517bd858b59d458a841280b0f0a60bfa",
"status":"CANCELADA"
}
"""

And o campo status deve ser igual a "CANCELADA"

---

Scenario: [cobr] PATCH /cobr/{txid} - deve rejeitar cobrança inexistente

Objetivo:
Validar que a API rejeita o cancelamento quando a cobrança não existir.

Precondição:
Dado que o txid informado não esteja associado a nenhuma cobrança.

Given que possuo um txid inexistente
And possuo um token válido com scope adequado

When envio uma requisição PATCH para /cobr/{txid}
"""
curl --location --request PATCH 'https://pix.example.com/api/cobr/99999999999999999999999999999999' 
--header 'Authorization: Bearer {{token}}' 
--header 'Content-Type: application/json' 
--data '{
"status":"CANCELADA"
}'
"""

Then a API deve retornar status code 404
And o response deve respeitar o JSON schema de erro
And o response body deve indicar recurso inexistente
"""
{
"type":"https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
"title":"Operação inválida.",
"status":404,
"detail":"A cobrança informada não foi encontrada."
}
"""

And o campo status deve ser igual a 404

---

Scenario: [pix] Pagamento Pix por chave - deve concluir liquidação com sucesso

Objetivo:
Validar o fluxo completo de pagamento Pix utilizando chave.

Precondição:
Dado que exista saldo disponível na conta pagadora.
E a chave Pix do recebedor esteja ativa.

Given que possuo um pagamento Pix válido

When envio a requisição de pagamento
"""
curl ...
"""
And consulto o banco de dados para verificar persistência
And consulto o tópico Kafka responsável pela liquidação

Then a API deve retornar status code 201
And o response deve respeitar o JSON schema esperado
And o pagamento deve estar persistido no banco
And o evento de liquidação deve ser publicado no Kafka

---

# Regras derivadas dos exemplos

* Todo cenário possui Objetivo.
* Todo cenário possui Precondição.
* Os steps utilizam Given/When/Then/And.
* Curl é obrigatório em APIs.
* Response JSON é obrigatório.
* Status code é obrigatório.
* JSON Schema é obrigatório.
* Regras de negócio são obrigatórias.
* Fluxos podem conter banco e Kafka.
* O agente deve reproduzir este nível de detalhamento.
