# ParkUp

Parkinq yerlərinin axtarışı, rezervasiyası və ödənişi üçün mikroservis platforması.
Ətraflı: [docs/architecture.md](docs/architecture.md)

## Tələblər

- Java 21+
- Docker + Docker Compose

## Lokal işə salma

```bash
# 1. Infrastruktur (PostgreSQL/PostGIS, Redis, Kafka, Kafka UI)
cd infra && cp -n .env.example .env && docker compose up -d && cd ..

# 2. Build
./mvnw clean verify

# 3. Servisi işə sal (məs. parking-service)
./mvnw -pl services/parking-service spring-boot:run
```

| Komponent | Ünvan |
|---|---|
| API Gateway | http://localhost:8080 |
| Kafka UI | http://localhost:8090 |
| PostgreSQL | localhost:5432 (`parkup` / `parkup`) |
| Redis | localhost:6379 |
| Kafka | localhost:9092 |

## Töhfə

Branch strategiyası və commit qaydaları: [CONTRIBUTING.md](CONTRIBUTING.md)
