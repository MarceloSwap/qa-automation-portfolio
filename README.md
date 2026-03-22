# QA Portfolio – Marcelo F. S.

> Portfólio de Quality Assurance desenvolvido durante o Programa de Bolsas Compass UOL.
> Cobre automação de testes API e E2E, planejamento de testes, documentação e infraestrutura em nuvem.

---

## 🧪 Habilidades Demonstradas

| Área | Tecnologias |
|------|-------------|
| **Automação API** | Robot Framework + RequestsLibrary |
| **Automação E2E** | Robot Framework + Browser Library (Playwright) |
| **Testes Manuais** | Postman, Jira, Confluence |
| **Linguagens** | Python (libs customizadas), Robot Framework DSL |
| **Banco de Dados** | MongoDB (validação direta via PyMongo) |
| **Infraestrutura** | AWS EC2, MongoDB Atlas |
| **Padrões** | Page Object Model, Keywords reutilizáveis, Data-Driven Testing |

---

## 📁 Estrutura do Repositório

```
pb-compass/
├── Challenge-final/                # ⭐ Projeto Principal – Sistema de Cinema
│   ├── cinema-challenge-back/      # API REST (Node.js + Express + MongoDB)
│   ├── cinema-challenge-front/     # Frontend (React)
│   ├── cinema-robot-api/           # Testes de API (Robot Framework)
│   └── cinema-robot-express/       # Testes E2E (Robot Framework + Playwright)
├── Documentos/
│   ├── Sprint_05/                  # Automação API – Reqres e ServeRest
│   ├── Sprint_06/                  # Testes em ambiente AWS EC2
│   ├── Sprint_07/                  # Aplicação Mark85 – E2E completo
│   └── Postman/                    # Collections e evidências de testes manuais
└── README.md
```

---

## ⭐ Challenge Final – Sistema de Cinema

Projeto completo de QA sobre uma aplicação de cinema com API REST e frontend React.
Inclui planejamento, automação de API, automação E2E e documentação.

> ⚠️ **Aplicação sob teste:** Este repositório contém **apenas os testes**.
> O backend e frontend testados são de terceiros:
> - [cinema-challenge-back](https://github.com/juniorschmitz/cinema-challenge-back)
> - [cinema-challenge-front](https://github.com/juniorschmitz/cinema-challenge-front)

- 📄 [Plano de Teste – Backend](https://marcelofs.atlassian.net/wiki/external/ZTUwN2UxYmUwMWJhNDUwNTlkZmYxNGIwNGJmMGU3MTI)
- 📄 [Plano de Teste – Frontend](https://marcelofs.atlassian.net/wiki/external/YmE5OGY3YjMzZmUwNGZkOGI1Y2QyZTMzYTQ2MTNiNWM)

### Resultados dos Testes E2E

| Módulo | Testes | Passou | Taxa |
|--------|--------|--------|------|
| Autenticação | 20 | 20 | 100% ✅ |
| Filmes | 7 | 7 | 100% ✅ |
| Navegação | 10 | 10 | 100% ✅ |
| Sistema Online | 8 | 8 | 100% ✅ |
| Home | 10 | 10 | 100% ✅ |
| Reservas | 32 | 11 | 34% ⚠️ |
| **Total** | **87** | **66** | **75.9%** |

> ⚠️ Reservas: funcionalidade de seleção de assentos e checkout não implementada no frontend.

### Cobertura de Testes de API

- ✅ Autenticação (registro, login, JWT, perfil)
- ✅ Filmes (CRUD admin, listagem pública, filtros)
- ✅ Usuários (gerenciamento admin, RBAC)
- ✅ Reservas (criação, validação de assentos, histórico)
- ✅ Integração (fluxos completos, controle de acesso)

### Como Executar

```bash
# 1. Clonar e subir a API
git clone https://github.com/juniorschmitz/cinema-challenge-back
cd cinema-challenge-back
npm install && npm run dev

# 2. Clonar e subir o Frontend
git clone https://github.com/juniorschmitz/cinema-challenge-front
cd cinema-challenge-front
npm install && npm run dev

# 3. Instalar dependências de teste
pip install robotframework robotframework-requests robotframework-browser robotframework-jsonlibrary robotframework-faker pymongo bcrypt
rfbrowser init

# 4. Rodar testes de API
cd Challenge-final/cinema-robot-api
robot -d ./logs tests/

# 5. Rodar testes E2E
cd Challenge-final/cinema-robot-express
robot -d ./logs tests/
```

---

## 📚 Sprints Anteriores

### Sprint 05 – Automação de API
- Testes automatizados das APIs [Reqres](https://reqres.in/) e [ServeRest](https://serverest.dev/)
- Keywords customizadas para Login, Usuários, Produtos e Carrinho
- Collections Postman com evidências

### Sprint 06 – Testes em Nuvem (AWS EC2)
- Execução de testes em instância EC2
- Configuração de ambiente remoto
- Plano de teste refinado com rastreabilidade no Jira

### Sprint 07 – Aplicação Mark85
- API REST + Frontend React (gerenciamento de tarefas)
- Testes E2E com Robot Framework + Browser Library
- Mapeamento de elementos HTML e estratégias de localização

---

## 🔗 Links

- [Documentação Postman](https://documenter.getpostman.com/view/26925285/2sB3BKFTZy)
- [API ServeRest](https://serverest.dev/)
- [API Reqres](https://reqres.in/)

---

*Desenvolvido durante o Programa de Bolsas Compass UOL – Trilha QA* 🧭
