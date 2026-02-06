# Student Management System

A full-stack web application for managing student records with CRUD operations, built with Spring Boot, Thymeleaf, and PostgreSQL.

## Features

- View list of all students with search functionality
- View detailed information for individual students
- Add new students with auto-generated IDs
- Update existing student information
- Delete students with confirmation
- Server-side rendering with Thymeleaf templates
- RESTful API endpoints

## Technologies

- Java 23
- Spring Boot 4.0.2
- Spring Data JPA
- Thymeleaf
- PostgreSQL 16
- Maven
- Docker & Docker Compose

## Prerequisites

### Option 1: Local Development
- Java 23 or higher
- Maven 3.6+
- PostgreSQL 16+ installed and running

### Option 2: Docker
- Docker installed
- Docker Compose installed

## Setup Instructions

### Option 1: Local Development

#### 1. Install PostgreSQL

**macOS:**
```bash
brew install postgresql@16
brew services start postgresql@16
```

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install postgresql-16
sudo systemctl start postgresql
```

**Windows:**
Download and install from [PostgreSQL official website](https://www.postgresql.org/download/windows/)

#### 2. Create Database

```bash
psql -U postgres
CREATE DATABASE student_management;
\q
```

#### 3. Configure Database Connection

Update `src/main/resources/application.properties` if needed:

```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/student_management
spring.datasource.username=postgres
spring.datasource.password=your_password_here
```

#### 4. Run Application

```bash
cd student-management
mvn spring-boot:run
```

Application starts at http://localhost:8080

### Option 2: Docker

```bash
cd student-management
docker-compose up --build
```

Application starts at http://localhost:8080 with sample data automatically loaded.

**Stop the application:**
```bash
docker-compose down
```

## Usage

### Web Interface

- **Student List**: http://localhost:8080/students
- **Student Details**: http://localhost:8080/students/{id}
- **Add Student**: http://localhost:8080/students/new
- **Edit Student**: http://localhost:8080/students/{id}/edit

### REST API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/students` | Get all students |
| GET | `/api/students/{id}` | Get student by ID |
| POST | `/api/students` | Create new student |
| PUT | `/api/students/{id}` | Update student |
| DELETE | `/api/students/{id}` | Delete student |

**Example:**
```bash
curl http://localhost:8080/api/students
```

## Project Structure

```
student-management/
├── src/main/
│   ├── java/vn/edu/hcmut/cse/adsoftweng/lab/
│   │   ├── controller/          # REST and Web controllers
│   │   ├── entity/              # Student entity
│   │   ├── repository/          # Data access layer
│   │   └── service/             # Business logic
│   └── resources/
│       ├── templates/           # Thymeleaf HTML templates
│       └── application.properties
├── Dockerfile
├── docker-compose.yml
└── pom.xml
```

## Troubleshooting

### Port 8080 already in use
```bash
lsof -i :8080
kill -9 <PID>
```

### Port 5432 already in use (Docker)
Stop local PostgreSQL or change port in `docker-compose.yml` to `5433:5432`

### Database connection failed
```bash
# Check PostgreSQL is running
pg_isready -U postgres

# Docker: Check container status
docker-compose ps
docker logs student-management-db
```

### View application logs (Docker)
```bash
docker logs student-management-app -f
```

## Database Schema

```sql
CREATE TABLE students (
    id VARCHAR(255) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    age INTEGER NOT NULL
);
```

## License

Educational project for Advanced Software Engineering course at HCMUT.
