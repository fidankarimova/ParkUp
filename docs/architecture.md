# ParkUp — Arxitektura

ParkUp parkinq yerlərinin axtarışı, rezervasiyası və ödənişi üçün mikroservis əsaslı platformadır.

## Ümumi baxış

```
            ┌──────────────┐
 Client ───▶│ api-gateway  │ :8080
            └──────┬───────┘
     ┌─────────────┼──────────────┬───────────────┐
     ▼             ▼              ▼               ▼
 user-service  parking-service  booking-service  payment-service
   :8081          :8082            :8083            :8084
     │             │  (PostGIS)     │  (Redis lock)   │
     └─────────────┴───────┬────────┴─────────────────┘
                           ▼
                     Kafka (events) ──▶ notification-service :8085
```

## Servislər

| Servis | Port | Məsuliyyət | Məlumat anbarı |
|---|---|---|---|
| **api-gateway** | 8080 | Vahid giriş nöqtəsi: routing, JWT yoxlaması, rate limiting, CORS | — (Redis: rate limit) |
| **user-service** | 8081 | Qeydiyyat, giriş, JWT tokenlər, istifadəçi profili, avtomobillər (nömrə nişanı) | `parkup_user` |
| **parking-service** | 8082 | Parkinq sahələri və yerləri, coğrafi axtarış ("yaxınlıqdakı parkinqlər"), tariflər, real-time doluluq | `parkup_parking` (PostGIS), Redis (doluluq keşi) |
| **booking-service** | 8083 | Rezervasiyanın yaradılması/ləğvi, vaxt slotlarının idarəsi, ikiqat rezervasiyanın qarşısının alınması | `parkup_booking`, Redis (distributed lock) |
| **payment-service** | 8084 | Ödənişin başlanması və təsdiqi, geri qaytarma, ödəniş provayderi inteqrasiyası | `parkup_payment` |
| **notification-service** | 8085 | Kafka hadisələrinə əsasən push / SMS / e-mail bildirişləri | — (stateless) |

## Prinsiplər

- **Database-per-service:** hər servisin öz DB-si var; başqa servisin cədvəlinə birbaşa müraciət qadağandır.
- **Sinxron:** servislər arası sorğular REST ilə, yalnız gateway üzərindən xaricə açılır.
- **Asinxron:** vəziyyət dəyişiklikləri Kafka hadisələri ilə paylanır.
- **Konfiqurasiya:** hər servis `application.yml`, mühitə görə dəyişənlər environment variable ilə.

## Kafka hadisələri (ilkin)

| Topic | Producer | Consumer(lər) |
|---|---|---|
| `user.registered` | user-service | notification-service |
| `booking.created` | booking-service | payment-service, parking-service, notification-service |
| `booking.cancelled` | booking-service | payment-service, parking-service, notification-service |
| `payment.completed` | payment-service | booking-service, notification-service |
| `payment.failed` | payment-service | booking-service, notification-service |
| `parking.occupancy-changed` | parking-service | — |

## Texnologiyalar

- Java 21, Spring Boot 4.1, Spring Cloud 2025.1 (Gateway Server WebMVC)
- Maven multi-module (ortaq versiyalar kök `pom.xml`-də)
- PostgreSQL 17 + PostGIS 3.5, Redis 7.4, Apache Kafka 4.1 (KRaft), Kafka UI (kafbat)

## Repo quruluşu

```
parkup/
├── services/   # hər mikroservis ayrıca Maven modulu
├── infra/      # docker-compose və lokal infrastruktur
├── docs/       # arxitektura və digər sənədlər
└── pom.xml     # parent POM
```
