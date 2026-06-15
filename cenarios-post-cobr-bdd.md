Feature: POST /cobr - Criação de cobrança recorrente

Scenario: POST /cobr - deve criar cobrança recorrente com payload mínimo válido
  Objetivo: Validar a criação de cobrança recorrente utilizando apenas os campos obrigatórios.

  Precondição:
    Dado que existe um idRec ativo e válido para o recebedor informado
    E o recebedor possui permissão para criar cobranças recorrentes

  Given que possuo um payload mínimo válido
  And possuo um token válido com scope adequado
  When envio uma requisição POST para /cobr
    """
    curl --location 'https://pix.example.com/api/cobr' \
    --header 'Authorization: Bearer {{token}}' \
    --header 'Content-Type: application/json' \
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
  And o response deve respeitar o JSON schema de criação de cobrança recorrente
  And o response body deve retornar a cobrança criada
    """
    {
      "idRec":"RR1234567820240115abcdefghijk",
      "txid":"3136957d93134f2184b369e8f1c0729d",
      "calendario":{
        "criacao":"2024-04-01",
        "dataDeVencimento":"2024-04-15"
      },
      "status":"CRIADA",
      "valor":{
        "original":"106.07"
      },
      "politicaRetentativa":"PERMITE_3R_7D",
      "recebedor":{
        "agencia":"9708",
        "conta":"012682",
        "tipoConta":"CORRENTE"
      },
      "atualizacao":[
        {
          "data":"2024-04-01T14:47:29.470Z",
          "status":"CRIADA"
        }
      ]
    }
    """
  And o campo status deve ser igual a "CRIADA"
  And deve ser gerado um txid
  And o histórico de atualização deve possuir o status "CRIADA"


Scenario: POST /cobr - deve criar cobrança recorrente com payload completo
  Objetivo: Validar a criação de cobrança recorrente com todos os campos opcionais preenchidos.

  Precondição:
    Dado que existe um idRec ativo e válido
    E o recebedor está habilitado para a operação

  Given que possuo um payload completo válido
  And possuo um token válido com scope adequado
  When envio uma requisição POST para /cobr
    """
    curl --location 'https://pix.example.com/api/cobr' \
    --header 'Authorization: Bearer {{token}}' \
    --header 'Content-Type: application/json' \
    --data '{
      "idRec":"RR1234567820240115abcdefghijk",
      "infoAdicional":"Serviços de Streamming de Música e Filmes.",
      "calendario":{
        "dataDeVencimento":"2024-04-15"
      },
      "valor":{
        "original":"106.07"
      },
      "ajusteDiaUtil":true,
      "devedor":{
        "cep":"89256-140",
        "cidade":"Uberlândia",
        "email":"sebastiao.tavares@mail.com",
        "logradouro":"Alameda Franco 1056",
        "uf":"MG"
      },
      "recebedor":{
        "agencia":"9708",
        "conta":"012682",
        "tipoConta":"CORRENTE"
      }
    }'
    """
  Then a API deve retornar status code 201
  And o response deve respeitar o JSON schema de criação de cobrança recorrente
  And o response body deve refletir os dados enviados
    """
    {
      "idRec":"RR1234567820240115abcdefghijk",
      "txid":"3136957d93134f2184b369e8f1c0729d",
      "infoAdicional":"Serviços de Streamming de Música e Filmes.",
      "calendario":{
        "criacao":"2024-04-01",
        "dataDeVencimento":"2024-04-15"
      },
      "status":"CRIADA",
      "valor":{
        "original":"106.07"
      },
      "politicaRetentativa":"PERMITE_3R_7D",
      "ajusteDiaUtil":true,
      "devedor":{
        "cep":"89256-140",
        "cidade":"Uberlândia",
        "email":"sebastiao.tavares@mail.com",
        "logradouro":"Alameda Franco 1056",
        "uf":"MG"
      },
      "recebedor":{
        "agencia":"9708",
        "conta":"012682",
        "tipoConta":"CORRENTE"
      },
      "atualizacao":[
        {
          "data":"2024-04-01T14:47:29.470Z",
          "status":"CRIADA"
        }
      ]
    }
    """
  And todos os campos enviados devem ser retornados corretamente


Scenario: POST /cobr - deve criar cobrança com ajusteDiaUtil=true
  Objetivo: Validar a criação da cobrança com ajuste automático para dia útil habilitado.

  Precondição:
    Dado que existe um idRec ativo e válido

  Given que possuo um payload válido com ajusteDiaUtil igual a true
  When envio a requisição POST
    """
    curl --location 'https://pix.example.com/api/cobr'
    """
  Then a API deve retornar status code 201
  And o response deve respeitar o JSON schema de criação de cobrança recorrente
  And o response body deve conter ajusteDiaUtil igual a true
    """
    {
      "ajusteDiaUtil": true,
      "status": "CRIADA"
    }
    """


Scenario: POST /cobr - deve criar cobrança com ajusteDiaUtil=false
  Objetivo: Validar a criação da cobrança com ajuste automático para dia útil desabilitado.

  Precondição:
    Dado que existe um idRec ativo e válido

  Given que possuo um payload válido com ajusteDiaUtil igual a false
  When envio a requisição POST
    """
    curl --location 'https://pix.example.com/api/cobr'
    """
  Then a API deve retornar status code 201
  And o response deve respeitar o JSON schema de criação de cobrança recorrente
  And o response body deve conter ajusteDiaUtil igual a false
    """
    {
      "ajusteDiaUtil": false,
      "status": "CRIADA"
    }
    """


Scenario: POST /cobr - deve aceitar dataDeVencimento igual à data atual
  Objetivo: Validar que a API aceita cobranças cujo vencimento seja igual à data corrente.

  Precondição:
    Dado que a data atual do sistema seja "2024-04-01"

  Given que possuo um payload válido
  And dataDeVencimento igual à data atual
  When envio a requisição POST
    """
    curl --location 'https://pix.example.com/api/cobr'
    """
  Then a API deve retornar status code 201
  And o response deve respeitar o JSON schema de criação de cobrança recorrente
  And o response body deve conter a dataDeVencimento igual à data enviada
    """
    {
      "calendario":{
        "criacao":"2024-04-01",
        "dataDeVencimento":"2024-04-01"
      },
      "status":"CRIADA"
    }
    """


Scenario: POST /cobr - deve aceitar valor mínimo permitido
  Objetivo: Validar a criação da cobrança utilizando o menor valor permitido pela regra de negócio.

  Precondição:
    Dado que exista um idRec ativo e válido

  Given que possuo um payload válido
  And o valor original mínimo permitido
  When envio a requisição POST
    """
    curl --location 'https://pix.example.com/api/cobr'
    """
  Then a API deve retornar status code 201
  And o response deve respeitar o JSON schema de criação de cobrança recorrente
  And o response body deve retornar o valor mínimo informado
    """
    {
      "valor":{
        "original":"0.01"
      },
      "status":"CRIADA"
    }
    """


Scenario: POST /cobr - deve aceitar valor máximo permitido
  Objetivo: Validar a criação da cobrança utilizando o maior valor permitido pela regra de negócio.

  Precondição:
    Dado que exista um idRec ativo e válido

  Given que possuo um payload válido
  And o valor original máximo permitido
  When envio a requisição POST
    """
    curl --location 'https://pix.example.com/api/cobr'
    """
  Then a API deve retornar status code 201
  And o response deve respeitar o JSON schema de criação de cobrança recorrente
  And o response body deve retornar o valor máximo informado
    """
    {
      "valor":{
        "original":"999999999.99"
      },
      "status":"CRIADA"
    }
    """
Scenario: POST /cobr - deve rejeitar payload vazio
  Objetivo: Validar que a API rejeita a criação de cobrança recorrente quando o payload da requisição estiver vazio.

  Precondição:
    Dado que o recebedor possua autorização para criar cobranças recorrentes
    E possua um token válido com scope adequado

  Given que possuo um payload vazio
  And possuo um token válido com scope adequado
  When envio uma requisição POST para /cobr
    """
    curl --location 'https://pix.example.com/api/cobr' \
    --header 'Authorization: Bearer {{token}}' \
    --header 'Content-Type: application/json' \
    --data '{}'
    """
  Then a API deve retornar status code 400
  And o response deve respeitar o JSON schema de erro
  And o response body deve indicar que o payload não respeita o schema
    """
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
    """
  And a violação deve referenciar a propriedade "cobr"


Scenario: POST /cobr - deve rejeitar ausência de idRec
  Objetivo: Validar que a API rejeita a criação de cobrança quando o campo obrigatório idRec não for informado.

  Precondição:
    Dado que exista um token válido com scope adequado

  Given que possuo um payload sem o campo idRec
  And possuo um token válido com scope adequado
  When envio uma requisição POST para /cobr
    """
    curl --location 'https://pix.example.com/api/cobr' \
    --header 'Authorization: Bearer {{token}}' \
    --header 'Content-Type: application/json' \
    --data '{
      "calendario": {
        "dataDeVencimento": "2024-04-15"
      },
      "valor": {
        "original": "106.07"
      },
      "recebedor": {
        "agencia": "9708",
        "conta": "012682",
        "tipoConta": "CORRENTE"
      }
    }'
    """
  Then a API deve retornar status code 400
  And o response deve respeitar o JSON schema de erro
  And o response body deve indicar ausência do campo obrigatório idRec
    """
    {
      "type": "https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
      "title": "Operação inválida.",
      "status": 400,
      "detail": "A cobrança não respeita o schema.",
      "violacoes": [
        {
          "razao": "O campo obrigatório idRec não foi informado.",
          "propriedade": "cobr.idRec"
        }
      ]
    }
    """
  And a violação deve referenciar a propriedade "cobr.idRec"


Scenario: POST /cobr - deve rejeitar idRec nulo
  Objetivo: Validar que a API rejeita a criação de cobrança quando o campo idRec for enviado com valor nulo.

  Precondição:
    Dado que exista um token válido com scope adequado

  Given que possuo um payload com idRec nulo
  And possuo um token válido com scope adequado
  When envio uma requisição POST para /cobr
    """
    curl --location 'https://pix.example.com/api/cobr' \
    --header 'Authorization: Bearer {{token}}' \
    --header 'Content-Type: application/json' \
    --data '{
      "idRec": null,
      "calendario": {
        "dataDeVencimento": "2024-04-15"
      },
      "valor": {
        "original": "106.07"
      },
      "recebedor": {
        "agencia": "9708",
        "conta": "012682",
        "tipoConta": "CORRENTE"
      }
    }'
    """
  Then a API deve retornar status code 400
  And o response deve respeitar o JSON schema de erro
  And o response body deve indicar que idRec não respeita o schema
    """
    {
      "type": "https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
      "title": "Operação inválida.",
      "status": 400,
      "detail": "A cobrança não respeita o schema.",
      "violacoes": [
        {
          "razao": "O objeto cobr.idRec não respeita o schema.",
          "propriedade": "cobr.idRec"
        }
      ]
    }
    """
  And a violação deve referenciar a propriedade "cobr.idRec"
  And o campo detail deve ser igual a "A cobrança não respeita o schema."

  Scenario: POST /cobr - deve rejeitar idRec vazio
  Objetivo: Validar que a API rejeita a criação de cobrança quando o campo idRec for informado vazio.

  Precondição:
    Dado que o recebedor possua autorização para criar cobranças recorrentes
    E possua um token válido com scope adequado

  Given que possuo um payload com idRec vazio
  And possuo um token válido com scope adequado
  When envio uma requisição POST para /cobr
    """
    curl --location 'https://pix.example.com/api/cobr' \
    --header 'Authorization: Bearer {{token}}' \
    --header 'Content-Type: application/json' \
    --data '{
      "idRec": "",
      "calendario": {
        "dataDeVencimento": "2024-04-15"
      },
      "valor": {
        "original": "106.07"
      },
      "recebedor": {
        "agencia": "9708",
        "conta": "012682",
        "tipoConta": "CORRENTE"
      }
    }'
    """
  Then a API deve retornar status code 400
  And o response deve respeitar o JSON schema de erro
  And o response body deve indicar que idRec não respeita o schema
    """
    {
      "type": "https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
      "title": "Operação inválida.",
      "status": 400,
      "detail": "A cobrança não respeita o schema.",
      "violacoes": [
        {
          "razao": "O objeto cobr.idRec não respeita o schema.",
          "propriedade": "cobr.idRec"
        }
      ]
    }
    """
  And a violação deve referenciar a propriedade "cobr.idRec"


Scenario: POST /cobr - deve rejeitar idRec inexistente
  Objetivo: Validar que a API rejeita a criação de cobrança quando o idRec informado não existir.

  Precondição:
    Dado que o idRec informado não esteja cadastrado
    E possua um token válido com scope adequado

  Given que possuo um payload com idRec inexistente
  And possuo um token válido com scope adequado
  When envio uma requisição POST para /cobr
    """
    curl --location 'https://pix.example.com/api/cobr' \
    --header 'Authorization: Bearer {{token}}' \
    --header 'Content-Type: application/json' \
    --data '{
      "idRec": "RR0000000020240115abcdefghijk",
      "calendario": {
        "dataDeVencimento": "2024-04-15"
      },
      "valor": {
        "original": "106.07"
      },
      "recebedor": {
        "agencia": "9708",
        "conta": "012682",
        "tipoConta": "CORRENTE"
      }
    }'
    """
  Then a API deve retornar status code 404
  And o response deve respeitar o JSON schema de erro de recurso não encontrado
  And o response body deve indicar que o idRec não foi localizado
    """
    {
      "type": "https://pix.bcb.gov.br/api/v2/error/RecursoNaoEncontrado",
      "title": "Recurso não encontrado.",
      "status": 404,
      "detail": "O idRec informado não foi encontrado."
    }
    """
  And o campo status deve ser igual a 404
  And o campo detail deve informar que o idRec não existe


Scenario: POST /cobr - deve rejeitar idRec cancelado
  Objetivo: Validar que a API rejeita a criação de cobrança quando o idRec estiver cancelado.

  Precondição:
    Dado que o idRec exista com status cancelado
    E possua um token válido com scope adequado

  Given que possuo um payload com idRec cancelado
  And possuo um token válido com scope adequado
  When envio uma requisição POST para /cobr
    """
    curl --location 'https://pix.example.com/api/cobr' \
    --header 'Authorization: Bearer {{token}}' \
    --header 'Content-Type: application/json' \
    --data '{
      "idRec": "RR1234567820240115abcdefghijk",
      "calendario": {
        "dataDeVencimento": "2024-04-15"
      },
      "valor": {
        "original": "106.07"
      },
      "recebedor": {
        "agencia": "9708",
        "conta": "012682",
        "tipoConta": "CORRENTE"
      }
    }'
    """
  Then a API deve retornar status code 400
  And o response deve respeitar o JSON schema de erro
  And o response body deve indicar que o idRec não permite criação de cobrança
    """
    {
      "type": "https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
      "title": "Operação inválida.",
      "status": 400,
      "detail": "A cobrança não respeita o schema.",
      "violacoes": [
        {
          "razao": "O idRec informado encontra-se cancelado.",
          "propriedade": "cobr.idRec"
        }
      ]
    }
    """
  And a violação deve referenciar a propriedade "cobr.idRec"


Scenario: POST /cobr - deve rejeitar calendário ausente
  Objetivo: Validar que a API rejeita a criação de cobrança quando o objeto calendario não for informado.

  Precondição:
    Dado que exista um idRec ativo e válido
    E possua um token válido com scope adequado

  Given que possuo um payload sem o objeto calendario
  And possuo um token válido com scope adequado
  When envio uma requisição POST para /cobr
    """
    curl --location 'https://pix.example.com/api/cobr' \
    --header 'Authorization: Bearer {{token}}' \
    --header 'Content-Type: application/json' \
    --data '{
      "idRec": "RR1234567820240115abcdefghijk",
      "valor": {
        "original": "106.07"
      },
      "recebedor": {
        "agencia": "9708",
        "conta": "012682",
        "tipoConta": "CORRENTE"
      }
    }'
    """
  Then a API deve retornar status code 400
  And o response deve respeitar o JSON schema de erro
  And o response body deve indicar ausência do objeto calendario
    """
    {
      "type": "https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
      "title": "Operação inválida.",
      "status": 400,
      "detail": "A cobrança não respeita o schema.",
      "violacoes": [
        {
          "razao": "O objeto cobr.calendario não respeita o schema.",
          "propriedade": "cobr.calendario"
        }
      ]
    }
    """
  And a violação deve referenciar a propriedade "cobr.calendario"
  Scenario: POST /cobr - deve rejeitar calendário inválido
  Objetivo: Validar que a API rejeita a criação da cobrança quando o objeto calendario não respeita o schema.

  Precondição:
    Dado que exista um idRec ativo e válido
    E possua um token válido com scope adequado

  Given que possuo um payload com objeto calendario inválido
  And possuo um token válido com scope adequado
  When envio uma requisição POST para /cobr
    """
    curl --location 'https://pix.example.com/api/cobr' \
    --header 'Authorization: Bearer {{token}}' \
    --header 'Content-Type: application/json' \
    --data '{
      "idRec": "RR1234567820240115abcdefghijk",
      "calendario": "2024-04-15",
      "valor": {
        "original": "106.07"
      },
      "recebedor": {
        "agencia": "9708",
        "conta": "012682",
        "tipoConta": "CORRENTE"
      }
    }'
    """
  Then a API deve retornar status code 400
  And o response deve respeitar o JSON schema de erro
  And o response body deve indicar calendário inválido
    """
    {
      "type": "https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
      "title": "Operação inválida.",
      "status": 400,
      "detail": "A cobrança não respeita o schema.",
      "violacoes": [
        {
          "razao": "O objeto cobr.calendario não respeita o schema.",
          "propriedade": "cobr.calendario"
        }
      ]
    }
    """
  And a violação deve referenciar "cobr.calendario"


Scenario: POST /cobr - deve rejeitar dataDeVencimento inválida
  Objetivo: Validar que a API rejeita a criação da cobrança quando dataDeVencimento possuir formato inválido.

  Precondição:
    Dado que exista um idRec ativo e válido
    E possua um token válido com scope adequado

  Given que possuo um payload com dataDeVencimento inválida
  When envio uma requisição POST para /cobr
    """
    curl --location 'https://pix.example.com/api/cobr' \
    --header 'Authorization: Bearer {{token}}' \
    --header 'Content-Type: application/json' \
    --data '{
      "idRec": "RR1234567820240115abcdefghijk",
      "calendario": {
        "dataDeVencimento": "15/04/2024"
      },
      "valor": {
        "original": "106.07"
      },
      "recebedor": {
        "agencia": "9708",
        "conta": "012682",
        "tipoConta": "CORRENTE"
      }
    }'
    """
  Then a API deve retornar status code 400
  And o response deve respeitar o JSON schema de erro
  And o response body deve indicar formato inválido da dataDeVencimento
    """
    {
      "type": "https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
      "title": "Operação inválida.",
      "status": 400,
      "detail": "A cobrança não respeita o schema.",
      "violacoes": [
        {
          "razao": "O objeto cobr.calendario.dataDeVencimento não respeita o schema.",
          "propriedade": "cobr.calendario.dataDeVencimento"
        }
      ]
    }
    """
  And a violação deve referenciar "cobr.calendario.dataDeVencimento"


Scenario: POST /cobr - deve rejeitar dataDeVencimento anterior à criação
  Objetivo: Validar que a API rejeita cobranças cuja data de vencimento seja anterior à data atual.

  Precondição:
    Dado que a data atual do sistema seja "2024-04-01"
    E possua um token válido com scope adequado

  Given que possuo um payload com dataDeVencimento anterior à criação
  When envio uma requisição POST para /cobr
    """
    curl --location 'https://pix.example.com/api/cobr' \
    --header 'Authorization: Bearer {{token}}' \
    --header 'Content-Type: application/json' \
    --data '{
      "idRec": "RR1234567820240115abcdefghijk",
      "calendario": {
        "dataDeVencimento": "2024-03-31"
      },
      "valor": {
        "original": "106.07"
      },
      "recebedor": {
        "agencia": "9708",
        "conta": "012682",
        "tipoConta": "CORRENTE"
      }
    }'
    """
  Then a API deve retornar status code 400
  And o response deve respeitar o JSON schema de erro
  And o response body deve indicar que a dataDeVencimento é inválida
    """
    {
      "type": "https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
      "title": "Operação inválida.",
      "status": 400,
      "detail": "A cobrança não respeita o schema.",
      "violacoes": [
        {
          "razao": "A dataDeVencimento deve ser igual ou posterior à data atual.",
          "propriedade": "cobr.calendario.dataDeVencimento"
        }
      ]
    }
    """
  And a violação deve referenciar "cobr.calendario.dataDeVencimento"


Scenario: POST /cobr - deve rejeitar valor ausente
  Objetivo: Validar que a API rejeita a criação da cobrança quando o objeto valor não for informado.

  Precondição:
    Dado que exista um idRec ativo e válido
    E possua um token válido com scope adequado

  Given que possuo um payload sem o objeto valor
  When envio uma requisição POST para /cobr
    """
    curl --location 'https://pix.example.com/api/cobr' \
    --header 'Authorization: Bearer {{token}}' \
    --header 'Content-Type: application/json' \
    --data '{
      "idRec": "RR1234567820240115abcdefghijk",
      "calendario": {
        "dataDeVencimento": "2024-04-15"
      },
      "recebedor": {
        "agencia": "9708",
        "conta": "012682",
        "tipoConta": "CORRENTE"
      }
    }'
    """
  Then a API deve retornar status code 400
  And o response deve respeitar o JSON schema de erro
  And o response body deve indicar ausência do objeto valor
    """
    {
      "type": "https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
      "title": "Operação inválida.",
      "status": 400,
      "detail": "A cobrança não respeita o schema.",
      "violacoes": [
        {
          "razao": "O objeto cobr.valor não respeita o schema.",
          "propriedade": "cobr.valor"
        }
      ]
    }
    """
  And a violação deve referenciar "cobr.valor"


Scenario: POST /cobr - deve rejeitar valor inválido
  Objetivo: Validar que a API rejeita a criação da cobrança quando valor.original possuir formato inválido.

  Precondição:
    Dado que exista um idRec ativo e válido
    E possua um token válido com scope adequado

  Given que possuo um payload com valor inválido
  When envio uma requisição POST para /cobr
    """
    curl --location 'https://pix.example.com/api/cobr' \
    --header 'Authorization: Bearer {{token}}' \
    --header 'Content-Type: application/json' \
    --data '{
      "idRec": "RR1234567820240115abcdefghijk",
      "calendario": {
        "dataDeVencimento": "2024-04-15"
      },
      "valor": {
        "original": "ABC"
      },
      "recebedor": {
        "agencia": "9708",
        "conta": "012682",
        "tipoConta": "CORRENTE"
      }
    }'
    """
  Then a API deve retornar status code 400
  And o response deve respeitar o JSON schema de erro
  And o response body deve indicar valor inválido
    """
    {
      "type": "https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
      "title": "Operação inválida.",
      "status": 400,
      "detail": "A cobrança não respeita o schema.",
      "violacoes": [
        {
          "razao": "O objeto cobr.valor.original não respeita o schema.",
          "propriedade": "cobr.valor.original"
        }
      ]
    }
    """
  And a violação deve referenciar "cobr.valor.original"


Scenario: POST /cobr - deve rejeitar valor igual a zero
  Objetivo: Validar que a API rejeita cobranças com valor igual a zero.

  Precondição:
    Dado que exista um idRec ativo e válido
    E possua um token válido com scope adequado

  Given que possuo um payload com valor igual a zero
  When envio uma requisição POST para /cobr
    """
    curl --location 'https://pix.example.com/api/cobr' \
    --header 'Authorization: Bearer {{token}}' \
    --header 'Content-Type: application/json' \
    --data '{
      "idRec": "RR1234567820240115abcdefghijk",
      "calendario": {
        "dataDeVencimento": "2024-04-15"
      },
      "valor": {
        "original": "0.00"
      },
      "recebedor": {
        "agencia": "9708",
        "conta": "012682",
        "tipoConta": "CORRENTE"
      }
    }'
    """
  Then a API deve retornar status code 400
  And o response deve respeitar o JSON schema de erro
  And o response body deve indicar que o valor deve ser maior que zero
    """
    {
      "type": "https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
      "title": "Operação inválida.",
      "status": 400,
      "detail": "A cobrança não respeita o schema.",
      "violacoes": [
        {
          "razao": "O valor original deve ser maior que zero.",
          "propriedade": "cobr.valor.original"
        }
      ]
    }
    """
  And a violação deve referenciar "cobr.valor.original"


Scenario: POST /cobr - deve rejeitar valor negativo
  Objetivo: Validar que a API rejeita cobranças com valor negativo.

  Precondição:
    Dado que exista um idRec ativo e válido
    E possua um token válido com scope adequado

  Given que possuo um payload com valor negativo
  When envio uma requisição POST para /cobr
    """
    curl --location 'https://pix.example.com/api/cobr' \
    --header 'Authorization: Bearer {{token}}' \
    --header 'Content-Type: application/json' \
    --data '{
      "idRec": "RR1234567820240115abcdefghijk",
      "calendario": {
        "dataDeVencimento": "2024-04-15"
      },
      "valor": {
        "original": "-10.00"
      },
      "recebedor": {
        "agencia": "9708",
        "conta": "012682",
        "tipoConta": "CORRENTE"
      }
    }'
    """
  Then a API deve retornar status code 400
  And o response deve respeitar o JSON schema de erro
  And o response body deve indicar que o valor deve ser maior que zero
    """
    {
      "type": "https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
      "title": "Operação inválida.",
      "status": 400,
      "detail": "A cobrança não respeita o schema.",
      "violacoes": [
        {
          "razao": "O valor original deve ser maior que zero.",
          "propriedade": "cobr.valor.original"
        }
      ]
    }
    """
  And a violação deve referenciar "cobr.valor.original"

  Scenario: POST /cobr - deve rejeitar recebedor ausente
  Objetivo: Validar que a API rejeita a criação da cobrança recorrente quando o objeto recebedor não for informado.

  Precondição:
    Dado que exista um idRec ativo e válido
    E possua um token válido com scope adequado

  Given que possuo um payload sem o objeto recebedor
  And possuo um token válido com scope adequado
  When envio uma requisição POST para /cobr
    """
    curl --location 'https://pix.example.com/api/cobr' \
    --header 'Authorization: Bearer {{token}}' \
    --header 'Content-Type: application/json' \
    --data '{
      "idRec": "RR1234567820240115abcdefghijk",
      "calendario": {
        "dataDeVencimento": "2024-04-15"
      },
      "valor": {
        "original": "106.07"
      }
    }'
    """
  Then a API deve retornar status code 400
  And o response deve respeitar o JSON schema de erro
  And o response body deve indicar ausência do objeto recebedor
    """
    {
      "type": "https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
      "title": "Operação inválida.",
      "status": 400,
      "detail": "A cobrança não respeita o schema.",
      "violacoes": [
        {
          "razao": "O objeto cobr.recebedor não respeita o schema.",
          "propriedade": "cobr.recebedor"
        }
      ]
    }
    """
  And a violação deve referenciar a propriedade "cobr.recebedor"


Scenario: POST /cobr - deve rejeitar recebedor inválido
  Objetivo: Validar que a API rejeita a criação da cobrança quando os dados do recebedor não respeitam o schema.

  Precondição:
    Dado que exista um idRec ativo e válido
    E possua um token válido com scope adequado

  Given que possuo um payload com recebedor inválido
  And possuo um token válido com scope adequado
  When envio uma requisição POST para /cobr
    """
    curl --location 'https://pix.example.com/api/cobr' \
    --header 'Authorization: Bearer {{token}}' \
    --header 'Content-Type: application/json' \
    --data '{
      "idRec": "RR1234567820240115abcdefghijk",
      "calendario": {
        "dataDeVencimento": "2024-04-15"
      },
      "valor": {
        "original": "106.07"
      },
      "recebedor": {
        "agencia": "",
        "conta": "",
        "tipoConta": "CORRENTE"
      }
    }'
    """
  Then a API deve retornar status code 400
  And o response deve respeitar o JSON schema de erro
  And o response body deve indicar dados inválidos do recebedor
    """
    {
      "type": "https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
      "title": "Operação inválida.",
      "status": 400,
      "detail": "A cobrança não respeita o schema.",
      "violacoes": [
        {
          "razao": "O objeto cobr.recebedor não respeita o schema.",
          "propriedade": "cobr.recebedor"
        }
      ]
    }
    """
  And a violação deve referenciar a propriedade "cobr.recebedor"


Scenario: POST /cobr - deve rejeitar conta não pertencente ao recebedor
  Objetivo: Validar que a API rejeita a criação da cobrança quando a conta informada não pertence ao recebedor autenticado.

  Precondição:
    Dado que exista um idRec ativo e válido
    E o token pertença a outro recebedor

  Given que possuo um payload com conta não pertencente ao recebedor autenticado
  And possuo um token válido com scope adequado
  When envio uma requisição POST para /cobr
    """
    curl --location 'https://pix.example.com/api/cobr' \
    --header 'Authorization: Bearer {{token}}' \
    --header 'Content-Type: application/json' \
    --data '{
      "idRec": "RR1234567820240115abcdefghijk",
      "calendario": {
        "dataDeVencimento": "2024-04-15"
      },
      "valor": {
        "original": "106.07"
      },
      "recebedor": {
        "agencia": "1111",
        "conta": "999999",
        "tipoConta": "CORRENTE"
      }
    }'
    """
  Then a API deve retornar status code 400
  And o response deve respeitar o JSON schema de erro
  And o response body deve indicar incompatibilidade entre conta e recebedor
    """
    {
      "type": "https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
      "title": "Operação inválida.",
      "status": 400,
      "detail": "A cobrança não respeita o schema.",
      "violacoes": [
        {
          "razao": "A conta informada não pertence ao recebedor.",
          "propriedade": "cobr.recebedor"
        }
      ]
    }
    """
  And a violação deve referenciar a propriedade "cobr.recebedor"


Scenario: POST /cobr - deve rejeitar tipoConta inválido
  Objetivo: Validar que a API rejeita a criação da cobrança quando tipoConta possuir valor inválido.

  Precondição:
    Dado que exista um idRec ativo e válido
    E possua um token válido com scope adequado

  Given que possuo um payload com tipoConta inválido
  And possuo um token válido com scope adequado
  When envio uma requisição POST para /cobr
    """
    curl --location 'https://pix.example.com/api/cobr' \
    --header 'Authorization: Bearer {{token}}' \
    --header 'Content-Type: application/json' \
    --data '{
      "idRec": "RR1234567820240115abcdefghijk",
      "calendario": {
        "dataDeVencimento": "2024-04-15"
      },
      "valor": {
        "original": "106.07"
      },
      "recebedor": {
        "agencia": "9708",
        "conta": "012682",
        "tipoConta": "INVALIDO"
      }
    }'
    """
  Then a API deve retornar status code 400
  And o response deve respeitar o JSON schema de erro
  And o response body deve indicar tipoConta inválido
    """
    {
      "type": "https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
      "title": "Operação inválida.",
      "status": 400,
      "detail": "A cobrança não respeita o schema.",
      "violacoes": [
        {
          "razao": "O objeto cobr.recebedor.tipoConta não respeita o schema.",
          "propriedade": "cobr.recebedor.tipoConta"
        }
      ]
    }
    """
  And a violação deve referenciar a propriedade "cobr.recebedor.tipoConta"
  Scenario: POST /cobr - deve rejeitar devedor inválido
  Objetivo: Validar que a API rejeita a criação da cobrança recorrente quando o objeto devedor não respeita o schema.

  Precondição:
    Dado que exista um idRec ativo e válido
    E possua um token válido com scope adequado

  Given que possuo um payload com devedor inválido
  And possuo um token válido com scope adequado
  When envio uma requisição POST para /cobr
    """
    curl --location 'https://pix.example.com/api/cobr' \
    --header 'Authorization: Bearer {{token}}' \
    --header 'Content-Type: application/json' \
    --data '{
      "idRec": "RR1234567820240115abcdefghijk",
      "calendario": {
        "dataDeVencimento": "2024-04-15"
      },
      "valor": {
        "original": "106.07"
      },
      "devedor": {
        "cep": "ABC",
        "cidade": "",
        "email": "email-invalido",
        "logradouro": "",
        "uf": "XX"
      },
      "recebedor": {
        "agencia": "9708",
        "conta": "012682",
        "tipoConta": "CORRENTE"
      }
    }'
    """
  Then a API deve retornar status code 400
  And o response deve respeitar o JSON schema de erro
  And o response body deve indicar que o objeto devedor não respeita o schema
    """
    {
      "type": "https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
      "title": "Operação inválida.",
      "status": 400,
      "detail": "A cobrança não respeita o schema.",
      "violacoes": [
        {
          "razao": "O objeto cobr.devedor não respeita o schema.",
          "propriedade": "cobr.devedor"
        }
      ]
    }
    """
  And a violação deve referenciar a propriedade "cobr.devedor"


Scenario: POST /cobr - deve aceitar ausência do devedor
  Objetivo: Validar que a criação da cobrança recorrente é permitida sem o envio do objeto devedor.

  Precondição:
    Dado que exista um idRec ativo e válido
    E o recebedor esteja autorizado para a operação

  Given que possuo um payload válido sem o objeto devedor
  And possuo um token válido com scope adequado
  When envio uma requisição POST para /cobr
    """
    curl --location 'https://pix.example.com/api/cobr' \
    --header 'Authorization: Bearer {{token}}' \
    --header 'Content-Type: application/json' \
    --data '{
      "idRec": "RR1234567820240115abcdefghijk",
      "calendario": {
        "dataDeVencimento": "2024-04-15"
      },
      "valor": {
        "original": "106.07"
      },
      "recebedor": {
        "agencia": "9708",
        "conta": "012682",
        "tipoConta": "CORRENTE"
      }
    }'
    """
  Then a API deve retornar status code 201
  And o response deve respeitar o JSON schema de criação de cobrança recorrente
  And o response body deve retornar a cobrança criada
    """
    {
      "idRec": "RR1234567820240115abcdefghijk",
      "txid": "3136957d93134f2184b369e8f1c0729d",
      "calendario": {
        "criacao": "2024-04-01",
        "dataDeVencimento": "2024-04-15"
      },
      "status": "CRIADA",
      "valor": {
        "original": "106.07"
      },
      "politicaRetentativa": "PERMITE_3R_7D",
      "recebedor": {
        "agencia": "9708",
        "conta": "012682",
        "tipoConta": "CORRENTE"
      },
      "atualizacao": [
        {
          "data": "2024-04-01T14:47:29.470Z",
          "status": "CRIADA"
        }
      ]
    }
    """
  And o objeto devedor não deve ser retornado no response
  And o status da cobrança deve ser "CRIADA"


Scenario: POST /cobr - deve aceitar infoAdicional ausente
  Objetivo: Validar que a criação da cobrança recorrente é permitida sem o envio do campo infoAdicional.

  Precondição:
    Dado que exista um idRec ativo e válido
    E o recebedor esteja autorizado para a operação

  Given que possuo um payload válido sem o campo infoAdicional
  And possuo um token válido com scope adequado
  When envio uma requisição POST para /cobr
    """
    curl --location 'https://pix.example.com/api/cobr' \
    --header 'Authorization: Bearer {{token}}' \
    --header 'Content-Type: application/json' \
    --data '{
      "idRec": "RR1234567820240115abcdefghijk",
      "calendario": {
        "dataDeVencimento": "2024-04-15"
      },
      "valor": {
        "original": "106.07"
      },
      "recebedor": {
        "agencia": "9708",
        "conta": "012682",
        "tipoConta": "CORRENTE"
      }
    }'
    """
  Then a API deve retornar status code 201
  And o response deve respeitar o JSON schema de criação de cobrança recorrente
  And o response body deve retornar a cobrança criada
    """
    {
      "idRec": "RR1234567820240115abcdefghijk",
      "txid": "3136957d93134f2184b369e8f1c0729d",
      "calendario": {
        "criacao": "2024-04-01",
        "dataDeVencimento": "2024-04-15"
      },
      "status": "CRIADA",
      "valor": {
        "original": "106.07"
      },
      "politicaRetentativa": "PERMITE_3R_7D",
      "recebedor": {
        "agencia": "9708",
        "conta": "012682",
        "tipoConta": "CORRENTE"
      },
      "atualizacao": [
        {
          "data": "2024-04-01T14:47:29.470Z",
          "status": "CRIADA"
        }
      ]
    }
    """
  And o campo infoAdicional não deve ser retornado no response
  And o status da cobrança deve ser "CRIADA"


Scenario: POST /cobr - deve aceitar infoAdicional com tamanho mínimo
  Objetivo: Validar a criação da cobrança recorrente com infoAdicional no tamanho mínimo permitido.

  Precondição:
    Dado que exista um idRec ativo e válido
    E o recebedor esteja autorizado para a operação

  Given que possuo um payload válido com infoAdicional no tamanho mínimo
  And possuo um token válido com scope adequado
  When envio uma requisição POST para /cobr
    """
    curl --location 'https://pix.example.com/api/cobr' \
    --header 'Authorization: Bearer {{token}}' \
    --header 'Content-Type: application/json' \
    --data '{
      "idRec": "RR1234567820240115abcdefghijk",
      "infoAdicional": "A",
      "calendario": {
        "dataDeVencimento": "2024-04-15"
      },
      "valor": {
        "original": "106.07"
      },
      "recebedor": {
        "agencia": "9708",
        "conta": "012682",
        "tipoConta": "CORRENTE"
      }
    }'
    """
  Then a API deve retornar status code 201
  And o response deve respeitar o JSON schema de criação de cobrança recorrente
  And o response body deve retornar a cobrança criada
    """
    {
      "idRec": "RR1234567820240115abcdefghijk",
      "txid": "3136957d93134f2184b369e8f1c0729d",
      "infoAdicional": "A",
      "calendario": {
        "criacao": "2024-04-01",
        "dataDeVencimento": "2024-04-15"
      },
      "status": "CRIADA",
      "valor": {
        "original": "106.07"
      },
      "politicaRetentativa": "PERMITE_3R_7D",
      "recebedor": {
        "agencia": "9708",
        "conta": "012682",
        "tipoConta": "CORRENTE"
      },
      "atualizacao": [
        {
          "data": "2024-04-01T14:47:29.470Z",
          "status": "CRIADA"
        }
      ]
    }
    """
  And o campo infoAdicional deve ser retornado com o valor enviado
  And o status da cobrança deve ser "CRIADA"
  Scenario: POST /cobr - deve aceitar infoAdicional com tamanho máximo
  Objetivo: Validar a criação da cobrança recorrente quando o campo infoAdicional for informado com o tamanho máximo permitido.

  Precondição:
    Dado que exista um idRec ativo e válido
    E o recebedor esteja autorizado para a operação

  Given que possuo um payload válido com infoAdicional no tamanho máximo permitido
  And possuo um token válido com scope adequado
  When envio uma requisição POST para /cobr
    """
    curl --location 'https://pix.example.com/api/cobr' \
    --header 'Authorization: Bearer {{token}}' \
    --header 'Content-Type: application/json' \
    --data '{
      "idRec":"RR1234567820240115abcdefghijk",
      "infoAdicional":"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
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
  And o response deve respeitar o JSON schema de criação de cobrança recorrente
  And o response body deve refletir os dados enviados
    """
    {
      "idRec":"RR1234567820240115abcdefghijk",
      "txid":"3136957d93134f2184b369e8f1c0729d",
      "infoAdicional":"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
      "calendario":{
        "criacao":"2024-04-01",
        "dataDeVencimento":"2024-04-15"
      },
      "status":"CRIADA",
      "valor":{
        "original":"106.07"
      },
      "politicaRetentativa":"PERMITE_3R_7D",
      "recebedor":{
        "agencia":"9708",
        "conta":"012682",
        "tipoConta":"CORRENTE"
      },
      "atualizacao":[
        {
          "data":"2024-04-01T14:47:29.470Z",
          "status":"CRIADA"
        }
      ]
    }
    """
  And o campo infoAdicional deve ser retornado exatamente como enviado
  And o status da cobrança deve ser "CRIADA"


Scenario: POST /cobr - deve rejeitar infoAdicional acima do limite
  Objetivo: Validar que a API rejeita a criação da cobrança quando infoAdicional excede o tamanho máximo permitido.

  Precondição:
    Dado que exista um idRec ativo e válido
    E o recebedor esteja autorizado para a operação

  Given que possuo um payload com infoAdicional acima do limite permitido
  And possuo um token válido com scope adequado
  When envio uma requisição POST para /cobr
    """
    curl --location 'https://pix.example.com/api/cobr' \
    --header 'Authorization: Bearer {{token}}' \
    --header 'Content-Type: application/json' \
    --data '{
      "idRec":"RR1234567820240115abcdefghijk",
      "infoAdicional":"Texto acima do limite máximo permitido para o campo infoAdicional da cobrança recorrente, ultrapassando a quantidade de caracteres definida pela especificação.",
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
  Then a API deve retornar status code 400
  And o response deve respeitar o JSON schema de erro
  And o response body deve indicar violação do tamanho de infoAdicional
    """
    {
      "type":"https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
      "title":"Operação inválida.",
      "status":400,
      "detail":"A cobrança não respeita o schema.",
      "violacoes":[
        {
          "razao":"O objeto cobr.infoAdicional não respeita o schema.",
          "propriedade":"cobr.infoAdicional"
        }
      ]
    }
    """
  And a violação deve referenciar a propriedade "cobr.infoAdicional"


Scenario: POST /cobr - deve rejeitar status inválido
  Objetivo: Validar que a API rejeita a criação da cobrança quando o campo status é enviado pelo cliente.

  Precondição:
    Dado que exista um idRec ativo e válido
    E o recebedor esteja autorizado para a operação

  Given que possuo um payload com status inválido
  And possuo um token válido com scope adequado
  When envio uma requisição POST para /cobr
    """
    curl --location 'https://pix.example.com/api/cobr' \
    --header 'Authorization: Bearer {{token}}' \
    --header 'Content-Type: application/json' \
    --data '{
      "idRec":"RR1234567820240115abcdefghijk",
      "status":"PAGA",
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
  Then a API deve retornar status code 400
  And o response deve respeitar o JSON schema de erro
  And o response body deve indicar que status não respeita o schema
    """
    {
      "type":"https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
      "title":"Operação inválida.",
      "status":400,
      "detail":"A cobrança não respeita o schema.",
      "violacoes":[
        {
          "razao":"O objeto cobr.status não respeita o schema.",
          "propriedade":"cobr.status"
        }
      ]
    }
    """
  And a violação deve referenciar a propriedade "cobr.status"


Scenario: POST /cobr - deve rejeitar cobrança duplicada para mesmo ciclo
  Objetivo: Validar que a API rejeita a criação de uma cobrança duplicada para o mesmo ciclo recorrente.

  Precondição:
    Dado que já exista uma cobrança criada para o mesmo idRec e dataDeVencimento
    E o recebedor esteja autorizado para a operação

  Given que possuo um payload correspondente a uma cobrança já existente para o mesmo ciclo
  And possuo um token válido com scope adequado
  When envio uma requisição POST para /cobr
    """
    curl --location 'https://pix.example.com/api/cobr' \
    --header 'Authorization: Bearer {{token}}' \
    --header 'Content-Type: application/json' \
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
  Then a API deve retornar status code 400
  And o response deve respeitar o JSON schema de erro
  And o response body deve indicar tentativa de duplicidade
    """
    {
      "type":"https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
      "title":"Operação inválida.",
      "status":400,
      "detail":"A cobrança não respeita o schema.",
      "violacoes":[
        {
          "razao":"Já existe uma cobrança para o mesmo ciclo recorrente.",
          "propriedade":"cobr"
        }
      ]
    }
    """
  And a violação deve informar que não é permitida duplicidade para o mesmo ciclo

  Scenario: POST /cobr - deve rejeitar token expirado
  Objetivo: Validar que a API rejeita a criação da cobrança quando o token de autenticação estiver expirado.

  Precondição:
    Dado que exista um idRec ativo e válido
    E o token utilizado esteja expirado

  Given que possuo um payload válido
  And possuo um token expirado
  When envio uma requisição POST para /cobr
    """
    curl --location 'https://pix.example.com/api/cobr' \
    --header 'Authorization: Bearer {{token_expirado}}' \
    --header 'Content-Type: application/json' \
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
  Then a API deve retornar status code 401
  And o response deve respeitar o JSON schema de autenticação
  And o response body deve indicar token expirado
    """
    {
      "type":"https://pix.bcb.gov.br/api/v2/error/AcessoNegado",
      "title":"Acesso negado.",
      "status":401,
      "detail":"Token de acesso expirado."
    }
    """
  And o campo status deve ser igual a 401
  And o campo detail deve informar que o token expirou


Scenario: POST /cobr - deve rejeitar ausência de token
  Objetivo: Validar que a API rejeita a criação da cobrança quando o header Authorization não for enviado.

  Precondição:
    Dado que exista um idRec ativo e válido

  Given que possuo um payload válido
  And não possuo token de autenticação
  When envio uma requisição POST para /cobr
    """
    curl --location 'https://pix.example.com/api/cobr' \
    --header 'Content-Type: application/json' \
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
  Then a API deve retornar status code 401
  And o response deve respeitar o JSON schema de autenticação
  And o response body deve indicar ausência de credenciais
    """
    {
      "type":"https://pix.bcb.gov.br/api/v2/error/AcessoNegado",
      "title":"Acesso negado.",
      "status":401,
      "detail":"Token de acesso não informado."
    }
    """
  And o campo status deve ser igual a 401
  And o campo detail deve informar ausência de autenticação


Scenario: POST /cobr - deve rejeitar scope inválido
  Objetivo: Validar que a API rejeita a criação da cobrança quando o token não possuir o scope necessário.

  Precondição:
    Dado que exista um idRec ativo e válido
    E o token não possua o scope exigido para a operação

  Given que possuo um payload válido
  And possuo um token sem o scope adequado
  When envio uma requisição POST para /cobr
    """
    curl --location 'https://pix.example.com/api/cobr' \
    --header 'Authorization: Bearer {{token_scope_invalido}}' \
    --header 'Content-Type: application/json' \
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
  Then a API deve retornar status code 403
  And o response deve respeitar o JSON schema de autorização
  And o response body deve indicar escopo insuficiente
    """
    {
      "type":"https://pix.bcb.gov.br/api/v2/error/AcessoNegado",
      "title":"Acesso negado.",
      "status":403,
      "detail":"O token não possui permissão para executar esta operação."
    }
    """
  And o campo status deve ser igual a 403
  And o campo detail deve informar ausência de permissão


Scenario: POST /cobr - deve retornar serviço indisponível
  Objetivo: Validar o comportamento da API quando o serviço responsável pela criação da cobrança estiver indisponível.

  Precondição:
    Dado que exista um idRec ativo e válido
    E haja indisponibilidade temporária do serviço

  Given que possuo um payload válido
  And possuo um token válido com scope adequado
  When envio uma requisição POST para /cobr
    """
    curl --location 'https://pix.example.com/api/cobr' \
    --header 'Authorization: Bearer {{token}}' \
    --header 'Content-Type: application/json' \
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
  Then a API deve retornar status code 503
  And o response deve respeitar o JSON schema de indisponibilidade
  And o response body deve indicar indisponibilidade temporária
    """
    {
      "type":"https://pix.bcb.gov.br/api/v2/error/ServicoIndisponivel",
      "title":"Serviço indisponível.",
      "status":503,
      "detail":"O serviço está temporariamente indisponível. Tente novamente mais tarde."
    }
    """
  And o campo status deve ser igual a 503
  And o campo detail deve informar indisponibilidade temporária
