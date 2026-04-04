# WeatherApp2

## Descrição
Aplicação de clima construída com Phoenix Framework.

## Pré-requisitos

- Elixir ~> 1.19.5
- Erlang/OTP ~> 25
- PostgreSQL >= 14
- Node.js >= 18

## Instalação local

```bash
# 1. Instalar dependências
mix deps.get

# 2. Configurar variáveis de ambiente
cp .env.example .env
# Editar .env com suas credenciais locais

# 3. Criar e migrar banco de dados
mix ecto.setup

# 4. Instalar assets (se aplicável)
cd assets && npm install && cd ..

# 5. Iniciar servidor
mix phx.server
```

Acesse: http://localhost:4000

## Variáveis de ambiente obrigatórias

| Variável | Descrição | Exemplo |
|---|---|---|
| `DATABASE_URL` | URL de conexão com o banco | `ecto://user:pass@host/db` |
| `SECRET_KEY_BASE` | Chave secreta Phoenix (64+ chars) | `mix phx.gen.secret` |
| `PHX_HOST` | Host público da aplicação | `myapp.gigalixirapp.com` |
| `PORT` | Porta HTTP (Gigalixir define automaticamente) | `4000` |

## Deploy no Gigalixir

```bash
# Autenticar
gigalixir login

# Criar app (primeira vez)
gigalixir create

# Configurar variáveis
gigalixir config:set DATABASE_URL=...
gigalixir config:set SECRET_KEY_BASE=$(mix phx.gen.secret)
gigalixir config:set PHX_HOST=<seu-app>.gigalixirapp.com

# Deploy
git push gigalixir main

# Rodar migrations em produção
gigalixir run mix ecto.migrate

# Ver logs
gigalixir logs
```

## Testes

```bash
mix test
```

## Healthcheck

`GET /health` — Retorna `200 OK` com status da aplicação.

## Endpoints

| Método | Path | Controller#Action | Descrição |
|--------|------|-------------------|-----------|
| GET | `/` | PageController#home | Página inicial |
| GET | `/measurements` | MeasurementController#index | Lista medições |
| POST | `/measurements` | MeasurementController#create | Cria medição |
| GET | `/measurements/:id` | MeasurementController#show | Mostra medição |
| PUT | `/measurements/:id` | MeasurementController#update | Atualiza medição |
| PATCH | `/measurements/:id` | MeasurementController#update | Atualiza medição |
| DELETE | `/measurements/:id` | MeasurementController#destroy | Deleta medição |
| POST | `/measurements/fetch` | MeasurementController#fetch_from_crawler | Busca do crawler |
| GET | `/daily_measurements` | DailyMeasurementController#index | Lista medições diárias |
| POST | `/daily_measurements` | DailyMeasurementController#create | Cria medição diária |
| GET | `/daily_measurements/:id` | DailyMeasurementController#show | Mostra medição diária |
| PUT | `/daily_measurements/:id` | DailyMeasurementController#update | Atualiza medição diária |
| PATCH | `/daily_measurements/:id` | DailyMeasurementController#update | Atualiza medição diária |
| DELETE | `/daily_measurements/:id` | DailyMeasurementController#destroy | Deleta medição diária |
| GET | `/health` | HealthController#index | Healthcheck da aplicação |
