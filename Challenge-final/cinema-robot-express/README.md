# Mark85 Robot Framework - Testes Automatizados

## 📋 Descrição

Testes automatizados para a aplicação Mark85 utilizando Robot Framework com Selenium para automação de interface web.

## ⚙️ Configuração Inicial

### Arquivos de Configuração Necessários

#### 1. Configuração do Banco de Dados
O arquivo `resources/libs/database.py` contém a string de conexão MongoDB. **Ajuste conforme necessário:**

```python
# Em resources/libs/database.py, linha 4:
client = MongoClient('mongodb+srv://SEU_USUARIO:SUA_SENHA@cluster0.d8iw87s.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0')
```

#### 2. Variáveis de Ambiente
O arquivo `resources/env.resource` define as configurações do ambiente:

```robot
# Em resources/env.resource:
${BASE_URL}     http://localhost:3000
${BROWSER}      chromium
```

#### 3. Dados de Teste
Os dados de teste ficam em `resources/fixtures/` no formato JSON:

```json
{
  "signup": {
    "name": "Teste User",
    "email": "teste@example.com",
    "password": "123456"
  }
}
```

### ⚠️ Importante
- Certifique-se que a **API Mark85** está rodando em `http://localhost:3333`
- Certifique-se que a **Web Mark85** está rodando em `http://localhost:3000`
- Verifique as **credenciais do MongoDB** no arquivo `database.py`
- Confirme que o **cluster MongoDB** está ativo e acessível
- Execute `rfbrowser init` após instalar robotframework-browser

## 🚀 Executar Testes

### Pré-requisitos
```bash
pip install robotframework
pip install robotframework-browser
pip install robotframework-jsonlibrary
pip install robotframework-faker
pip install pymongo
pip install bcrypt

# Inicializar Playwright
rfbrowser init
```

### Comandos de Execução

#### Executar todos os testes
```bash
robot -d ./logs tests/
```

#### Executar um teste específico
```bash
robot -d ./logs tests/signup.robot
```

#### Executar testes por tag
```bash
# Executar todos os testes com uma tag específica
robot -d ./logs -i <tag> tests/

# Exemplos práticos:
robot -d ./logs -i dup tests/
robot -d ./logs -i dup tests/signup.robot
```

#### Outros comandos úteis
```bash
# Executar excluindo uma tag
robot -d ./logs -e <tag> tests/

# Executar com variáveis customizadas
robot -d ./logs -v BROWSER:chrome tests/

# Executar com nível de log específico
robot -d ./logs --loglevel DEBUG tests/
```

## 📁 Estrutura do Projeto

```
mark85-robot-express/
├── tests/                    # Casos de teste
│   ├── signup.robot         # Testes de cadastro
│   └── online.robot         # Testes de funcionalidades
├── resources/               # Keywords e configurações
│   ├── base.resource        # Configurações base
│   ├── env.resource         # Variáveis de ambiente
│   ├── libs/                # Bibliotecas Python
│   │   └── database.py      # Conexão MongoDB
│   ├── pages/               # Page Objects
│   │   ├── components/      # Componentes reutilizáveis
│   │   ├── SignupPage.resource
│   │   ├── LoginPage.resource
│   │   └── TasksPage.resource
│   └── fixtures/            # Dados de teste
├── logs/                    # Relatórios de execução
└── README.md                # Este arquivo
```

## 📊 Relatórios

Após a execução, os relatórios são gerados em `./logs/`:
- `report.html` - Relatório visual dos testes
- `log.html` - Log detalhado da execução
- `output.xml` - Dados estruturados dos resultados

## 🏷️ Tags Disponíveis

- `dup` - Testes de duplicação/validação
- `smoke` - Testes de fumaça
- `regression` - Testes de regressão

---

**Sprint 07 - Programa PB Compass** 🧭