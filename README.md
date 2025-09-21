# Repositório PB – Compass

## 📋 Descrição

Este repositório centraliza todos os arquivos importantes produzidos ao longo das Sprints do programa PB Compass, incluindo planejamentos de testes, automações, documentações e entregas de qualidade.

## 🗂️ Estrutura do Projeto

```
pb-compass/
├── Documentos/
│   ├── AtividadesDiversas/          # Apresentações e documentos gerais
│   ├── MapasMentaisServeRest/       # Mapas mentais dos testes
│   ├── Postman/                    # Collections e documentação Postman
│   ├── Prints/                     # Screenshots dos testes
│   ├── Sprint_03/                  # Jira e Planos de Teste
│   ├── Sprint_05/                  # Automação Robot Framework - API
│   │   ├── Reqres/                 # Testes API Reqres
│   │   ├── ServeRest/              # Testes API ServeRest
│   │   └── ExemplosEstruturas/     # Exemplos e tutoriais
│   └── Sprint_06/                  # Testes Avançados
│       ├── Semana 01/              # Continuação API ServeRest
│       └── Semana 02/              # Testes com EC2
├── Sprint_07/
│   ├── QAx/
│   │   ├── apps/
│   │   │   └── mark85/             # Aplicação Mark85 (API + Web)
│   │   └── projects/
│   │       └── mark85-robot-express/ # Testes E2E Robot Framework
│   └── Semana_01/
│       └── Atividade-01/           # Mapeamento de Elementos HTML
├── .gitignore
└── README.md
```

## 🚀 Tecnologias Utilizadas

### Automação de Testes
- **Robot Framework** - Automação de testes API e Web
- **RequestsLibrary** - Testes de API REST
- **Browser Library** - Automação web com Playwright
- **SeleniumLibrary** - Automação web tradicional

### Desenvolvimento
- **Node.js + Express** - API REST
- **MongoDB** - Banco de dados NoSQL
- **React** - Interface web

### Ferramentas de Gestão
- **Postman** - Testes manuais e documentação
- **Jira** - Gestão de issues e planejamento
- **Confluence** - Documentação de planos de teste

### Infraestrutura
- **AWS EC2** - Hospedagem de aplicações
- **MongoDB Atlas** - Banco de dados na nuvem

## 📚 Conteúdo do Repositório

### 🧪 Testes Automatizados

#### Sprint 05 - Testes de API
- **API Reqres**: Testes automatizados da API https://reqres.in/
- **API ServeRest**: Testes automatizados da API https://serverest.dev/
- **Collections Postman**: Testes manuais e documentação

#### Sprint 06 - Testes Avançados
- **ServeRest EC2**: Testes em ambiente AWS
- **Keywords Customizadas**: Carrinho, Login, Produtos, Usuários

#### Sprint 07 - Aplicação Completa
- **Mark85 API**: API REST completa com autenticação
- **Mark85 Web**: Interface React para gerenciamento de tarefas
- **Testes E2E**: Automação completa com Robot Framework + Browser Library
- **Mapeamento HTML**: Estratégias de localização de elementos

### 📊 Documentação
- **Mapas Mentais**: Estratégias de teste visualizadas
- **Planos de Teste**: Documentação completa no Confluence
- **Screenshots**: Evidências dos testes executados
- **Relatórios**: Resultados das execuções
- **READMEs**: Instruções específicas por projeto

## 🔧 Como Executar os Testes

### Pré-requisitos Gerais
```bash
pip install robotframework
pip install robotframework-requests
pip install robotframework-browser
pip install pymongo
```

### Sprint 05 - Testes de API
```bash
# Testes Reqres
cd "Documentos/Sprint_05/Reqres"
robot -d reports tests/

# Testes ServeRest
cd "Documentos/Sprint_05/ServeRest"
robot -d reports *.robot
```

### Sprint 06 - Testes com EC2
```bash
cd "Documentos/Sprint_06/Semana 02/ServeRest"
# Ajustar IP no arquivo serveres_variaveis.robot
robot -d reports tests/
```

### Sprint 07 - Aplicação Mark85
```bash
# Iniciar API
cd "Sprint_07/QAx/apps/mark85/api"
npm install
npm run dev

# Iniciar Web (novo terminal)
cd "Sprint_07/QAx/apps/mark85/web"
npm install
npm start

# Executar Testes E2E (novo terminal)
cd "Sprint_07/QAx/projects/mark85-robot-express"
robot -d ./logs tests/
```

## 📖 Links Importantes

- **[Plano de Teste - Confluence](https://marcelofs.atlassian.net/wiki/external/MzQ4OTg3NGE1YzkzNDdhZGJjNTY4M2UxYjMxNzZkMjA)**
- **[Documentação Postman](https://documenter.getpostman.com/view/26925285/2sB3BKFTZy)**
- **[API ServeRest](https://serverest.dev/)**
- **[API Reqres](https://reqres.in/)**

## 📈 Métricas de Qualidade

### Cobertura de Testes
- ✅ **API Testing** - Reqres e ServeRest
- ✅ **E2E Testing** - Aplicação Mark85 completa
- ✅ **Cross-browser** - Chromium, Firefox, Safari
- ✅ **Ambientes** - Local, EC2, MongoDB Atlas

### Automação
- ✅ **Robot Framework** - API e Web
- ✅ **CI/CD Ready** - Estrutura preparada
- ✅ **Keywords Reutilizáveis** - Modularização
- ✅ **Relatórios Visuais** - HTML reports

### Documentação
- ✅ **READMEs Específicos** - Por projeto
- ✅ **Configurações** - Ambientes e dependências
- ✅ **Evidências** - Screenshots e logs
- ✅ **Planos de Teste** - Confluence integrado

## 👥 Contribuição

Este repositório faz parte do programa de estágio PB Compass e contém as entregas e evoluções das atividades de Quality Assurance.

---

**Desenvolvido durante o Programa PB Compass** 🧭