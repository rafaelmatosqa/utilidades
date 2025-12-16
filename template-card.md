# 🧪 [QA][Automação] Componente <NOME_DO_COMPONENTE>

---

## 🎯 Objetivo

Criar automação de testes de API para o componente **<NOME_DO_COMPONENTE>**, seguindo
os padrões corporativos de qualidade, com integração completa ao **Jira Zephyr Scale**
e **GitLab CI/CD**, garantindo execução automática em **DEV** e **UAT**.

---

## 📦 Escopo da Automação

- Testes de contrato (obrigatório)
- Testes funcionais críticos (mínimo definido)
- Execução automática em DEV
- Execução automática em UAT
- Integração via trigger com pipeline do componente principal

---

## 🧩 Arquitetura / Padrões Técnicos

- Framework: RestAssured + TestNG + Lombok
- Builder Pattern + Data Factory
- Configuração por arquivo YML (DEV / UAT)
- Projeto de automação desacoplado do backend
- Integração com Zephyr Scale

---

## 📌 Critérios de Aceite (TODOS OBRIGATÓRIOS)

### 🔧 Setup Técnico
- [ ] Projeto de automação criado a partir do template oficial
- [ ] Estrutura de pacotes conforme padrão do time
- [ ] Configuração por YML funcionando (DEV / UAT)
- [ ] Builders implementados com Lombok
- [ ] Data Factory criada e reutilizável

### 🔍 Testes
- [ ] Testes de contrato implementados
- [ ] Testes funcionais mínimos implementados
- [ ] Testes executando localmente sem falhas
- [ ] Testes independentes e idempotentes

### 🚀 CI/CD
- [ ] Pipeline do projeto de automação criada
- [ ] Trigger configurado na pipeline do backend
- [ ] Execução automática em DEV
- [ ] Execução automática em UAT
- [ ] Pipeline do backend falha se automação falhar

### 📊 Governança (Jira / Zephyr)
- [ ] Casos de teste cadastrados no Zephyr Scale
- [ ] Casos marcados como automatizados
- [ ] Casos vinculados a um ciclo de teste
- [ ] Execução refletida no Zephyr
- [ ] Evidência de execução anexada no card

---

## 🔗 Links Obrigatórios

- 📁 Repositório de automação:  
  `<URL_DO_REPOSITORIO>`

- 🚀 Pipeline automação:  
  `<URL_DA_PIPELINE_AUTOMACAO>`

- 🧩 Pipeline componente principal:  
  `<URL_PIPELINE_BACKEND>`

- 📊 Ciclo Zephyr:  
  `<URL_DO_CICLO_ZEPHYR>`

- ✅ Evidência execução DEV:  
  `<LINK_ALLURE_OU_LOG_DEV>`

- ✅ Evidência execução UAT:  
  `<LINK_ALLURE_OU_LOG_UAT>`

---

## 🧪 Escopo Mínimo de Testes (Obrigatório)

### 🔹 Testes de Contrato
- Status HTTP
- Schema de resposta
- Campos obrigatórios
- Tipos de dados
- Regras críticas (ex: enums, formatos)

### 🔹 Testes Funcionais (Smoke)
- Fluxo GET principal
- Fluxo POST principal
- Cenário de erro funcional relevante

---

## ⚠️ Observações / Riscos / Débitos

- Dependências externas:
  - <DESCREVER>
- Limitações conhecidas:
  - <DESCREVER>
- Riscos técnicos:
  - <DESCREVER>

---

## 🏁 Definição de Pronto (DoD)

Este card **somente pode ser movido para DONE** quando:

- Todos os critérios de aceite estiverem marcados
- Pipeline estiver verde
- Execuções DEV e UAT estiverem refletidas no Zephyr
- Links e evidências estiverem preenchidos

---