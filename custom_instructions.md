# Book Bazaar Microservices Architecture (Spring Boot + Kafka + OpenAPI)

## 📖 Overview

**Book Bazaar** is a fictional online bookstore demonstrating microservice fundamentals. The system is designed to explore service decomposition, synchronous and asynchronous communication, observability, and modern DevOps practices.

---

## 🧩 1. Services Overview

Each service is autonomous, owns its data, and communicates via REST (OpenAPI 3.0) and Kafka events.

| Service             | Responsibility                              | Protocols             |
|---------------------|----------------------------------------------|------------------------|
| `catalog-service`   | Manage books metadata                        | REST (OpenAPI)         |
| `order-service`     | Handle book orders                           | REST + Kafka (produce) |
| `payment-service`   | Simulate payment processing                  | REST + Kafka (consume) |
| `notification-service` | Send order and payment notifications     | Kafka (consume)        |
| `user-service`      | Register and authenticate users              | REST (OpenAPI)         |
| `api-gateway`       | Single entry point for external clients      | REST Proxy             |
| `config-service`    | Centralized config (Spring Cloud Config)     | Spring Cloud Config    |
| `eureka-service`    | Service discovery                            | Spring Cloud Eureka    |
| `kafka-broker`      | Event stream backbone                        | Kafka Topics           |

---

*## 🏗️ 2. Project Structure & Setup

```
book-bazaar/
├── common/                  # Shared libraries (DTOs, utils)
├── catalog-service/
├── order-service/
├── payment-service/
├── notification-service/
├── user-service/
├── api-gateway/
├── config-service/
├── eureka-service/
├── docker-compose.yml      # Infra: Kafka, Zookeeper, Eureka, Config, etc.
├── .openapi/               # OpenAPI 3.0 YAMLs*

```

---

## 🔧 3. Development Chunks

Each of the following chunks is a self-contained milestone.

### Chunk 1: Bootstrap Infrastructure
- Spring Boot setup with Gradle/Maven
- Docker Compose stack with:
  - Kafka + Zookeeper
  - Eureka Discovery Service
  - Spring Cloud Config Server
  - PostgreSQL for persistent services
  - API Gateway

### Chunk 2: Define OpenAPI Specs (OpenAPI 3.0)
- Define YAML specs for `catalog-service`, `order-service`, `user-service`
- Use tools like [Swagger Editor](https://editor.swagger.io/) or Stoplight
- Generate server stubs via OpenAPI Generator

### Chunk 3: Build `catalog-service`
- Expose book search, list, and detail endpoints
- REST API generated from OpenAPI
- Connect to PostgreSQL
- Register with Eureka
- Externalize config via Config Server

### Chunk 4: Build `user-service`
- REST endpoints for user registration and login
- Password hashing + JWT (optionally)
- OpenAPI + PostgreSQL + Eureka + Config

### Chunk 5: Build `order-service` (Sync + Async)
- REST endpoint to place order
- Produces `order.placed` Kafka event
- Store order in DB
- OpenAPI + Kafka + PostgreSQL

### Chunk 6: Build `payment-service` (Async-First)
- Subscribes to `order.placed` topic
- Simulates payment processing
- Produces `payment.completed` Kafka event

### Chunk 7: Build `notification-service` (Event-Driven)
- Subscribes to `payment.completed` and `order.placed`
- Sends fake email/SMS notifications
- Logs for observability

### Chunk 8: Setup API Gateway
- Spring Cloud Gateway
- Routes external calls to REST services
- Central point for security and rate limiting

---

## 📡 4. Kafka Topics Design

| Topic Name         | Producer         | Consumers                |
|--------------------|------------------|--------------------------|
| `order.placed`     | order-service     | payment-service, notification-service |
| `payment.completed`| payment-service   | notification-service     |

---

## 🔍 5. Observability and Local Tooling

- Spring Boot Actuator on all services
- Zipkin for distributed tracing (Spring Cloud Sleuth)
- Centralized logs via Docker log aggregation (ELK or plain logs)
- Health endpoints and metrics exposed

---

## ✅ 6. Testing Strategy

| Layer          | Strategy                                    |
|----------------|---------------------------------------------|
| Unit Tests     | JUnit + Mockito                             |
| Integration    | Spring Boot Test + Testcontainers           |
| Contract Tests | Spring Cloud Contract + OpenAPI validators |
| Kafka Testing  | Embedded Kafka or Testcontainers Kafka      |

---

## 🚀 7. Dev Productivity

- Live reload with DevTools
- OpenAPI UI (Swagger UI or ReDoc for docs)
- Postman or Insomnia for API testing
- Preconfigured `Makefile` or shell scripts to run infra

---

## 🧱 8. Optional Enhancements (Future Work)

- CI/CD with GitHub Actions
- Kubernetes deployment via Helm
- Secrets management (Vault)
- Role-based access control with Keycloak
- GraphQL facade service (optional)

---