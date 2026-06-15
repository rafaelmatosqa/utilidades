Feature:  PUT /cobr/{txid} - Cobrança recorrente

Scenario:  PUT /cobr/{txid} - deve criar cobrança recorrente com payload mínimo válido
  Objetivo: Validar a criação de cobrança recorrente com os campos obrigatórios mínimos.
  Precondição: Deve existir um idRec ativo e válido vinculado ao recebedor.

  Given que possuo um txid válido e único
  And possuo um token válido com scope permitido
  When envio a requisição PUT para criação da cobrança
    """
    curl -X PUT "https://pix.example.com/api/cobr/3136957d93134f2184b369e8f1c0729d" \
      -H "Authorization: Bearer token_valido" \
      -H "Content-Type: application/json" \
      -d '{
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
  And o response body deve conter os dados da cobrança criada
    """
    {
      "idRec": "RR1234567820240115abcdefghijk",
      "txid": "3136957d93134f2184b369e8f1c0729d",
      "calendario": {
        "criacao": "2024-04-01",
        "dataDeVencimento": "2024-04-15"
      },
      "valor": {
        "original": "106.07"
      },
      "status": "CRIADA",
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
  And o campo status deve ser "CRIADA"
  And o campo txid deve ser igual ao txid informado na URL

Scenario:  PUT /cobr/{txid} - deve criar cobrança recorrente com payload completo
  Objetivo: Validar a criação de cobrança recorrente com todos os campos permitidos.
  Precondição: Deve existir um idRec ativo e válido vinculado ao recebedor.

  Given que possuo um txid válido e único
  And possuo um token válido com scope permitido
  When envio a requisição PUT com payload completo
    """
    curl -X PUT "https://pix.example.com/api/cobr/3136957d93134f2184b369e8f1c0729d" \
      -H "Authorization: Bearer token_valido" \
      -H "Content-Type: application/json" \
      -d '{
        "idRec": "RR1234567820240115abcdefghijk",
        "infoAdicional": "Serviços de Streamming de Música e Filmes.",
        "calendario": {
          "dataDeVencimento": "2024-04-15"
        },
        "valor": {
          "original": "106.07"
        },
        "ajusteDiaUtil": true,
        "devedor": {
          "cep": "89256-140",
          "cidade": "Uberlândia",
          "email": "sebastiao.tavares@mail.com",
          "logradouro": "Alameda Franco 1056",
          "uf": "MG"
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
      "infoAdicional": "Serviços de Streamming de Música e Filmes.",
      "calendario": {
        "criacao": "2024-04-01",
        "dataDeVencimento": "2024-04-15"
      },
      "valor": {
        "original": "106.07"
      },
      "status": "CRIADA",
      "politicaRetentativa": "PERMITE_3R_7D",
      "ajusteDiaUtil": true,
      "devedor": {
        "cep": "89256-140",
        "cidade": "Uberlândia",
        "email": "sebastiao.tavares@mail.com",
        "logradouro": "Alameda Franco 1056",
        "uf": "MG"
      },
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
  And todos os campos enviados devem ser refletidos corretamente no response body

Scenario:  PUT /cobr/{txid} - deve criar cobrança com ajusteDiaUtil=true
  Objetivo: Validar criação de cobrança com ajuste de vencimento para dia útil habilitado.
  Precondição: Deve existir idRec ativo e txid válido.

  Given que possuo um payload válido com ajusteDiaUtil true
  When envio a requisição
    """
    curl -X PUT "https://pix.example.com/api/cobr/3136957d93134f2184b369e8f1c0729e" \
      -H "Authorization: Bearer token_valido" \
      -H "Content-Type: application/json" \
      -d '{
        "idRec": "RR1234567820240115abcdefghijk",
        "calendario": {
          "dataDeVencimento": "2024-04-15"
        },
        "valor": {
          "original": "106.07"
        },
        "ajusteDiaUtil": true,
        "recebedor": {
          "agencia": "9708",
          "conta": "012682",
          "tipoConta": "CORRENTE"
        }
      }'
    """
  Then a API deve retornar status code 201
  And o response deve respeitar o JSON schema
  And o response body deve conter ajusteDiaUtil true
    """
    {
      "idRec": "RR1234567820240115abcdefghijk",
      "txid": "3136957d93134f2184b369e8f1c0729e",
      "calendario": {
        "criacao": "2024-04-01",
        "dataDeVencimento": "2024-04-15"
      },
      "valor": {
        "original": "106.07"
      },
      "status": "CRIADA",
      "ajusteDiaUtil": true
    }
    """

Scenario:  PUT /cobr/{txid} - deve criar cobrança com ajusteDiaUtil=false
  Objetivo: Validar criação de cobrança com ajuste de vencimento para dia útil desabilitado.
  Precondição: Deve existir idRec ativo e txid válido.

  Given que possuo um payload válido com ajusteDiaUtil false
  When envio a requisição
    """
    curl -X PUT "https://pix.example.com/api/cobr/3136957d93134f2184b369e8f1c0729f" \
      -H "Authorization: Bearer token_valido" \
      -H "Content-Type: application/json" \
      -d '{
        "idRec": "RR1234567820240115abcdefghijk",
        "calendario": {
          "dataDeVencimento": "2024-04-15"
        },
        "valor": {
          "original": "106.07"
        },
        "ajusteDiaUtil": false,
        "recebedor": {
          "agencia": "9708",
          "conta": "012682",
          "tipoConta": "CORRENTE"
        }
      }'
    """
  Then a API deve retornar status code 201
  And o response deve respeitar o JSON schema
  And o response body deve conter ajusteDiaUtil false
    """
    {
      "idRec": "RR1234567820240115abcdefghijk",
      "txid": "3136957d93134f2184b369e8f1c0729f",
      "status": "CRIADA",
      "ajusteDiaUtil": false
    }
    """

Scenario:  PUT /cobr/{txid} - deve aceitar dataDeVencimento igual à data atual
  Objetivo: Validar criação de cobrança com vencimento igual à data de criação.
  Precondição: A data atual do sistema deve ser 2024-04-01.

  Given que possuo um payload com dataDeVencimento igual à data atual
  When envio a requisição
    """
    curl -X PUT "https://pix.example.com/api/cobr/3136957d93134f2184b369e8f1c07300" \
      -H "Authorization: Bearer token_valido" \
      -H "Content-Type: application/json" \
      -d '{
        "idRec": "RR1234567820240115abcdefghijk",
        "calendario": {
          "dataDeVencimento": "2024-04-01"
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
  And o response deve respeitar o JSON schema
  And o response body deve conter dataDeVencimento igual a "2024-04-01"
    """
    {
      "txid": "3136957d93134f2184b369e8f1c07300",
      "calendario": {
        "criacao": "2024-04-01",
        "dataDeVencimento": "2024-04-01"
      },
      "status": "CRIADA"
    }
    """

Scenario:  PUT /cobr/{txid} - deve aceitar valor mínimo permitido
  Objetivo: Validar criação de cobrança com o menor valor permitido.
  Precondição: Deve existir idRec ativo e txid válido.

  Given que possuo um payload com valor original mínimo permitido
  When envio a requisição
    """
    curl -X PUT "https://pix.example.com/api/cobr/3136957d93134f2184b369e8f1c07301" \
      -H "Authorization: Bearer token_valido" \
      -H "Content-Type: application/json" \
      -d '{
        "idRec": "RR1234567820240115abcdefghijk",
        "calendario": {
          "dataDeVencimento": "2024-04-15"
        },
        "valor": {
          "original": "0.01"
        },
        "recebedor": {
          "agencia": "9708",
          "conta": "012682",
          "tipoConta": "CORRENTE"
        }
      }'
    """
  Then a API deve retornar status code 201
  And o response deve respeitar o JSON schema
  And o response body deve conter valor.original igual a "0.01"
    """
    {
      "txid": "3136957d93134f2184b369e8f1c07301",
      "valor": {
        "original": "0.01"
      },
      "status": "CRIADA"
    }
    """

Scenario:  PUT /cobr/{txid} - deve aceitar valor máximo permitido
  Objetivo: Validar criação de cobrança com o maior valor permitido.
  Precondição: Deve existir idRec ativo e txid válido.

  Given que possuo um payload com valor original máximo permitido
  When envio a requisição
    """
    curl -X PUT "https://pix.example.com/api/cobr/3136957d93134f2184b369e8f1c07302" \
      -H "Authorization: Bearer token_valido" \
      -H "Content-Type: application/json" \
      -d '{
        "idRec": "RR1234567820240115abcdefghijk",
        "calendario": {
          "dataDeVencimento": "2024-04-15"
        },
        "valor": {
          "original": "999999999.99"
        },
        "recebedor": {
          "agencia": "9708",
          "conta": "012682",
          "tipoConta": "CORRENTE"
        }
      }'
    """
  Then a API deve retornar status code 201
  And o response deve respeitar o JSON schema
  And o response body deve conter valor.original igual a "999999999.99"
    """
    {
      "txid": "3136957d93134f2184b369e8f1c07302",
      "valor": {
        "original": "999999999.99"
      },
      "status": "CRIADA"
    }
    """

Scenario:  PUT /cobr/{txid} - deve rejeitar txid inválido
  Objetivo: Validar rejeição quando o txid possuir formato inválido.
  Precondição: Deve existir idRec ativo.

  Given que possuo um txid com formato inválido
  When envio a requisição
    """
    curl -X PUT "https://pix.example.com/api/cobr/txid-invalido-@@" \
      -H "Authorization: Bearer token_valido" \
      -H "Content-Type: application/json" \
      -d '{
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
  And o response body deve informar txid inválido
    """
    {
      "codigo": "TXID_INVALIDO",
      "mensagem": "O txid informado possui formato inválido."
    }
    """

Scenario:  PUT /cobr/{txid} - deve rejeitar txid vazio
  Objetivo: Validar rejeição quando o txid não for informado na rota.
  Precondição: Deve existir payload válido.

  Given que não informo o txid na URL
  When envio a requisição
    """
    curl -X PUT "https://pix.example.com/api/cobr/" \
      -H "Authorization: Bearer token_valido" \
      -H "Content-Type: application/json" \
      -d '{
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
  Then a API deve retornar status code 404
  And o response deve respeitar o JSON schema de erro
  And o response body deve informar rota ou recurso não encontrado
    """
    {
      "codigo": "RECURSO_NAO_ENCONTRADO",
      "mensagem": "Recurso não encontrado."
    }
    """

Scenario:  PUT /cobr/{txid} - deve rejeitar txid já utilizado
  Objetivo: Validar rejeição para txid já associado a outra cobrança.
  Precondição: O txid informado já deve estar utilizado por outra cobrança.

  Given que possuo um txid já utilizado
  When envio a requisição
    """
    curl -X PUT "https://pix.example.com/api/cobr/3136957d93134f2184b369e8f1c0729d" \
      -H "Authorization: Bearer token_valido" \
      -H "Content-Type: application/json" \
      -d '{
        "idRec": "RR9999999920240115abcdefghijk",
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
  Then a API deve retornar status code 409
  And o response deve respeitar o JSON schema de erro
  And o response body deve informar conflito por txid já utilizado
    """
    {
      "codigo": "TXID_JA_UTILIZADO",
      "mensagem": "O txid informado já está associado a outra cobrança."
    }
    """

Scenario:  PUT /cobr/{txid} - deve rejeitar payload vazio
  Objetivo: Validar rejeição quando o body da requisição estiver vazio.
  Precondição: Deve existir txid válido.

  Given que possuo um body vazio
  When envio a requisição
    """
    curl -X PUT "https://pix.example.com/api/cobr/3136957d93134f2184b369e8f1c07303" \
      -H "Authorization: Bearer token_valido" \
      -H "Content-Type: application/json" \
      -d '{}'
    """
  Then a API deve retornar status code 400
  And o response deve respeitar o JSON schema de erro
  And o response body deve informar campos obrigatórios ausentes
    """
    {
      "codigo": "PAYLOAD_INVALIDO",
      "mensagem": "Payload inválido ou campos obrigatórios ausentes."
    }
    """

Scenario:  PUT /cobr/{txid} - deve rejeitar ausência de idRec
  Objetivo: Validar rejeição quando o campo idRec não for enviado.
  Precondição: Deve existir txid válido.

  Given que possuo um payload sem idRec
  When envio a requisição
    """
    curl -X PUT "https://pix.example.com/api/cobr/3136957d93134f2184b369e8f1c07304" \
      -H "Authorization: Bearer token_valido" \
      -H "Content-Type: application/json" \
      -d '{
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
  And o response body deve informar obrigatoriedade do idRec
    """
    {
      "codigo": "IDREC_OBRIGATORIO",
      "mensagem": "O campo idRec é obrigatório."
    }
    """

Scenario:  PUT /cobr/{txid} - deve rejeitar idRec nulo
  Objetivo: Validar rejeição quando idRec for nulo.
  Precondição: Deve existir txid válido.

  Given que possuo um payload com idRec nulo
  When envio a requisição
    """
    curl -X PUT "https://pix.example.com/api/cobr/3136957d93134f2184b369e8f1c07305" \
      -H "Authorization: Bearer token_valido" \
      -H "Content-Type: application/json" \
      -d '{
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
  And o response body deve informar idRec inválido
    """
    {
      "codigo": "IDREC_INVALIDO",
      "mensagem": "O campo idRec não pode ser nulo."
    }
    """

Scenario:  PUT /cobr/{txid} - deve rejeitar idRec vazio
  Objetivo: Validar rejeição quando idRec for vazio.
  Precondição: Deve existir txid válido.

  Given que possuo um payload com idRec vazio
  When envio a requisição
    """
    curl -X PUT "https://pix.example.com/api/cobr/3136957d93134f2184b369e8f1c07306" \
      -H "Authorization: Bearer token_valido" \
      -H "Content-Type: application/json" \
      -d '{
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
  And o response body deve informar idRec vazio
    """
    {
      "codigo": "IDREC_INVALIDO",
      "mensagem": "O campo idRec não pode ser vazio."
    }
    """

Scenario:  PUT /cobr/{txid} - deve rejeitar idRec inexistente
  Objetivo: Validar rejeição quando idRec não existir.
  Precondição: O idRec informado não deve existir na base.

  Given que possuo um idRec inexistente
  When envio a requisição
    """
    curl -X PUT "https://pix.example.com/api/cobr/3136957d93134f2184b369e8f1c07307" \
      -H "Authorization: Bearer token_valido" \
      -H "Content-Type: application/json" \
      -d '{
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
  And o response deve respeitar o JSON schema de erro
  And o response body deve informar idRec inexistente
    """
    {
      "codigo": "IDREC_NAO_ENCONTRADO",
      "mensagem": "O idRec informado não foi encontrado."
    }
    """

Scenario:  PUT /cobr/{txid} - deve rejeitar idRec cancelado
  Objetivo: Validar rejeição quando idRec estiver cancelado.
  Precondição: O idRec informado deve existir com status cancelado.

  Given que possuo um idRec cancelado
  When envio a requisição
    """
    curl -X PUT "https://pix.example.com/api/cobr/3136957d93134f2184b369e8f1c07308" \
      -H "Authorization: Bearer token_valido" \
      -H "Content-Type: application/json" \
      -d '{
        "idRec": "RR7777777720240115canceladoabc",
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
  Then a API deve retornar status code 422
  And o response deve respeitar o JSON schema de erro
  And o response body deve informar que o idRec está cancelado
    """
    {
      "codigo": "IDREC_CANCELADO",
      "mensagem": "Não é permitido criar cobrança para idRec cancelado."
    }
    """

Scenario:  PUT /cobr/{txid} - deve rejeitar calendário ausente
  Objetivo: Validar rejeição quando o objeto calendario não for enviado.
  Precondição: Deve existir idRec ativo e txid válido.

  Given que possuo um payload sem calendario
  When envio a requisição
    """
    curl -X PUT "https://pix.example.com/api/cobr/3136957d93134f2184b369e8f1c07309" \
      -H "Authorization: Bearer token_valido" \
      -H "Content-Type: application/json" \
      -d '{
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
  And o response body deve informar calendario obrigatório
    """
    {
      "codigo": "CALENDARIO_OBRIGATORIO",
      "mensagem": "O objeto calendario é obrigatório."
    }
    """

Scenario:  PUT /cobr/{txid} - deve rejeitar calendário inválido
  Objetivo: Validar rejeição quando calendario possuir estrutura inválida.
  Precondição: Deve existir idRec ativo e txid válido.

  Given que possuo um payload com calendario inválido
  When envio a requisição
    """
    curl -X PUT "https://pix.example.com/api/cobr/3136957d93134f2184b369e8f1c07310" \
      -H "Authorization: Bearer token_valido" \
      -H "Content-Type: application/json" \
      -d '{
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
  And o response body deve informar calendario inválido
    """
    {
      "codigo": "CALENDARIO_INVALIDO",
      "mensagem": "O objeto calendario possui formato inválido."
    }
    """

Scenario:  PUT /cobr/{txid} - deve rejeitar dataDeVencimento inválida
  Objetivo: Validar rejeição quando dataDeVencimento possuir formato inválido.
  Precondição: Deve existir idRec ativo e txid válido.

  Given que possuo dataDeVencimento inválida
  When envio a requisição
    """
    curl -X PUT "https://pix.example.com/api/cobr/3136957d93134f2184b369e8f1c07311" \
      -H "Authorization: Bearer token_valido" \
      -H "Content-Type: application/json" \
      -d '{
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
  And o response body deve informar dataDeVencimento inválida
    """
    {
      "codigo": "DATA_VENCIMENTO_INVALIDA",
      "mensagem": "A dataDeVencimento deve estar no formato yyyy-MM-dd."
    }
    """

Scenario:  PUT /cobr/{txid} - deve rejeitar dataDeVencimento anterior à criação
  Objetivo: Validar rejeição quando vencimento for anterior à data de criação.
  Precondição: A data atual do sistema deve ser 2024-04-01.

  Given que possuo dataDeVencimento anterior à data atual
  When envio a requisição
    """
    curl -X PUT "https://pix.example.com/api/cobr/3136957d93134f2184b369e8f1c07312" \
      -H "Authorization: Bearer token_valido" \
      -H "Content-Type: application/json" \
      -d '{
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
  Then a API deve retornar status code 422
  And o response deve respeitar o JSON schema de erro
  And o response body deve informar vencimento anterior à criação
    """
    {
      "codigo": "DATA_VENCIMENTO_ANTERIOR_CRIACAO",
      "mensagem": "A dataDeVencimento não pode ser anterior à data de criação."
    }
    """

Scenario:  PUT /cobr/{txid} - deve rejeitar valor ausente
  Objetivo: Validar rejeição quando o objeto valor não for enviado.
  Precondição: Deve existir idRec ativo e txid válido.

  Given que possuo um payload sem valor
  When envio a requisição
    """
    curl -X PUT "https://pix.example.com/api/cobr/3136957d93134f2184b369e8f1c07313" \
      -H "Authorization: Bearer token_valido" \
      -H "Content-Type: application/json" \
      -d '{
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
  And o response body deve informar valor obrigatório
    """
    {
      "codigo": "VALOR_OBRIGATORIO",
      "mensagem": "O objeto valor é obrigatório."
    }
    """

Scenario:  PUT /cobr/{txid} - deve rejeitar objeto valor inválido
  Objetivo: Validar rejeição quando valor possuir estrutura inválida.
  Precondição: Deve existir idRec ativo e txid válido.

  Given que possuo objeto valor inválido
  When envio a requisição
    """
    curl -X PUT "https://pix.example.com/api/cobr/3136957d93134f2184b369e8f1c07314" \
      -H "Authorization: Bearer token_valido" \
      -H "Content-Type: application/json" \
      -d '{
        "idRec": "RR1234567820240115abcdefghijk",
        "calendario": {
          "dataDeVencimento": "2024-04-15"
        },
        "valor": "106.07",
        "recebedor": {
          "agencia": "9708",
          "conta": "012682",
          "tipoConta": "CORRENTE"
        }
      }'
    """
  Then a API deve retornar status code 400
  And o response deve respeitar o JSON schema de erro
  And o response body deve informar objeto valor inválido
    """
    {
      "codigo": "VALOR_INVALIDO",
      "mensagem": "O objeto valor possui formato inválido."
    }
    """

Scenario:  PUT /cobr/{txid} - deve rejeitar valor igual a zero
  Objetivo: Validar rejeição quando valor.original for zero.
  Precondição: Deve existir idRec ativo e txid válido.

  Given que possuo valor original igual a zero
  When envio a requisição
    """
    curl -X PUT "https://pix.example.com/api/cobr/3136957d93134f2184b369e8f1c07315" \
      -H "Authorization: Bearer token_valido" \
      -H "Content-Type: application/json" \
      -d '{
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
  Then a API deve retornar status code 422
  And o response deve respeitar o JSON schema de erro
  And o response body deve informar valor não permitido
    """
    {
      "codigo": "VALOR_NAO_PERMITIDO",
      "mensagem": "O valor original deve ser maior que zero."
    }
    """

Scenario:  PUT /cobr/{txid} - deve rejeitar valor negativo
  Objetivo: Validar rejeição quando valor.original for negativo.
  Precondição: Deve existir idRec ativo e txid válido.

  Given que possuo valor original negativo
  When envio a requisição
    """
    curl -X PUT "https://pix.example.com/api/cobr/3136957d93134f2184b369e8f1c07316" \
      -H "Authorization: Bearer token_valido" \
      -H "Content-Type: application/json" \
      -d '{
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
  Then a API deve retornar status code 422
  And o response deve respeitar o JSON schema de erro
  And o response body deve informar valor negativo inválido
    """
    {
      "codigo": "VALOR_NAO_PERMITIDO",
      "mensagem": "O valor original deve ser maior que zero."
    }
    """

Scenario:  PUT /cobr/{txid} - deve rejeitar valor com formato inválido
  Objetivo: Validar rejeição quando valor.original possuir formato inválido.
  Precondição: Deve existir idRec ativo e txid válido.

  Given que possuo valor original com formato inválido
  When envio a requisição
    """
    curl -X PUT "https://pix.example.com/api/cobr/3136957d93134f2184b369e8f1c07317" \
      -H "Authorization: Bearer token_valido" \
      -H "Content-Type: application/json" \
      -d '{
        "idRec": "RR1234567820240115abcdefghijk",
        "calendario": {
          "dataDeVencimento": "2024-04-15"
        },
        "valor": {
          "original": "106,07"
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
  And o response body deve informar formato inválido do valor
    """
    {
      "codigo": "FORMATO_VALOR_INVALIDO",
      "mensagem": "O valor original deve ser informado como string decimal com ponto."
    }
    """

Scenario:  PUT /cobr/{txid} - deve rejeitar recebedor ausente
  Objetivo: Validar rejeição quando recebedor não for enviado.
  Precondição: Deve existir idRec ativo e txid válido.

  Given que possuo payload sem recebedor
  When envio a requisição
    """
    curl -X PUT "https://pix.example.com/api/cobr/3136957d93134f2184b369e8f1c07318" \
      -H "Authorization: Bearer token_valido" \
      -H "Content-Type: application/json" \
      -d '{
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
  And o response body deve informar recebedor obrigatório
    """
    {
      "codigo": "RECEBEDOR_OBRIGATORIO",
      "mensagem": "O objeto recebedor é obrigatório."
    }
    """

Scenario:  PUT /cobr/{txid} - deve rejeitar recebedor inválido
  Objetivo: Validar rejeição quando recebedor possuir estrutura inválida.
  Precondição: Deve existir idRec ativo e txid válido.

  Given que possuo recebedor inválido
  When envio a requisição
    """
    curl -X PUT "https://pix.example.com/api/cobr/3136957d93134f2184b369e8f1c07319" \
      -H "Authorization: Bearer token_valido" \
      -H "Content-Type: application/json" \
      -d '{
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
  And o response body deve informar recebedor inválido
    """
    {
      "codigo": "RECEBEDOR_INVALIDO",
      "mensagem": "Os dados do recebedor são inválidos."
    }
    """

Scenario:  PUT /cobr/{txid} - deve rejeitar conta não pertencente ao recebedor
  Objetivo: Validar rejeição quando a conta informada não pertence ao recebedor autorizado.
  Precondição: Deve existir idRec ativo e token válido.

  Given que possuo recebedor com conta não pertencente ao recebedor autenticado
  When envio a requisição
    """
    curl -X PUT "https://pix.example.com/api/cobr/3136957d93134f2184b369e8f1c07320" \
      -H "Authorization: Bearer token_valido" \
      -H "Content-Type: application/json" \
      -d '{
        "idRec": "RR1234567820240115abcdefghijk",
        "calendario": {
          "dataDeVencimento": "2024-04-15"
        },
        "valor": {
          "original": "106.07"
        },
        "recebedor": {
          "agencia": "0001",
          "conta": "999999",
          "tipoConta": "CORRENTE"
        }
      }'
    """
  Then a API deve retornar status code 403
  And o response deve respeitar o JSON schema de erro
  And o response body deve informar conta não autorizada
    """
    {
      "codigo": "CONTA_RECEBEDOR_NAO_AUTORIZADA",
      "mensagem": "A conta informada não pertence ao recebedor autorizado."
    }
    """

Scenario:  PUT /cobr/{txid} - deve rejeitar tipoConta inválido
  Objetivo: Validar rejeição quando tipoConta possuir valor não permitido.
  Precondição: Deve existir idRec ativo e txid válido.

  Given que possuo tipoConta inválido
  When envio a requisição
    """
    curl -X PUT "https://pix.example.com/api/cobr/3136957d93134f2184b369e8f1c07321" \
      -H "Authorization: Bearer token_valido" \
      -H "Content-Type: application/json" \
      -d '{
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
          "tipoConta": "INVALIDA"
        }
      }'
    """
  Then a API deve retornar status code 400
  And o response deve respeitar o JSON schema de erro
  And o response body deve informar tipoConta inválido
    """
    {
      "codigo": "TIPO_CONTA_INVALIDO",
      "mensagem": "O tipoConta informado é inválido."
    }
    """

Scenario:  PUT /cobr/{txid} - deve rejeitar devedor inválido
  Objetivo: Validar rejeição quando devedor possuir dados inválidos.
  Precondição: Deve existir idRec ativo e txid válido.

  Given que possuo devedor com email inválido
  When envio a requisição
    """
    curl -X PUT "https://pix.example.com/api/cobr/3136957d93134f2184b369e8f1c07322" \
      -H "Authorization: Bearer token_valido" \
      -H "Content-Type: application/json" \
      -d '{
        "idRec": "RR1234567820240115abcdefghijk",
        "calendario": {
          "dataDeVencimento": "2024-04-15"
        },
        "valor": {
          "original": "106.07"
        },
        "devedor": {
          "cep": "89256-140",
          "cidade": "Uberlândia",
          "email": "email-invalido",
          "logradouro": "Alameda Franco 1056",
          "uf": "MG"
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
  And o response body deve informar devedor inválido
    """
    {
      "codigo": "DEVEDOR_INVALIDO",
      "mensagem": "Os dados do devedor são inválidos."
    }
    """

Scenario:  PUT /cobr/{txid} - deve aceitar ausência do devedor
  Objetivo: Validar criação de cobrança sem o objeto devedor.
  Precondição: Deve existir idRec ativo e txid válido.

  Given que possuo payload válido sem devedor
  When envio a requisição
    """
    curl -X PUT "https://pix.example.com/api/cobr/3136957d93134f2184b369e8f1c07323" \
      -H "Authorization: Bearer token_valido" \
      -H "Content-Type: application/json" \
      -d '{
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
  And o response deve respeitar o JSON schema
  And o response body não deve conter o objeto devedor
    """
    {
      "txid": "3136957d93134f2184b369e8f1c07323",
      "status": "CRIADA",
      "valor": {
        "original": "106.07"
      }
    }
    """

Scenario:  PUT /cobr/{txid} - deve aceitar infoAdicional ausente
  Objetivo: Validar criação de cobrança sem infoAdicional.
  Precondição: Deve existir idRec ativo e txid válido.

  Given que possuo payload válido sem infoAdicional
  When envio a requisição
    """
    curl -X PUT "https://pix.example.com/api/cobr/3136957d93134f2184b369e8f1c07324" \
      -H "Authorization: Bearer token_valido" \
      -H "Content-Type: application/json" \
      -d '{
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
  And o response deve respeitar o JSON schema
  And o response body não deve conter infoAdicional
    """
    {
      "txid": "3136957d93134f2184b369e8f1c07324",
      "status": "CRIADA"
    }
    """

Scenario:  PUT /cobr/{txid} - deve aceitar infoAdicional com tamanho mínimo
  Objetivo: Validar criação com infoAdicional no tamanho mínimo.
  Precondição: Deve existir idRec ativo e txid válido.

  Given que possuo infoAdicional com tamanho mínimo
  When envio a requisição
    """
    curl -X PUT "https://pix.example.com/api/cobr/3136957d93134f2184b369e8f1c07325" \
      -H "Authorization: Bearer token_valido" \
      -H "Content-Type: application/json" \
      -d '{
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
  And o response deve respeitar o JSON schema
  And o response body deve conter infoAdicional igual a "A"
    """
    {
      "txid": "3136957d93134f2184b369e8f1c07325",
      "infoAdicional": "A",
      "status": "CRIADA"
    }
    """

Scenario:  PUT /cobr/{txid} - deve aceitar infoAdicional com tamanho máximo
  Objetivo: Validar criação com infoAdicional no tamanho máximo permitido.
  Precondição: Deve existir idRec ativo e txid válido.

  Given que possuo infoAdicional com tamanho máximo permitido
  When envio a requisição
    """
    curl -X PUT "https://pix.example.com/api/cobr/3136957d93134f2184b369e8f1c07326" \
      -H "Authorization: Bearer token_valido" \
      -H "Content-Type: application/json" \
      -d '{
        "idRec": "RR1234567820240115abcdefghijk",
        "infoAdicional": "Texto com quantidade máxima permitida pela regra de negócio para informações adicionais da cobrança recorrente.",
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
  And o response deve respeitar o JSON schema
  And o response body deve conter a mesma infoAdicional enviada
    """
    {
      "txid": "3136957d93134f2184b369e8f1c07326",
      "infoAdicional": "Texto com quantidade máxima permitida pela regra de negócio para informações adicionais da cobrança recorrente.",
      "status": "CRIADA"
    }
    """

Scenario:  PUT /cobr/{txid} - deve rejeitar infoAdicional acima do limite
  Objetivo: Validar rejeição quando infoAdicional ultrapassar o limite permitido.
  Precondição: Deve existir idRec ativo e txid válido.

  Given que possuo infoAdicional acima do limite permitido
  When envio a requisição
    """
    curl -X PUT "https://pix.example.com/api/cobr/3136957d93134f2184b369e8f1c07327" \
      -H "Authorization: Bearer token_valido" \
      -H "Content-Type: application/json" \
      -d '{
        "idRec": "RR1234567820240115abcdefghijk",
        "infoAdicional": "Texto acima do limite máximo permitido pela API para o campo infoAdicional da cobrança recorrente, excedendo a quantidade de caracteres configurada na regra de negócio.",
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
  And o response body deve informar limite excedido
    """
    {
      "codigo": "INFO_ADICIONAL_TAMANHO_INVALIDO",
      "mensagem": "O campo infoAdicional excede o tamanho máximo permitido."
    }
    """

Scenario:  PUT /cobr/{txid} - deve rejeitar status inválido
  Objetivo: Validar rejeição quando o cliente tentar enviar status manualmente com valor inválido.
  Precondição: Deve existir idRec ativo e txid válido.

  Given que possuo payload com status inválido
  When envio a requisição
    """
    curl -X PUT "https://pix.example.com/api/cobr/3136957d93134f2184b369e8f1c07328" \
      -H "Authorization: Bearer token_valido" \
      -H "Content-Type: application/json" \
      -d '{
        "idRec": "RR1234567820240115abcdefghijk",
        "status": "INVALIDO",
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
  And o response body deve informar status inválido
    """
    {
      "codigo": "STATUS_INVALIDO",
      "mensagem": "O campo status não pode ser informado ou possui valor inválido."
    }
    """

Scenario:  PUT /cobr/{txid} - deve rejeitar cobrança duplicada para mesmo ciclo
  Objetivo: Validar rejeição quando já existir cobrança para o mesmo idRec e ciclo.
  Precondição: Deve existir cobrança criada para o mesmo idRec e dataDeVencimento.

  Given que já existe cobrança para o mesmo ciclo
  When envio nova requisição para outro txid com mesmo idRec e vencimento
    """
    curl -X PUT "https://pix.example.com/api/cobr/3136957d93134f2184b369e8f1c07329" \
      -H "Authorization: Bearer token_valido" \
      -H "Content-Type: application/json" \
      -d '{
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
  Then a API deve retornar status code 409
  And o response deve respeitar o JSON schema de erro
  And o response body deve informar cobrança duplicada para o ciclo
    """
    {
      "codigo": "COBRANCA_DUPLICADA_CICLO",
      "mensagem": "Já existe cobrança para o mesmo idRec e ciclo informado."
    }
    """

Scenario:  PUT /cobr/{txid} - deve ser idempotente para mesmo payload
  Objetivo: Validar idempotência ao repetir a mesma criação com o mesmo txid e payload.
  Precondição: A cobrança já deve ter sido criada anteriormente com o mesmo txid e payload.

  Given que possuo uma cobrança criada com o mesmo txid e payload
  When envio novamente a mesma requisição
    """
    curl -X PUT "https://pix.example.com/api/cobr/3136957d93134f2184b369e8f1c0729d" \
      -H "Authorization: Bearer token_valido" \
      -H "Content-Type: application/json" \
      -d '{
        "idRec": "RR1234567820240115abcdefghijk",
        "infoAdicional": "Serviços de Streamming de Música e Filmes.",
        "calendario": {
          "dataDeVencimento": "2024-04-15"
        },
        "valor": {
          "original": "106.07"
        },
        "ajusteDiaUtil": true,
        "devedor": {
          "cep": "89256-140",
          "cidade": "Uberlândia",
          "email": "sebastiao.tavares@mail.com",
          "logradouro": "Alameda Franco 1056",
          "uf": "MG"
        },
        "recebedor": {
          "agencia": "9708",
          "conta": "012682",
          "tipoConta": "CORRENTE"
        }
      }'
    """
  Then a API deve retornar status code 200
  And o response deve respeitar o JSON schema de cobrança recorrente
  And o response body deve retornar a cobrança previamente criada sem duplicar registros
    """
    {
      "idRec": "RR1234567820240115abcdefghijk",
      "txid": "3136957d93134f2184b369e8f1c0729d",
      "status": "CRIADA",
      "valor": {
        "original": "106.07"
      },
      "calendario": {
        "criacao": "2024-04-01",
        "dataDeVencimento": "2024-04-15"
      }
    }
    """

Scenario:  PUT /cobr/{txid} - deve rejeitar token expirado
  Objetivo: Validar rejeição quando o token de autenticação estiver expirado.
  Precondição: Deve existir txid e payload válidos.

  Given que possuo token expirado
  When envio a requisição
    """
    curl -X PUT "https://pix.example.com/api/cobr/3136957d93134f2184b369e8f1c07330" \
      -H "Authorization: Bearer token_expirado" \
      -H "Content-Type: application/json" \
      -d '{
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
  Then a API deve retornar status code 401
  And o response deve respeitar o JSON schema de erro
  And o response body deve informar token expirado
    """
    {
      "codigo": "TOKEN_EXPIRADO",
      "mensagem": "Token de autenticação expirado."
    }
    """

Scenario:  PUT /cobr/{txid} - deve rejeitar ausência de token
  Objetivo: Validar rejeição quando o header Authorization não for enviado.
  Precondição: Deve existir txid e payload válidos.

  Given que não informo token de autenticação
  When envio a requisição
    """
    curl -X PUT "https://pix.example.com/api/cobr/3136957d93134f2184b369e8f1c07331" \
      -H "Content-Type: application/json" \
      -d '{
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
  Then a API deve retornar status code 401
  And o response deve respeitar o JSON schema de erro
  And o response body deve informar ausência de autenticação
    """
    {
      "codigo": "NAO_AUTENTICADO",
      "mensagem": "Token de autenticação não informado."
    }
    """

Scenario:  PUT /cobr/{txid} - deve rejeitar scope inválido
  Objetivo: Validar rejeição quando o token não possuir scope necessário para criar cobrança.
  Precondição: Deve existir txid e payload válidos.

  Given que possuo token válido sem scope permitido
  When envio a requisição
    """
    curl -X PUT "https://pix.example.com/api/cobr/3136957d93134f2184b369e8f1c07332" \
      -H "Authorization: Bearer token_scope_invalido" \
      -H "Content-Type: application/json" \
      -d '{
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
  Then a API deve retornar status code 403
  And o response deve respeitar o JSON schema de erro
  And o response body deve informar scope inválido
    """
    {
      "codigo": "SCOPE_INVALIDO",
      "mensagem": "O token não possui permissão para executar esta operação."
    }
    """

Scenario:  PUT /cobr/{txid} - deve retornar serviço indisponível
  Objetivo: Validar comportamento da API quando houver indisponibilidade temporária do serviço.
  Precondição: O serviço de criação de cobrança ou dependência interna deve estar indisponível.

  Given que o serviço de cobrança está indisponível
  When envio uma requisição válida
    """
    curl -X PUT "https://pix.example.com/api/cobr/3136957d93134f2184b369e8f1c07333" \
      -H "Authorization: Bearer token_valido" \
      -H "Content-Type: application/json" \
      -d '{
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
  Then a API deve retornar status code 503
  And o response deve respeitar o JSON schema de erro
  And o response body deve informar indisponibilidade temporária
    """
    {
      "codigo": "SERVICO_INDISPONIVEL",
      "mensagem": "Serviço temporariamente indisponível."
    }
    """
