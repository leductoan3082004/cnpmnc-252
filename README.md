# Student Management System

A full-stack web application for managing student records built with Spring Boot, Thymeleaf, PostgreSQL, deployed using Docker with Nginx reverse proxy and automatic SSL/TLS certificates.

**Live Demo:** [Update after deployment]

## Team

**Group Members:**
- Lê Đức Toàn - 2213526
- Nguyễn Anh Lâm - [Student ID]

**Course:** Advanced Software Engineering
**Institution:** HCMC University of Technology
**Instructor:** Dr. Thuan Le (thuanle@hcmut.edu.vn)

## Lab Questions & Answers

### Lab 1: Initialization & Architecture

**Q: Why does the database block duplicate ID inserts?**

A: The database enforces the Primary Key constraint, which requires uniqueness. This ensures data integrity by preventing ambiguous UPDATE or DELETE operations that could affect multiple records.

**Q: What happens if the name column allows NULL values?**

A: Without a NOT NULL constraint, Java code calling methods on null names (e.g., `getName().toUpperCase()`) will throw NullPointerException. Constraints should be added at database design time to prevent runtime errors.

### Lab 2: Backend REST API

**Q: Why use Dependency Injection instead of `new`?**

A: Dependency Injection provides:
- Loose coupling between components
- Easier unit testing with mock objects
- Centralized lifecycle management via Spring Container
- Singleton pattern by default, reducing memory usage

**Q: Difference between @RestController and @Controller?**

A:
- `@Controller`: Returns views (HTML templates)
- `@RestController`: Returns data (JSON/XML), automatically adds `@ResponseBody`

### Lab 3: Frontend SSR

**Q: How to implement search by name?**

A: Use Spring Data JPA Query Method:
```java
List<Student> findByNameContainingIgnoreCase(String keyword);
```

### Lab 4: PostgreSQL & CRUD

**Q: Why use .env files?**

A: Environment files provide:
- Security: Passwords are not committed to version control
- Flexibility: Easy configuration per environment
- Best practice: Follows 12-Factor App methodology

### Lab 5: Docker & Deployment

**Q: Why use Nginx reverse proxy?**

A: Nginx provides:
- SSL/TLS termination
- Load balancing capabilities
- Efficient static content serving
- Security layer hiding backend servers

## Overview

### Architecture

```
Internet → Nginx (80/443) → Spring Boot (8080) → PostgreSQL (5432)
                ↓
           acme.sh (SSL)
```

**Services:**
- `nginx`: Reverse proxy with SSL termination
- `acme`: SSL certificate management (Let's Encrypt)
- `app`: Spring Boot application
- `postgres`: PostgreSQL database

## Technologies

- Java 23
- Spring Boot 4.0.2
- Spring Data JPA
- Thymeleaf
- PostgreSQL 16
- Docker & Docker Compose
- Nginx
- Maven

## Prerequisites

- Java 23+ and Maven (for local development)
- Docker and Docker Compose (for deployment)
- Domain name with DNS configured (for SSL)

## Setup and Deployment

### Local Development

```bash
git clone https://github.com/YOUR-USERNAME/student-management.git
cd student-management

# Configure database in application.properties
nano src/main/resources/application.properties

# Build and run
./mvnw clean package
./mvnw spring-boot:run
```

Access at `http://localhost:8080`

### Using Docker Locally

```bash
docker-compose up -d
docker-compose logs -f
```

Access at `http://localhost`

### Production Deployment

**Prerequisites:** Docker and Docker Compose installed on your server.

```bash
git clone https://github.com/YOUR-USERNAME/student-management.git
cd student-management
cp .env.example .env
nano .env
```

Update `.env`:
```bash
POSTGRES_DB=student_management
POSTGRES_USER=postgres
POSTGRES_PASSWORD=your_secure_password
ACME_EMAIL=your-email@example.com
```

```bash
docker-compose up -d
docker-compose ps
```

Your application is now running at `http://your-server-ip`

**Configure SSL (optional):**

Ensure your domain points to your server IP and ports 80/443 are open.

```bash
./setup-ssl.sh yourdomain.com your-email@example.com
```

Your application is now accessible at `https://yourdomain.com`

### Management Commands

```bash
# View logs
docker-compose logs -f [service-name]

# Restart services
docker-compose restart

# Update application
git pull && docker-compose up -d --build app

# Database backup
docker-compose exec postgres pg_dump -U postgres student_management > backup.sql

# Database restore
docker-compose exec -T postgres psql -U postgres student_management < backup.sql
```

### Troubleshooting

```bash
# Check container status
docker-compose ps
docker-compose logs [service-name]

# Test database connection
docker-compose exec postgres pg_isready

# Verify Nginx configuration
docker-compose exec nginx nginx -t

# Check port usage
sudo lsof -i :80
sudo lsof -i :443
```

## API Documentation

### REST API Endpoints

Base URL: `/api/students`

**Get all students:**
```
GET /api/students
```

**Get student by ID:**
```
GET /api/students/{id}
```

**Response format:**
```json
{
  "id": "uuid",
  "name": "Nguyen Van A",
  "email": "vana@example.com",
  "age": 20
}
```

### Web UI Endpoints

- `GET /students` - List all students with search
- `GET /students/new` - New student form
- `GET /students/{id}` - View student details
- `GET /students/{id}/edit` - Edit student form
- `POST /students` - Create new student
- `POST /students/{id}` - Update student
- `POST /students/{id}/delete` - Delete student
