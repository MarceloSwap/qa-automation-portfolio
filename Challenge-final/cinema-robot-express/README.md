# Cinema App Robot Framework - Testes E2E

## 📋 Descrição

Testes automatizados E2E para o Sistema de Cinema utilizando Robot Framework com Browser Library (Playwright) para automação de interface web.

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
- Certifique-se que a **API Cinema** está rodando em `http://localhost:3000`
- Certifique-se que o **Frontend Cinema** está rodando em `http://localhost:5173`
- Verifique as **credenciais do MongoDB** no arquivo `database.py` (se necessário)
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

#### Executar testes específicos
```bash
# Testes de autenticação
robot -d ./logs tests/login.robot
robot -d ./logs tests/register.robot
robot -d ./logs tests/profile.robot

# Testes de filmes
robot -d ./logs tests/movies.robot

# Testes de sessões e reservas
robot -d ./logs tests/sessions.robot
robot -d ./logs tests/reservations.robot

# Testes de navegação
robot -d ./logs tests/navigation.robot

# Scripts facilitadores
run_movies_tests.bat
run_reservations_tests.bat
run_navigation_tests.bat
```

#### Executar testes por tag
```bash
# Testes de filmes
robot -d ./logs -i movies tests/
robot -d ./logs -i movie-list tests/
robot -d ./logs -i movie-details tests/

# Testes de autenticação
robot -d ./logs -i login tests/
robot -d ./logs -i register tests/

# Testes por tipo
robot -d ./logs -i positive tests/
robot -d ./logs -i negative tests/
robot -d ./logs -i responsive tests/
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
cinema-robot-express/
├── tests/                    # Casos de teste
│   ├── login.robot          # Testes de login
│   ├── register.robot       # Testes de cadastro
│   ├── profile.robot        # Testes de perfil
│   ├── movies.robot         # Testes de filmes
│   └── online.robot         # Testes de conectividade
├── resources/               # Keywords e configurações
│   ├── base.resource        # Configurações base
│   ├── env.resource         # Variáveis de ambiente
│   ├── libs/                # Bibliotecas Python
│   │   └── database.py      # Conexão MongoDB
│   ├── pages/               # Page Objects
│   │   ├── components/      # Componentes reutilizáveis
│   │   ├── LoginPage.resource
│   │   ├── RegisterPage.resource
│   │   ├── ProfilePage.resource
│   │   ├── MoviesPage.resource
│   │   └── MovieDetailsPage.resource
│   └── fixtures/            # Dados de teste
│       └── movies.json      # Dados de filmes
├── logs/                    # Relatórios de execução
├── run_movies_tests.bat     # Script para testes de filmes
└── README.md                # Este arquivo
```

## 📊 Relatórios

Após a execução, os relatórios são gerados em `./logs/`:
- `report.html` - Relatório visual dos testes
- `log.html` - Log detalhado da execução
- `output.xml` - Dados estruturados dos resultados

## 🏷️ Tags Disponíveis

### Por Funcionalidade
- `movies` - Testes de filmes
- `movie-list` - Testes de lista de filmes
- `movie-details` - Testes de detalhes do filme
- `login` - Testes de login
- `register` - Testes de cadastro
- `profile` - Testes de perfil

### Por Tipo
- `positive` - Testes de casos de sucesso
- `negative` - Testes de casos de erro
- `responsive` - Testes de responsividade
- `performance` - Testes de performance

### Histórias de Usuário
- `US-MOVIE-001` - Navegar na Lista de Filmes
- `US-MOVIE-002` - Visualizar Detalhes do Filme
- `US-SESSION-001` - Visualizar Horários de Sessões
- `US-RESERVE-001` - Selecionar Assentos para Reserva
- `US-RESERVE-002` - Processo de Checkout
- `US-RESERVE-003` - Visualizar Minhas Reservas
- `US-NAV-001` - Navegação Intuitiva

## 🎯 Cobertura de Testes

### US-MOVIE-001: Navegar na Lista de Filmes
- ✅ Layout em grid responsivo
- ✅ Pôsteres de alta qualidade
- ✅ Informações nos cards (título, classificação, gêneros, duração, data)
- ✅ Adaptação para diferentes tamanhos de tela
- ✅ Navegação para detalhes do filme

### US-MOVIE-002: Visualizar Detalhes do Filme
- ✅ Informações detalhadas (sinopse, diretor, elenco, duração)
- ✅ Pôster do filme
- ✅ Horários de sessões disponíveis
- ✅ Navegação para reserva
- ✅ Volta para lista de filmes

### US-SESSION-001: Visualizar Horários de Sessões
- ✅ Horários disponíveis para filme selecionado
- ✅ Data, hora, teatro e disponibilidade
- ✅ Navegação para seleção de assentos

### US-RESERVE-001/002/003: Processo de Reservas
- ✅ Layout de assentos do teatro
- ✅ Codificação por cores (disponível/ocupado)
- ✅ Seleção de múltiplos assentos
- ✅ Processo de checkout completo
- ✅ Métodos de pagamento
- ✅ Visualização de minhas reservas

### US-NAV-001: Navegação Intuitiva
- ✅ Cabeçalho presente em todas as páginas
- ✅ Menu responsivo (desktop/mobile)
- ✅ Seções personalizadas para usuário logado
- ✅ Breadcrumbs e elementos de navegação
- ✅ Feedback visual da página atual
- ✅ Acessibilidade via teclado

---

**Challenge Final - Programa PB Compass** 🧭