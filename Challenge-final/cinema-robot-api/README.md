# Cinema API - Testes Automatizados com Robot Framework

## 📋 Descrição

Testes automatizados para a API do Sistema de Cinema utilizando Robot Framework com RequestsLibrary. Os testes cobrem todas as histórias de usuário e funcionalidades da API, incluindo autenticação, gerenciamento de filmes, usuários e reservas.

## 🎯 Cobertura de Testes

### Papéis de Usuário Testados
- **Visitante**: Usuário não autenticado
- **Usuário**: Usuário regular autenticado  
- **Administrador**: Usuário com privilégios administrativos

### Histórias de Usuário Cobertas

#### 🔐 Autenticação (US-AUTH-001 a US-AUTH-004)
- ✅ **US-AUTH-001**: Registro de Usuário
- ✅ **US-AUTH-002**: Login de Usuário
- ✅ **US-AUTH-003**: Logout de Usuário (validação de token)
- ✅ **US-AUTH-004**: Visualizar e Gerenciar Perfil do Usuário

#### 🎬 Gerenciamento de Filmes (US-MOVIE-001, US-MOVIE-002, US-HOME-001)
- ✅ **US-HOME-001**: Página Inicial Atrativa (API Info)
- ✅ **US-MOVIE-001**: Navegar na Lista de Filmes
- ✅ **US-MOVIE-002**: Visualizar Detalhes do Filme

#### 🎫 Reservas (US-RESERVE-001 a US-RESERVE-003)
- ✅ **US-RESERVE-001**: Selecionar Assentos para Reserva
- ✅ **US-RESERVE-002**: Processo de Checkout
- ✅ **US-RESERVE-003**: Visualizar Minhas Reservas

#### 🧭 Navegação (US-NAV-001)
- ✅ **US-NAV-001**: Navegação Intuitiva (endpoints da API)

## 🗂️ Estrutura do Projeto

```
cinema-robot-api/
├── tests/                           # Casos de teste
│   ├── auth_tests.robot            # Testes de autenticação
│   ├── movie_tests.robot           # Testes de filmes
│   ├── user_management_tests.robot # Testes de gerenciamento de usuários
│   ├── reservation_tests.robot     # Testes de reservas
│   └── api_integration_tests.robot # Testes de integração
├── resources/                       # Keywords e configurações
│   ├── base.resource               # Configurações base
│   ├── keywords/                   # Keywords customizadas
│   │   ├── auth_keywords.resource
│   │   ├── movie_keywords.resource
│   │   ├── user_keywords.resource
│   │   └── reservation_keywords.resource
│   └── fixtures/                   # Dados de teste
│       └── test_data.json
├── logs/                           # Relatórios de execução
└── README.md                       # Este arquivo
```

## ⚙️ Pré-requisitos

### Dependências Python
```bash
pip install robotframework
pip install robotframework-requests
pip install robotframework-jsonlibrary
pip install robotframework-faker
```

### API Cinema Backend
- A API deve estar rodando em `http://localhost:3000`
- MongoDB deve estar configurado e acessível
- Dados iniciais podem ser necessários (usar script de seed se disponível)

## 🚀 Como Executar os Testes

### Configuração Inicial
1. Certifique-se que a API está rodando:
```bash
cd ../cinema-challenge-back
npm install
npm run dev
```

2. Verifique se a API está respondendo:
```bash
curl http://localhost:3000/api/v1/
```

### Comandos de Execução

#### Executar todos os testes
```bash
robot -d ./logs tests/
```

#### Executar testes por arquivo
```bash
# Testes de autenticação
robot -d ./logs tests/auth_tests.robot

# Testes de filmes
robot -d ./logs tests/movie_tests.robot

# Testes de usuários (admin)
robot -d ./logs tests/user_management_tests.robot

# Testes de reservas
robot -d ./logs tests/reservation_tests.robot

# Testes de integração
robot -d ./logs tests/api_integration_tests.robot
```

#### Executar testes por tags
```bash
# Testes de autenticação
robot -d ./logs -i auth tests/

# Testes positivos
robot -d ./logs -i positive tests/

# Testes negativos
robot -d ./logs -i negative tests/

# Testes de admin
robot -d ./logs -i admin tests/

# Testes de integração
robot -d ./logs -i integration tests/

# Testes específicos por funcionalidade
robot -d ./logs -i register tests/        # Registro de usuários
robot -d ./logs -i login tests/           # Login
robot -d ./logs -i movies tests/          # Filmes
robot -d ./logs -i reservations tests/    # Reservas
robot -d ./logs -i rbac tests/            # Controle de acesso
```

#### Executar com diferentes níveis de log
```bash
# Log detalhado
robot -d ./logs --loglevel DEBUG tests/

# Log mínimo
robot -d ./logs --loglevel WARN tests/
```

#### Executar testes específicos
```bash
# Teste específico por nome
robot -d ./logs -t "Test User Registration With Valid Data" tests/

# Múltiplos testes
robot -d ./logs -t "Test*Registration*" tests/
```

## 📊 Tipos de Teste

### Testes Positivos
- Registro de usuário com dados válidos
- Login com credenciais corretas
- Criação de filmes (admin)
- Criação de reservas
- Atualização de perfil
- Listagem de recursos

### Testes Negativos
- Registro com email duplicado
- Login com credenciais inválidas
- Acesso sem autenticação
- Acesso sem permissões adequadas
- Dados inválidos ou malformados
- Recursos não encontrados

### Testes de Integração
- Fluxo completo do usuário
- Fluxo completo do admin
- Controle de acesso baseado em papéis
- Consistência de dados entre endpoints
- Paginação e filtros
- Tratamento de erros

### Testes de Segurança
- Validação de tokens JWT
- Controle de acesso por papel
- Validação de entrada
- Prevenção de acesso não autorizado

## 🏷️ Tags Disponíveis

### Por Funcionalidade
- `auth` - Testes de autenticação
- `movies` - Testes de filmes
- `users` - Testes de usuários
- `reservations` - Testes de reservas
- `integration` - Testes de integração

### Por Tipo
- `positive` - Testes de casos de sucesso
- `negative` - Testes de casos de erro
- `admin` - Testes que requerem privilégios admin
- `public` - Testes de endpoints públicos

### Por Operação
- `register` - Registro de usuários
- `login` - Login
- `profile` - Perfil do usuário
- `create` - Criação de recursos
- `update` - Atualização de recursos
- `delete` - Remoção de recursos
- `list` - Listagem de recursos

## 📈 Relatórios

Após a execução, os relatórios são gerados em `./logs/`:
- `report.html` - Relatório visual dos testes
- `log.html` - Log detalhado da execução
- `output.xml` - Dados estruturados dos resultados

### Métricas Importantes
- **Taxa de Sucesso**: Percentual de testes aprovados
- **Cobertura**: Todas as US e endpoints cobertos
- **Performance**: Tempo de resposta da API
- **Segurança**: Validação de autenticação e autorização

## 🔧 Configuração Avançada

### Variáveis de Ambiente
Você pode sobrescrever configurações via linha de comando:

```bash
# Alterar URL base da API
robot -d ./logs -v BASE_URL:http://localhost:8080/api/v1 tests/

# Alterar timeout
robot -d ./logs -v TIMEOUT:60 tests/

# Usar dados de teste específicos
robot -d ./logs -v VALID_EMAIL:test@example.com tests/
```

### Execução Paralela
Para executar testes em paralelo (requer pabot):

```bash
pip install robotframework-pabot
pabot -d ./logs tests/
```

### Integração CI/CD
Exemplo para GitHub Actions:

```yaml
- name: Run API Tests
  run: |
    robot -d ./logs --outputdir ./test-results tests/
    
- name: Publish Test Results
  uses: actions/upload-artifact@v2
  with:
    name: robot-results
    path: ./test-results/
```

## 🐛 Troubleshooting

### Problemas Comuns

1. **API não está rodando**
   ```
   ConnectionError: HTTPConnectionPool
   ```
   - Verifique se a API está rodando em localhost:3000
   - Teste manualmente: `curl http://localhost:3000/api/v1/`

2. **Banco de dados não configurado**
   ```
   500 Internal Server Error
   ```
   - Verifique configuração do MongoDB
   - Execute seed de dados se necessário

3. **Testes falhando por dados**
   ```
   Token não disponível / ID não disponível
   ```
   - Alguns testes dependem de dados criados em testes anteriores
   - Execute suítes completas ao invés de testes isolados

4. **Timeout nos testes**
   ```
   RequestException: timeout
   ```
   - Aumente o timeout: `-v TIMEOUT:60`
   - Verifique performance da API

### Debug
Para debug detalhado:
```bash
robot -d ./logs --loglevel TRACE --debugfile debug.txt tests/
```

## 📚 Documentação Adicional

- [Robot Framework User Guide](https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html)
- [RequestsLibrary Documentation](https://marketsquare.github.io/robotframework-requests/doc/RequestsLibrary.html)
- [API Cinema Documentation](../cinema-challenge-back/README.md)

---

**Desenvolvido para o Challenge Final - Programa PB Compass** 🧭