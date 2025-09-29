# 📋 Plano de Testes – API ServeRest (Challenge 03)

## 1. Apresentação
Este documento apresenta o planejamento de testes para a **API ServeRest**, visando garantir a qualidade das funcionalidades e o cumprimento das regras de negócio descritas nas User Stories.

## 2. Objetivo
Assegurar que a aplicação **API ServeRest** esteja funcionando conforme o esperado, explorando suas funcionalidades com base em heurísticas de qualidade e Users Stories.  
O foco está em **descobrir falhas ocultas, comportamentos inesperados e inconsistências** inclusive na documentação do Swagger.

## 3. Escopo dos Testes
Funcionalidades a serem testadas:
- CRUD de **Usuários**
- **Login** e autenticação
- CRUD de **Produtos**
- CRUD de **Carrinho**

## 4. Estratégia de Teste
- **Testes Manuais** → Documentados e executados no **QAlity (Jira)**.
- **Testes Automatizados** → Robot Framework + Requests Library.
- **Execução**:
  - 1ª rodada: testes manuais no QAlity.
  - 2ª rodada: automação com Robot Framework (rodando na EC2).
- **Controle de versão**: GitHub com branches `main`, `develop`, `feature/robot-tests`.
- **Critério de sucesso**:
  - Cobertura mínima: 80% endpoints.
  - 100% regras de negócio críticas validadas.

## 5. Técnicas de Teste Aplicadas
- **Caixa-Preta (Funcional)**
- **Particionamento de Equivalência**
- **Análise de Valor-Limite**
- **Testes Baseados em Risco**
- **Testes de Contrato** (Swagger/OpenAPI)

## 6. Riscos Identificados
- Falhas de validação (e-mail, senha, dados obrigatórios).
- Permissão inadequada (usuário comum criando produtos).
- Token Bearer inválido ou sem expiração correta.
- Exclusão de recursos vinculados (usuários/produtos com carrinho).

## 7. Cenários de Teste Planejados

| ID    | Cenário                                    | Pré-condição                  | Entrada                              | Resultado Esperado                              | Prioridade |
|-------|--------------------------------------------|-------------------------------|--------------------------------------|------------------------------------------------|------------|
| CT001 | Criar usuário válido                       | —                             | Nome, email, senha válida, adm=true  | 201 Created + ID gerado                         | Alta       |
| CT002 | Criar usuário com e-mail duplicado         | Usuário já cadastrado         | Mesmo email                          | 400 Bad Request – mensagem de erro              | Alta       |
| CT003 | Criar usuário com e-mail inválido          | —                             | Email sem `@` ou domínio inválido    | 400 Bad Request                                | Média      |
| CT004 | Criar usuário com provedor Gmail/Hotmail   | —                             | teste@gmail.com                      | 400 Bad Request                                | Média      |
| CT005 | Criar usuário com senha < 5 caracteres     | —                             | Senha "1234"                         | 400 Bad Request                                | Média      |
| CT008 | Excluir usuário com carrinho vinculado     | Usuário autenticado com carrinho | ID do usuário                      | 400 Bad Request – mensagem de bloqueio          | Alta       |
| CT009 | Login com credenciais válidas              | Usuário existente             | Email + senha correta                | 200 OK + Token válido (10min)                   | Alta       |
| CT010 | Login com senha incorreta                  | Usuário existente             | Email correto + senha errada         | 401 Unauthorized                               | Alta       |
| CT012 | Acessar rota protegida sem token           | —                             | GET /produtos sem token              | 401 Unauthorized                               | Alta       |
| CT013 | Criar produto válido (admin)               | Usuário autenticado admin=true | Nome único, preço, descrição, qtd    | 201 Created + ID gerado                         | Alta       |
| CT016 | Criar produto com usuário não admin        | Usuário autenticado admin=false | Dados válidos                      | 403 Forbidden                                  | Alta       |
| CT017 | Excluir produto vinculado a carrinho       | Produto em carrinho           | ID do produto                        | 400 Bad Request – mensagem explicativa          | Alta       |
| CT018 | Atualizar produto com ID inexistente       | —                             | PUT com ID inexistente               | 201 Created + novo produto                      | Média      |

> Todos os cenários foram importados para o **QAlity (Jira)** para rastreabilidade.

## 8. Matriz de Risco

| Risco                              | Probabilidade | Impacto | Nível  | Observação |
|-----------------------------------|---------------|---------|--------|------------|
| Criar usuário duplicado            | Alta          | Alta    | Crítico| Inconsistência no BD |
| Login com credenciais inválidas    | Baixa         | Alta    | Alto   | Quebra de segurança |
| Token não expirar corretamente     | Média         | Alta    | Alto   | Sessões indefinidas |
| Produto vinculado excluído         | Alta          | Alta    | Crítico| Carrinho inconsistente |

## 9. Cobertura de Testes
- **100% endpoints** mapeados no Swagger.  
- **90% regras de negócio críticas** cobertas.  
- **Meta**: cobertura mínima de 80% dos endpoints + 100% regras críticas.  

## 10. Testes Candidatos à Automação
Critérios: Alta criticidade, repetitivos, fácil validação via status code/JSON.

- **Usuários**: CT001, CT002, CT004, CT008  
- **Login**: CT009, CT010, CT012  
- **Produtos**: CT013, CT014, CT016, CT017  

> Implementação no **Robot Framework**, rodando em **EC2** (segundo servidor).  
> Relatórios gerados em `log.html` e `report.html`.

## 11. Integração com Git
- Repositório GitHub organizado com:
  - `main` → branch estável.  
  - `develop` → branch de evolução.  
  - `feature/robot-tests` → branch de automação.  
- **Commits diários** documentando evolução.  