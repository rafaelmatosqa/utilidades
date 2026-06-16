Feature:  PATCH /cobr/{txid} - Cancelamento de cobrança recorrente

Scenario:  PATCH /cobr/{txid} - deve cancelar cobrança recorrente
  Objetivo: Validar o cancelamento de uma cobrança recorrente ativa por meio do envio do status CANCELADA.

  Precondição:
    Dado que exista uma cobrança recorrente ativa para o txid informado
    E o usuário recebedor esteja autorizado para realizar o cancelamento

  Given que possuo uma cobrança recorrente elegível para cancelamento
  And possuo um token válido com scope adequado
  When envio uma requisição PATCH para cancelamento da cobrança
    """
    curl --location --request PATCH 'https://pix.example.com/api/cobr/517bd858b59d458a841280b0f0a60bfa' \
    --header 'Authorization: Bearer {{token}}' \
    --header 'Content-Type: application/json' \
    --data '{
      "status": "CANCELADA"
    }'
    """
  Then a API deve retornar status code 200
  And o response deve respeitar o JSON schema de cancelamento de cobrança recorrente
  And o response body deve refletir o cancelamento da cobrança
    """
    {
      "idRec": "RN985156112024071999000566354",
      "txid": "517bd858b59d458a841280b0f0a60bfa",
      "calendario": {
        "criacao": "2024-05-20",
        "dataDeVencimento": "2024-06-20"
      },
      "valor": {
        "original": "210.00"
      },
      "status": "CANCELADA",
      "politicaRetentativa": "NAO_PERMITE",
      "ajusteDiaUtil": true,
      "devedor": {
        "cep": "26901-340",
        "cidade": "São Luís",
        "email": "fulano.tal@mail.com",
        "logradouro": "Alameda Cardoso 1007",
        "uf": "MA"
      },
      "recebedor": {
        "cnpj": "31166575201770",
        "conta": "107262",
        "nome": "Empresa de Telecomunicações SA",
        "tipoConta": "POUPANÇA"
      },
      "tentativas": [
        {
          "dataLiquidacao": "2024-06-20",
          "tipo": "AGND",
          "endToEndId": "E12345678202406201221abcdef12345",
          "status": "CANCELADA"
        }
      ],
      "encerramento": {
        "cancelamento": {
          "solicitante": "USUARIO_RECEBEDOR",
          "codigo": "SLCR",
          "descricao": "Cancelamento de agendamento solicitado pelo usuário recebedor"
        }
      },
      "atualizacao": [
        {
          "data": "2024-05-20T14:47:29.470Z",
          "status": "CRIADA"
        },
        {
          "data": "2024-05-21T10:18:20.120Z",
          "status": "ATIVA"
        },
        {
          "data": "2024-05-26T10:18:20.120Z",
          "status": "CANCELADA"
        }
      ]
    }
    """
  And o campo status deve ser igual a "CANCELADA"
  And o histórico de atualização deve conter o status "CANCELADA"
  And o encerramento deve indicar cancelamento solicitado pelo recebedor
  And a tentativa de liquidação deve possuir status "CANCELADA"


Scenario:  PATCH /cobr/{txid} - deve rejeitar status diferente de CANCELADA
  Objetivo: Validar que a API rejeita solicitações de atualização com status diferente de CANCELADA.

  Precondição:
    Dado que exista uma cobrança recorrente válida para o txid informado
    E o usuário possua autorização para a operação

  Given que possuo uma cobrança recorrente válida
  And possuo um payload com status diferente de CANCELADA
  When envio uma requisição PATCH para atualização da cobrança
    """
    curl --location --request PATCH 'https://pix.example.com/api/cobr/517bd858b59d458a841280b0f0a60bfa' \
    --header 'Authorization: Bearer {{token}}' \
    --header 'Content-Type: application/json' \
    --data '{
      "status": "ATIVA"
    }'
    """
  Then a API deve retornar status code 400
  And o response deve respeitar o JSON schema de erro
  And o response body deve indicar operação inválida
    """
    {
      "type": "https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
      "title": "Operação inválida.",
      "status": 400,
      "detail": "O status informado deve ser CANCELADA."
    }
    """
  And o campo status deve ser igual a 400
  And o campo detail deve informar que apenas CANCELADA é permitido


Scenario:  PATCH /cobr/{txid} - deve rejeitar cobrança inexistente
  Objetivo: Validar que a API rejeita o cancelamento quando o txid não corresponder a uma cobrança existente.

  Precondição:
    Dado que o txid informado não esteja associado a nenhuma cobrança recorrente

  Given que possuo um txid inexistente
  And possuo um token válido com scope adequado
  When envio uma requisição PATCH para cancelamento da cobrança
    """
    curl --location --request PATCH 'https://pix.example.com/api/cobr/99999999999999999999999999999999' \
    --header 'Authorization: Bearer {{token}}' \
    --header 'Content-Type: application/json' \
    --data '{
      "status": "CANCELADA"
    }'
    """
  Then a API deve retornar status code 404
  And o response deve respeitar o JSON schema de erro
  And o response body deve indicar que a cobrança não foi encontrada
    """
    {
      "type": "https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
      "title": "Operação inválida.",
      "status": 404,
      "detail": "A cobrança informada não foi encontrada."
    }
    """
  And o campo status deve ser igual a 404
  And o campo detail deve informar que a cobrança não existe

  Scenario:  PATCH /cobr/{txid} - deve rejeitar txid inválido
  Objetivo: Validar que a API rejeita a solicitação de cancelamento quando o txid informado possui formato inválido.

  Precondição:
    Dado que o usuário possua autorização para executar a operação de cancelamento
    E o txid informado não respeite o formato esperado pela API

  Given que possuo um txid inválido
  And possuo um token válido com scope adequado
  When envio uma requisição PATCH para cancelamento da cobrança
    """
    curl --location --request PATCH 'https://pix.example.com/api/cobr/txid_invalido@@' \
    --header 'Authorization: Bearer {{token}}' \
    --header 'Content-Type: application/json' \
    --data '{
      "status": "CANCELADA"
    }'
    """
  Then a API deve retornar status code 400
  And o response deve respeitar o JSON schema de erro
  And o response body deve indicar operação inválida
    """
    {
      "type": "https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
      "title": "Operação inválida.",
      "status": 400,
      "detail": "O txid informado não respeita o formato esperado."
    }
    """
  And o campo status deve ser igual a 400
  And o campo detail deve informar que o txid é inválido


Scenario:  PATCH /cobr/{txid} - deve retornar acesso negado
  Objetivo: Validar que a API rejeita a solicitação de cancelamento quando o usuário não possui credenciais válidas.

  Precondição:
    Dado que exista uma cobrança recorrente elegível para cancelamento
    E o token utilizado seja inválido, expirado ou inexistente

  Given que possuo uma cobrança recorrente válida
  And não possuo credenciais válidas para a operação
  When envio uma requisição PATCH para cancelamento da cobrança
    """
    curl --location --request PATCH 'https://pix.example.com/api/cobr/517bd858b59d458a841280b0f0a60bfa' \
    --header 'Authorization: Bearer {{token_invalido}}' \
    --header 'Content-Type: application/json' \
    --data '{
      "status": "CANCELADA"
    }'
    """
  Then a API deve retornar status code 401
  And o response deve respeitar o JSON schema de erro
  And o response body deve indicar acesso negado
    """
    {
      "type": "https://pix.bcb.gov.br/api/v2/error/CobROperacaoInvalida",
      "title": "Operação inválida.",
      "status": 401,
      "detail": "Acesso negado. Token inválido, expirado ou não informado."
    }
    """
  And o campo status deve ser igual a 401
  And o campo detail deve informar que o acesso foi negado
