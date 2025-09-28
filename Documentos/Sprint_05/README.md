# Sprint 05 - Automação de Testes API

## 📋 Descrição

Testes automatizados de APIs utilizando Robot Framework, cobrindo as APIs Reqres e ServeRest com diferentes cenários e validações.

## 🗂️ Projetos

### API Reqres
- **URL**: https://reqres.in/
- **Testes**: CRUD de usuários, login, recursos
- **Localização**: `Reqres/`

### API ServeRest
- **URL**: https://serverest.dev/
- **Testes**: Usuários, produtos, carrinho, login
- **Localização**: `ServeRest/`

### Exemplos e Estruturas
- **Tutoriais**: Exemplos básicos do Robot Framework
- **Variáveis**: Demonstração de escopos e argumentos
- **Localização**: `ExemplosEstruturas/`

## 🚀 Como Executar

### Pré-requisitos
```bash
pip install robotframework
pip install robotframework-requests
pip install robotframework-faker
```

### Executar Testes
```bash
# Todos os testes Reqres
robot -d reports Reqres/

# Todos os testes ServeRest
robot -d reports ServeRest/

# Teste específico
robot -d reports ServeRest/usuarios_tests.robot
```

## 📊 Relatórios

Os relatórios são gerados na pasta `reports/`:
- `report.html` - Relatório visual
- `log.html` - Log detalhado
- `output.xml` - Dados estruturados

---

**Sprint 05 - Programa PB Compass** 🧭

