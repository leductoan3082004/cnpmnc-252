# Student Management System

A full-stack web application for managing student records, built with Spring Boot and Thymeleaf, backed by PostgreSQL, and deployed with Docker.

**Live Demo:** https://student-management.haretaworkshop.com

## Team

**Group Members:**
- Lê Đức Toàn - 2213526
- Nguyễn Anh Lâm - [Student ID]

**Course:** Advanced Software Engineering
**Institution:** HCMC University of Technology
**Instructor:** Dr. Thuan Le (thuanle@hcmut.edu.vn)

---

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

---

## Overview

### Architecture

```
Internet
   │
   ▼
nginx-proxy (port 80/443)   ← jwilder/nginx-proxy on the server,
   │  + letsencrypt            shared by all deployments, auto SSL
   │
   ▼
student-management-app (8080)
   │
   ▼
student-management-db (5432, internal only)
```

**Docker services:**

| Service | Image | Role |
|---|---|---|
| `app` | Built from `Dockerfile` | Spring Boot application |
| `student-postgres` | `postgres:16-alpine` | Database (internal network only) |

SSL and routing are handled by `jwilder/nginx-proxy` + `jrcs/letsencrypt-nginx-proxy-companion`, which already run on the server and are shared across all deployments.

### Tech Stack

| Layer | Technology |
|---|---|
| Language | Java 23 |
| Framework | Spring Boot 4.0.2 |
| ORM | Spring Data JPA / Hibernate |
| Templating | Thymeleaf |
| Database | PostgreSQL 16 |
| Build | Maven |
| Containerisation | Docker & Docker Compose |

---

## Project Structure

```
student-management/
├── src/
│   └── main/java/vn/edu/hcmut/cse/adsoftweng/lab/
│       ├── StudentManagementApplication.java
│       ├── controller/
│       │   ├── StudentController.java      # REST API  (/api/students)
│       │   └── StudentWebController.java   # Web UI    (/students)
│       ├── entity/
│       │   └── Student.java               # id, name, email, age
│       ├── repository/
│       │   └── StudentRepository.java
│       └── service/
│           └── StudentService.java
├── Dockerfile
├── docker-compose.yml                     # Production config
├── docker-compose.override.yml            # Local dev overrides (auto-loaded)
├── init.sql                               # Seeds 5 sample students
└── pom.xml
```

---

## Running the App

### Option 1 — Local with Docker (recommended)

`docker-compose.override.yml` is automatically merged, so no extra flags needed. It creates a local network and exposes port 8080 directly.

```bash
git clone https://github.com/leductoan3082004/cnpmnc-252.git student-management
cd student-management
docker compose up --build
```

Access at `http://localhost:8080/students`

### Option 2 — Local without Docker

Requires Java 23+, Maven, and a running PostgreSQL instance.

```bash
# Set env vars or edit src/main/resources/application.properties
export SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5432/student_management
export SPRING_DATASOURCE_USERNAME=postgres
export SPRING_DATASOURCE_PASSWORD=postgres123

./mvnw spring-boot:run
```

Access at `http://localhost:8080/students`

### Option 3 — Production server

The server must already be running `jwilder/nginx-proxy` and `jrcs/letsencrypt-nginx-proxy-companion` on a Docker network named `my-net`. The `docker-compose.override.yml` must **not** be present so the production config is used as-is.

```bash
git clone https://github.com/leductoan3082004/cnpmnc-252.git student-management
cd student-management
docker compose up -d --build
```

The proxy discovers the container via the `VIRTUAL_HOST` environment variable and issues an SSL certificate automatically.

---

## API Reference

### REST API — `/api/students`

| Method | Path | Description | Response |
|---|---|---|---|
| `GET` | `/api/students` | List all students | `Student[]` JSON |
| `GET` | `/api/students/{id}` | Get one student | `Student` JSON |

**Student object:**
```json
{
  "id": "7b6b6469-8792-4c88-a608-6e8da862f72c",
  "name": "Nguyen Van A",
  "email": "vana@example.com",
  "age": 20
}
```

### Web UI — `/students`

| Method | Path | Description |
|---|---|---|
| `GET` | `/students` | Student list (supports `?keyword=` search) |
| `GET` | `/students/new` | Add student form |
| `GET` | `/students/{id}` | Student detail page |
| `GET` | `/students/{id}/edit` | Edit student form |
| `POST` | `/students` | Create student → redirects to list |
| `POST` | `/students/{id}` | Update student → redirects to list |
| `POST` | `/students/{id}/delete` | Delete student → redirects to list |

---

## Management Commands

```bash
# Follow logs
docker compose logs -f app

# Restart app only
docker compose restart app

# Pull latest code and rebuild
git pull && docker compose up -d --build app

# Database backup
docker compose exec student-postgres pg_dump -U postgres student_management > backup.sql

# Database restore
docker compose exec -T student-postgres psql -U postgres student_management < backup.sql

# Check container status
docker compose ps
```
