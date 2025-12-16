# ✅ Checklist de Code Review (MR) — Automação de Testes API

---

## 1️⃣ Objetivo e Rastreabilidade
- [ ] MR contém link do Card Jira (Débito Técnico do componente)
- [ ] MR descreve claramente o que foi automatizado
- [ ] MR informa o que ficou fora do escopo (se aplicável)
- [ ] Ambientes validados informados (DEV e/ou UAT)

---

## 2️⃣ Estrutura e Padrões do Projeto
- [ ] Estrutura de pacotes segue o padrão oficial do time  
      (`client`, `spec`, `factory`, `builders`, `tests`, `utils`)
- [ ] Configuração de ambiente feita via arquivo YML
- [ ] Não existe hardcode de baseUrl, credenciais ou certificados
- [ ] Nomes de classes e métodos seguem a convenção definida  
      (`should_<acao>_when_<condicao>`)

---

## 3️⃣ Qualidade dos Testes
- [ ] Testes independentes e idempotentes
- [ ] Não há dependência de ordem de execução
- [ ] Não existe uso de `Thread.sleep`
- [ ] Setup e teardown não deixam resíduos no ambiente
- [ ] Assertivas validam comportamento funcional
- [ ] Logs de request/response apenas em caso de falha

---

## 4️⃣ Testes de Contrato (Obrigatório)
- [ ] Pelo menos 1 teste de contrato por endpoint crítico
- [ ] Validação de status HTTP
- [ ] Validação de schema da resposta
- [ ] Validação de campos obrigatórios
- [ ] Validação de tipos de dados
- [ ] Cenários negativos relevantes cobertos  
      (400, 401, 403, 404, 422 conforme a API)

---

## 5️⃣ Testes Funcionais (Mínimo Obrigatório)
- [ ] Smoke test funcional implementado
- [ ] GET principal coberto (quando aplicável)
- [ ] POST principal coberto (quando aplicável)
- [ ] Pelo menos 1 cenário de erro funcional relevante
- [ ] Dados criados via Builder Pattern + Data Factory
- [ ] Não existem payloads duplicados ou “na mão”

---

## 6️⃣ Builders, Factory e Reuso
- [ ] Builders Lombok corretamente configurados
- [ ] Factory centraliza dados padrão e permite override
- [ ] RequestSpec e ResponseSpec reutilizáveis
- [ ] Headers, autenticação e baseUri centralizados
- [ ] Não há duplicação de lógica de requisição

---

## 7️⃣ Segurança e Conformidade
- [ ] Nenhum segredo versionado no repositório
- [ ] Tokens, senhas e certificados via variáveis de ambiente ou secrets
- [ ] Logs não expõem dados sensíveis (PII, tokens, credenciais)
- [ ] Headers sensíveis tratados corretamente (ex: `x-cert`)

---

## 8️⃣ CI/CD e Pipeline
- [ ] Pipeline do projeto de automação executa com sucesso
- [ ] Relatórios de execução gerados (Allure ou equivalente)
- [ ] Pipeline configurada para DEV
- [ ] Pipeline configurada para UAT
- [ ] Trigger configurado na pipeline do backend
- [ ] Falha na automação quebra a pipeline do backend

---

## 9️⃣ Integração com Zephyr Scale
- [ ] Casos de teste cadastrados no Zephyr Scale
- [ ] Casos marcados como automatizados
- [ ] Casos vinculados a um ciclo de teste
- [ ] Execução refletida automaticamente no Zephyr
- [ ] Evidência de execução disponível (link do ciclo ou job)

---

## 🔟 Documentação Mínima
- [ ] README do projeto atualizado
- [ ] Instruções para execução local
- [ ] Instruções para execução DEV e UAT
- [ ] Variáveis e perfis documentados
- [ ] Limitações conhecidas registradas