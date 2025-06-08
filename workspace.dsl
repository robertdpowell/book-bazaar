workspace "Book Bazaar" "Microservices architecture for an online bookstore demonstrating service decomposition, event-driven communication, and modern DevOps practices" {

    model {
        // External actors
        customer = person "Customer" "A user who browses and purchases books"
        admin = person "Admin" "System administrator who manages the platform"
        
        // Book Bazaar System
        bookBazaarSystem = softwareSystem "Book Bazaar" "Online bookstore platform built with microservices architecture" {
            
            // API Gateway - Single entry point
            apiGateway = container "API Gateway" "Central entry point for external clients, handles routing, security, and rate limiting" "Spring Cloud Gateway" "gateway"
            
            // Core Business Services
            catalogService = container "Catalog Service" "Manages books metadata, search, and inventory" "Spring Boot + PostgreSQL" "microservice"
            orderService = container "Order Service" "Handles book orders and order lifecycle" "Spring Boot + PostgreSQL + Kafka Producer" "microservice"
            paymentService = container "Payment Service" "Processes payments and payment validation" "Spring Boot + Kafka Consumer/Producer" "microservice"
            userService = container "User Service" "Manages user registration, authentication, and profiles" "Spring Boot + PostgreSQL" "microservice"
            notificationService = container "Notification Service" "Sends order and payment notifications via email/SMS" "Spring Boot + Kafka Consumer" "microservice"
            
            // Infrastructure Services
            eurekaService = container "Eureka Service" "Service discovery and registration" "Spring Cloud Eureka" "infrastructure"
            configService = container "Config Service" "Centralized configuration management" "Spring Cloud Config" "infrastructure"
            
            // Data Stores
            catalogDb = container "Catalog Database" "Stores book catalog data" "PostgreSQL" "database"
            orderDb = container "Order Database" "Stores order and transaction data" "PostgreSQL" "database"
            userDb = container "User Database" "Stores user profiles and authentication data" "PostgreSQL" "database"
            
            // Event Streaming
            kafka = container "Kafka Broker" "Event streaming platform for asynchronous communication" "Apache Kafka" "message-broker"
        }
        
        // External Systems
        emailProvider = softwareSystem "Email Provider" "Third-party email service for notifications" "external"
        smsProvider = softwareSystem "SMS Provider" "Third-party SMS service for notifications" "external"
        paymentGateway = softwareSystem "Payment Gateway" "External payment processing service" "external"
        
        // Relationships - External to System
        customer -> bookBazaarSystem "Browses books, places orders, manages account"
        admin -> bookBazaarSystem "Manages platform, monitors services"
        
        // Relationships - Customer interactions via API Gateway
        customer -> apiGateway "Makes API requests" "HTTPS/REST"
        admin -> apiGateway "Administrative operations" "HTTPS/REST"
        
        // Relationships - API Gateway to Services
        apiGateway -> catalogService "Routes catalog requests" "HTTP/REST"
        apiGateway -> orderService "Routes order requests" "HTTP/REST"
        apiGateway -> userService "Routes user requests" "HTTP/REST"
        apiGateway -> paymentService "Routes payment requests" "HTTP/REST"
        
        // Relationships - Service Discovery
        apiGateway -> eurekaService "Service discovery" "HTTP"
        catalogService -> eurekaService "Registers and discovers services" "HTTP"
        orderService -> eurekaService "Registers and discovers services" "HTTP"
        paymentService -> eurekaService "Registers and discovers services" "HTTP"
        userService -> eurekaService "Registers and discovers services" "HTTP"
        notificationService -> eurekaService "Registers and discovers services" "HTTP"
        
        // Relationships - Configuration
        catalogService -> configService "Fetches configuration" "HTTP"
        orderService -> configService "Fetches configuration" "HTTP"
        paymentService -> configService "Fetches configuration" "HTTP"
        userService -> configService "Fetches configuration" "HTTP"
        notificationService -> configService "Fetches configuration" "HTTP"
        
        // Relationships - Database connections
        catalogService -> catalogDb "Reads and writes book data" "JDBC/SQL"
        orderService -> orderDb "Reads and writes order data" "JDBC/SQL"
        userService -> userDb "Reads and writes user data" "JDBC/SQL"
        
        // Relationships - Synchronous service communication
        orderService -> catalogService "Validates book availability" "HTTP/REST"
        orderService -> userService "Validates user information" "HTTP/REST"
        
        // Relationships - Kafka event streaming
        orderService -> kafka "Publishes order.placed events" "Kafka Protocol"
        paymentService -> kafka "Consumes order.placed, publishes payment.completed events" "Kafka Protocol"
        notificationService -> kafka "Consumes order.placed and payment.completed events" "Kafka Protocol"
        
        // Relationships - External integrations
        paymentService -> paymentGateway "Processes payments" "HTTPS/REST"
        notificationService -> emailProvider "Sends email notifications" "SMTP/API"
        notificationService -> smsProvider "Sends SMS notifications" "HTTP/API"
        
        // Deployment Environment
        production = deploymentEnvironment "Production" {
            deploymentNode "Docker Swarm Cluster" {
                deploymentNode "Load Balancer" {
                    containerInstance apiGateway
                }
                
                deploymentNode "Application Nodes" {
                    deploymentNode "Node 1" {
                        containerInstance catalogService
                        containerInstance orderService
                    }
                    deploymentNode "Node 2" {
                        containerInstance paymentService
                        containerInstance userService
                        containerInstance notificationService
                    }
                    deploymentNode "Node 3" {
                        containerInstance eurekaService
                        containerInstance configService
                    }
                }
                
                deploymentNode "Data Layer" {
                    deploymentNode "Database Cluster" {
                        containerInstance catalogDb
                        containerInstance orderDb
                        containerInstance userDb
                    }
                    deploymentNode "Message Broker" {
                        containerInstance kafka
                    }
                }
            }
        }
    }

    views {
        systemContext bookBazaarSystem "SystemContext" {
            include *
            autoLayout
        }
        
        container bookBazaarSystem "Containers" {
            include *
            autoLayout
        }
        
        deployment bookBazaarSystem production "Deployment" {
            include *
            autoLayout
        }
        
        dynamic bookBazaarSystem "OrderFlow" "Order placement and processing flow" {
            title "Book Order Processing Flow"
            customer -> apiGateway "1. Place order request"
            apiGateway -> orderService "2. Route to order service"
            orderService -> catalogService "3. Validate book availability"
            orderService -> userService "4. Validate user"
            orderService -> orderDb "5. Store order"
            orderService -> kafka "6. Publish order.placed event"
            kafka -> paymentService "7. Consume order.placed"
            paymentService -> paymentGateway "8. Process payment"
            paymentService -> kafka "9. Publish payment.completed event"
            kafka -> notificationService "10. Consume payment.completed"
            notificationService -> emailProvider "11. Send order confirmation"
            autoLayout
        }
        
        styles {
            element "Person" {
                color #ffffff
                fontSize 22
                shape Person
            }
            element "Software System" {
                background #1168bd
                color #ffffff
            }
            element "external" {
                background #999999
                color #ffffff
            }
            element "microservice" {
                background #2E8B57
                color #ffffff
                shape RoundedBox
            }
            element "infrastructure" {
                background #FF6347
                color #ffffff
                shape Cylinder
            }
            element "gateway" {
                background #4169E1
                color #ffffff
                shape RoundedBox
            }
            element "database" {
                background #8FBC8F
                color #ffffff
                shape Cylinder
            }
            element "message-broker" {
                background #DAA520
                color #ffffff
                shape Pipe
            }
            relationship "Relationship" {
                dashed false
            }
            relationship "Kafka Protocol" {
                color #DAA520
                dashed true
            }
        }
    }
    
    configuration {
        scope softwaresystem
    }
}
