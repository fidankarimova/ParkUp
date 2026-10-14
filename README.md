# ParkUp

A microservice platform for finding, reserving and paying for parking spots.
Details: [docs/architecture.md](docs/architecture.md)

## Requirements

- Java 21+
- Docker + Docker Compose

## Running locally

```bash
# 1. Infrastructure (PostgreSQL/PostGIS, Redis, Kafka, Kafka UI)
cd infra && cp -n .env.example .env && docker compose up -d && cd ..

# 2. Build
./mvnw clean verify

# 3. Run a service (e.g. parking-service)
./mvnw -pl services/parking-service spring-boot:run
```

| Component | Address |
|---|---|
| API Gateway | http://localhost:8080 |
| Kafka UI | http://localhost:8090 |
| PostgreSQL | localhost:5432 (`parkup` / `parkup`) |
| Redis | localhost:6379 |
| Kafka | localhost:9092 |

## Contributing

Branching strategy and commit rules: [CONTRIBUTING.md](CONTRIBUTING.md)
