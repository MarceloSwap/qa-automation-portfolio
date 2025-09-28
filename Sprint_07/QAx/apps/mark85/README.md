# Mark85 - Aplicação Completa

## 📋 Descrição

Aplicação completa de gerenciamento de tarefas com API REST (Node.js + Express) e interface web (React), integrada com MongoDB Atlas.

## 🏗️ Arquitetura

```
mark85/
├── api/                    # Backend - API REST
│   ├── build/             # Código transpilado
│   ├── .env              # Variáveis de ambiente
│   └── package.json      # Dependências Node.js
└── web/                   # Frontend - React
    ├── src/              # Código fonte React
    ├── public/           # Arquivos estáticos
    └── package.json      # Dependências React
```

## ⚙️ Configuração

### 1. Configurar Banco de Dados

Ajuste o arquivo `.env` na pasta `api/`:

```env
MONGO_URI=mongodb+srv://usuario:senha@cluster.mongodb.net/markdb
PORT=3333
JWT_SECRET=your-secret-key
```

### 2. Instalar Dependências

```bash
# API
cd api/
npm install

# Web
cd ../web/
npm install
```

## 🚀 Executar Aplicação

### Iniciar API (Terminal 1)
```bash
cd api/
npm run dev
# API rodará em http://localhost:3333
```

### Iniciar Web (Terminal 2)
```bash
cd web/
npm start
# Web rodará em http://localhost:3000
```

## 🔗 Endpoints da API

### Autenticação
- `POST /users` - Criar usuário
- `POST /sessions` - Login

### Tarefas (Autenticado)
- `GET /tasks` - Listar tarefas
- `POST /tasks` - Criar tarefa
- `GET /tasks/:id` - Obter tarefa
- `DELETE /tasks/:id` - Remover tarefa
- `PUT /tasks/:id/done` - Marcar como concluída
- `PUT /tasks/:id/todo` - Marcar como pendente

## 🧪 Testes

Os testes E2E estão localizados em:
```
../projects/mark85-robot-express/
```

Consulte o README específico para instruções de execução dos testes.

## 🛠️ Tecnologias

### Backend
- **Node.js** - Runtime JavaScript
- **Express** - Framework web
- **MongoDB** - Banco de dados
- **Mongoose** - ODM para MongoDB
- **JWT** - Autenticação
- **Bcrypt** - Hash de senhas

### Frontend
- **React** - Biblioteca UI
- **Axios** - Cliente HTTP
- **React Router** - Roteamento
- **CSS Modules** - Estilização

---

**Sprint 07 - Programa PB Compass** 🧭