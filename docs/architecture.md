# ParkUp — Architecture

ParkUp is a microservice-based platform for finding, reserving and paying for parking spots.

## Overview

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

## Services

| Service | Port | Responsibility | Data store |
|---|---|---|---|
| **api-gateway** | 8080 | Single entry point: routing, JWT validation, rate limiting, CORS | — (Redis: rate limiting) |
| **user-service** | 8081 | Registration, login, JWT tokens, user profiles, vehicles (license plates) | `parkup_user` |
| **parking-service** | 8082 | Parking lots and spots, geo search ("parkings near me"), pricing, real-time occupancy | `parkup_parking` (PostGIS), Redis (occupancy cache) |
| **booking-service** | 8083 | Creating/cancelling reservations, time-slot management, preventing double booking | `parkup_booking`, Redis (distributed lock) |
| **payment-service** | 8084 | Payment initiation and confirmation, refunds, payment provider integration | `parkup_payment` |
| **notification-service** | 8085 | Push / SMS / e-mail notifications driven by Kafka events | — (stateless) |

## Principles

- **Database-per-service:** every service owns its database; direct access to another service's tables is forbidden.
- **Synchronous:** service-to-service calls use REST; only the gateway is exposed externally.
- **Asynchronous:** state changes are propagated via Kafka events.
- **Configuration:** each service has its own `application.yml`; environment-specific values come from environment variables.

## Kafka events (initial)

| Topic | Producer | Consumer(s) |
|---|---|---|
| `user.registered` | user-service | notification-service |
| `booking.created` | booking-service | payment-service, parking-service, notification-service |
| `booking.cancelled` | booking-service | payment-service, parking-service, notification-service |
| `payment.completed` | payment-service | booking-service, notification-service |
| `payment.failed` | payment-service | booking-service, notification-service |
| `parking.occupancy-changed` | parking-service | — |

## Tech stack

- Java 21, Spring Boot 4.1, Spring Cloud 2025.1 (Gateway Server WebMVC)
- Maven multi-module (shared versions in the root `pom.xml`)
- PostgreSQL 17 + PostGIS 3.5, Redis 7.4, Apache Kafka 4.1 (KRaft), Kafka UI (kafbat)

## Repository layout

```
parkup/
├── services/   # each microservice is a separate Maven module
├── infra/      # docker-compose and local infrastructure
├── docs/       # architecture and other documentation
└── pom.xml     # parent POM
```
