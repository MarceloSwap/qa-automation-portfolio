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

#### 2. URL da Aplicação
O arquivo `resources/base.robot` define a URL base. **Verifique se a aplicação está rodando:**

```robot
# Em resources/base.robot:
New Page        http://localhost:3000
```

#### 3. Variáveis de Ambiente (Opcional)
Crie um arquivo `.env` na raiz do projeto se necessário:

```env
# .env (exemplo)
MONGO_URI=mongodb+srv://usuario:senha@cluster.mongodb.net/markdb
APP_URL=http://localhost:3000
BROWSER=chromium
```

### ⚠️ Importante
- Certifique-se que a **API Mark85** está rodando em `http://localhost:3000`
- Verifique as **credenciais do MongoDB** no arquivo `database.py`
- Confirme que o **cluster MongoDB** está ativo e acessível

## 🚀 Executar Testes

### Pré-requisitos
```bash
pip install robotframework
pip install robotframework-browser
pip install robotframework-faker
pip install pymongo
pip install bcrypt
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
├── tests/              # Casos de teste
├── resources/          # Keywords e variáveis
├── logs/              # Relatórios de execução
└── README.md          # Este arquivo
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