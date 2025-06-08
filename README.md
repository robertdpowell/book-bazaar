# Book Bazaar - Microservices Architecture

![Architecture Status](https://img.shields.io/badge/Architecture-In%20Progress-yellow)
![Services](https://img.shields.io/badge/Services-3%2F8%20Complete-orange)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.2.4-brightgreen)
![Kafka](https://img.shields.io/badge/Kafka-Event%20Streaming-blue)

A **fictional online bookstore** demonstrating microservices fundamentals with Spring Boot, Apache Kafka, and event-driven architecture. This project explores service decomposition, synchronous/asynchronous communication, service discovery, and modern DevOps practices.

## 🎯 Project Vision

Book Bazaar showcases a complete microservices ecosystem for an online bookstore, featuring:
- **Event-driven architecture** with Apache Kafka
- **Service discovery** with Eureka
- **RESTful APIs** with planned OpenAPI 3.0 specs
- **Containerized deployment** with Docker
- **Observability** with Spring Boot Actuator

---

## 📊 Current Implementation Status

### ✅ **Implemented Services (3/8)**

| Service | Status | Port | Description | Key Features |
|---------|--------|------|-------------|--------------|
| **eureka-service** | ✅ Complete | 8761 | Service discovery registry | Spring Cloud Eureka, health monitoring |
| **catalog-service** | ✅ Complete | 8081 | Book catalog management | REST API, PostgreSQL, JPA, Eureka client |
| **order-service** | ✅ Complete | 8082 | Order processing & events | REST API, Kafka producer, event publishing |

### 🚧 **Planned Services (5/8)**

| Service | Status | Port | Description | Dependencies |
|---------|--------|------|-------------|--------------|
| **payment-service** | 📋 Planned | 8083 | Payment processing | Kafka consumer (order.placed) |
| **notification-service** | 📋 Planned | 8084 | Email/SMS notifications | Kafka consumer (order.placed, payment.completed) |
| **user-service** | 📋 Planned | 8085 | User management & auth | REST API, PostgreSQL, JWT |
| **api-gateway** | 📋 Planned | 8080 | Single entry point | Spring Cloud Gateway, routing |
| **config-service** | 📋 Planned | 8888 | Centralized configuration | Spring Cloud Config |

---

## 🏗️ System Architecture

### **Current Event Flow**
```
[Customer] → [Order Service] → [Kafka: order.placed] → [Future: Payment Service]
                ↓
          [Database Storage]
```

### **Planned Complete Flow**
```
[Customer] → [API Gateway] → [Catalog/Order/User Services]
                                    ↓
[Kafka Events] → [Payment Service] → [Notification Service]
```

### **Infrastructure Components**
- **🐘 PostgreSQL** - Persistent data storage
- **📨 Apache Kafka** - Event streaming platform  
- **🔍 Eureka Server** - Service discovery
- **🐳 Docker Compose** - Container orchestration

---

## 🚀 Quick Start

### **Prerequisites**
- Java 17+
- Maven 3.8+
- Docker & Docker Compose

### **1. Start Infrastructure**
```bash
# Start all services with Docker Compose
docker-compose up -d

# Verify services are running
docker-compose ps
```

### **2. Verify Service Health**
```bash
# Eureka Dashboard
open http://localhost:8761

# Catalog Service Health
curl http://localhost:8081/actuator/health

# Order Service Health  
curl http://localhost:8082/actuator/health
```

### **3. Test the APIs**

**Get Books from Catalog:**
```bash
curl http://localhost:8081/books
```

**Place an Order (triggers Kafka event):**
```bash
curl -X POST http://localhost:8082/orders \
  -H "Content-Type: application/json" \
  -d '{"bookId": "1", "quantity": 2}'
```

---

## 📁 Project Structure

```
book-bazaar/
├── 📋 custom_instructions.md    # Detailed architecture documentation
├── 🐳 docker-compose.yml       # Infrastructure setup
├── 🗄️ init.sql                 # Database initialization
├── 📊 workspace.dsl            # Structurizr architecture diagram
├── 📂 Services:
│   ├── ✅ eureka-service/       # Service discovery (COMPLETE)
│   ├── ✅ catalog-service/      # Book catalog (COMPLETE)  
│   ├── ✅ order-service/        # Order processing (COMPLETE)
│   ├── 🚧 payment-service/      # Payment processing (PLANNED)
│   ├── 🚧 notification-service/ # Notifications (PLANNED)
│   ├── 🚧 user-service/         # User management (PLANNED)
│   ├── 🚧 api-gateway/          # API routing (PLANNED)
│   └── 🚧 config-service/       # Configuration (PLANNED)
├── 📂 common/                   # Shared libraries (EMPTY)
├── 📂 config-repo/              # Config repository (EMPTY)
└── 📂 .openapi/                 # OpenAPI specs (PLANNED)
```

---

## 🔧 Implemented Features

### **Catalog Service**
- **REST Endpoints:**
  - `GET /books` - List all books
  - `GET /books/{id}` - Get book by ID
- **Database:** PostgreSQL with JPA/Hibernate
- **Sample Data:** 3 pre-loaded programming books

### **Order Service** 
- **REST Endpoints:**
  - `POST /orders` - Place new order
- **Event Publishing:** Kafka `order.placed` events
- **Integration:** Service discovery via Eureka

### **Event-Driven Architecture**
- **Kafka Topics:**
  - ✅ `order.placed` (implemented)
  - 📋 `payment.completed` (planned)
- **Event Flow:** Order → Kafka → Future payment processing

### **Infrastructure**
- **Service Discovery:** All services register with Eureka
- **Health Monitoring:** Spring Boot Actuator endpoints
- **Containerization:** Docker images and Docker Compose

---

## 🔄 Development Roadmap

### **Phase 1: Foundation** ✅
- [x] Infrastructure setup (Kafka, PostgreSQL, Eureka)
- [x] Service discovery implementation  
- [x] Basic microservices structure

### **Phase 2: Core Services** ✅
- [x] Catalog service with REST API
- [x] Order service with Kafka integration
- [x] Event-driven order placement

### **Phase 3: Business Logic** 🚧
- [ ] Payment service (Kafka consumer)
- [ ] Notification service (multi-consumer)
- [ ] User service with authentication
- [ ] Service-to-service communication

### **Phase 4: Gateway & Config** 📋
- [ ] API Gateway with routing
- [ ] Centralized configuration
- [ ] OpenAPI 3.0 specifications

### **Phase 5: Production Ready** 📋  
- [ ] Comprehensive testing strategy
- [ ] Observability (tracing, metrics)
- [ ] Security implementation
- [ ] CI/CD pipeline

---

## 🧪 Testing the Current Implementation

### **1. Verify Infrastructure**
```bash
# Check if all containers are running
docker-compose ps

# Expected output:
# eureka-service   Up   0.0.0.0:8761->8761/tcp
# catalog-service  Up   0.0.0.0:8081->8081/tcp  
# order-service    Up   0.0.0.0:8082->8082/tcp
# postgres         Up   0.0.0.0:5432->5432/tcp
# kafka            Up   0.0.0.0:9092->9092/tcp
```

### **2. Test Service Discovery**
Visit Eureka dashboard: http://localhost:8761
- Should show `catalog-service` and `order-service` registered

### **3. Test Catalog API**
```bash
# List all books
curl http://localhost:8081/books | jq

# Get specific book  
curl http://localhost:8081/books/1 | jq
```

### **4. Test Order Processing with Kafka**
```bash
# Place an order (watch logs for Kafka events)
curl -X POST http://localhost:8082/orders \
  -H "Content-Type: application/json" \
  -d '{"bookId": "1", "quantity": 3}'

# Check Docker logs to see Kafka event
docker logs order-service
```

---

## 🔍 Monitoring & Observability

### **Health Endpoints**
- Eureka: http://localhost:8761/actuator/health
- Catalog: http://localhost:8081/actuator/health  
- Order: http://localhost:8082/actuator/health

### **Service Information**
- Catalog Beans: http://localhost:8081/actuator/beans
- Order Metrics: http://localhost:8082/actuator/metrics

---

## 🐛 Troubleshooting

### **Services not registering with Eureka**
```bash
# Check service logs
docker logs catalog-service
docker logs order-service

# Verify Eureka is accessible
curl http://localhost:8761/actuator/health
```

### **Kafka connection issues**
```bash
# Check Kafka logs
docker logs kafka

# Verify Kafka topics (requires kafka-tools)
docker exec kafka kafka-topics.sh --list --bootstrap-server localhost:9092
```

### **Database connection problems**
```bash
# Check PostgreSQL logs
docker logs postgres

# Connect to database
docker exec -it postgres psql -U bookuser -d bookbazaar
```

---

## 📚 Next Steps

Based on your current progress, here are the recommended next steps:

### **Immediate (Next Sprint)**
1. **Implement Payment Service**
   - Create `payment-service` module
   - Add Kafka consumer for `order.placed` events
   - Implement payment simulation logic
   - Publish `payment.completed` events

2. **Add OpenAPI Specifications**
   - Define API specs for existing services
   - Generate API documentation
   - Set up Swagger UI

### **Short Term (2-3 Sprints)**
3. **Build Notification Service**
   - Multi-topic Kafka consumer
   - Email/SMS simulation
   - Logging and observability

4. **Implement User Service**
   - User registration and authentication
   - JWT token management
   - Password encryption

### **Medium Term (4-6 Sprints)**
5. **Add API Gateway**
   - Spring Cloud Gateway setup
   - Route configuration
   - Security and rate limiting

6. **Centralized Configuration**
   - Spring Cloud Config Server
   - Externalized properties
   - Environment-specific configs

---

## 🤝 Contributing

This is a learning project demonstrating microservices patterns. Key areas for expansion:

- **Testing:** Unit, integration, and contract tests
- **Security:** JWT authentication, OAuth2
- **Observability:** Distributed tracing, metrics collection
- **Deployment:** Kubernetes, Helm charts
- **CI/CD:** GitHub Actions, automated testing

---

## 📖 Additional Resources

- [Architecture Documentation](./custom_instructions.md) - Detailed technical specifications
- [Structurizr Diagram](./workspace.dsl) - Visual architecture representation
- [Docker Compose](./docker-compose.yml) - Infrastructure setup
- [Database Schema](./init.sql) - Initial data setup

---

**🎯 Current Milestone:** Successfully implemented core services with event-driven architecture. Ready to expand business logic with payment and notification services.
