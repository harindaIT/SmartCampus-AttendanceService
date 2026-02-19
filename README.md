<<<<<<< HEAD
# SmartCampus - Attendance Service
Group 6 - Distributed University Management System

# Description
This is the Attendance Microservice developed using:
- Java Servlet
- JSP
- JDBC
- MySQL
- Apache Tomcat

This service handles:
- Recording attendance
- Viewing attendance by student
- Viewing attendance by course
- Attendance summary calculation
- Inter-service communication

# Architecture
- MVC Architecture
- Separate database
- Runs on independent port (8086)
- Communicates with other services using HTTP + JSON

# Database Setup

1. Open MySQL
2. Run the script located in:
   database/attendance_service_db.sql

# Configuration

Update DB credentials inside:

util/DBConnection.java

Example:
- Database: attendance_service_db
- Username: root
- Password: your_password

---

# Deployment Instructions

1. Import project into IntelliJ/Eclipse
2. Configure Apache Tomcat (Port: 8086)
3. Build WAR file
4. Deploy to Tomcat
5. Start Tomcat server

Service URL:
http://localhost:8086/AttendanceService

# 🔄 API Endpoints

# Record Attendance
POST /attendance/record

# Get Attendance By Student
GET /attendance/student?id=1

# Get Attendance By Course
GET /attendance/course?id=2

# Attendance Summary
GET /attendance/summary?studentId=1&courseId=2

# Dummy Endpoint
GET /attendance/check?studentId=1

# Integration

Consumes:
- Student Service (Validation Endpoint)

Provides:
- Attendance eligibility endpoint

# Group Members
- Member 1   HARINDINTWALI Emilien    24rp00975
- Member 2   NIKUZE Josiane           24rp02358
- Member 3   MUGISHA Girbert          24rp03663
- Member 4   UMUTONI Angela           24rp09732
- Member 5   NIYONIRINGIYE Jean Paul  24rp00812
=======
# 📋 Attendance Service — SmartCampus (Group 6)

A microservice for recording, viewing, and summarizing student attendance.  
Part of the **Distributed University Management System** built with Microservice Architecture.

## 🛠 Technology Stack

| Technology | Usage |
|------------|-------|
| Java Servlet 4.0 | HTTP request handling |
| JSP + JSTL | Server-side views |
| MySQL 8.0 | Database |
| JDBC | Database access (no ORM) |
| Apache Tomcat 9 | Application server |
| Bootstrap 5 | UI styling |
| javax.json | JSON processing |

## 📦 Project Structure

```
AttendanceService/
├── src/main/java/org/example/attendanceservice/
│   ├── model/          Attendance.java (POJO)
│   ├── dao/            AttendanceDAO.java (JDBC CRUD)
│   ├── service/        AttendanceService.java (Business Logic)
│   ├── controller/     AttendanceServlet.java (REST API)
│   │                   AttendancePageServlet.java (JSP Controller)
│   └── util/           DBConnection.java
├── src/main/webapp/
│   ├── index.jsp               (Dashboard)
│   ├── attendance.jsp          (Record/Edit Form)
│   ├── attendance-list.jsp     (List View)
│   ├── attendance-summary.jsp  (Summary View)
│   └── WEB-INF/web.xml
├── attendance_service_db.sql   (Database Script)
└── pom.xml
```

## ⚙️ Setup Instructions

### 1. Database Setup

1. Open MySQL and run the SQL script:
   ```sql
   source attendance_service_db.sql;
   ```
   Or import `attendance_service_db.sql` via MySQL Workbench.

2. If your MySQL credentials are different from `root` with no password, update:
   ```
   src/main/java/org/example/attendanceservice/util/DBConnection.java
   ```

### 2. Tomcat Configuration

1. Set Tomcat to run on **port 8086** in `server.xml`:
   ```xml
   <Connector port="8086" ... />
   ```

2. Deploy the WAR file to Tomcat.

### 3. Build & Run

```bash
mvn clean package
```

Deploy `target/AttendanceService-1.0-SNAPSHOT.war` to Tomcat,  
or run directly from IntelliJ with Tomcat configuration.

Access at: **http://localhost:8086/AttendanceService/**

## 🌐 API Endpoints

All API endpoints return JSON responses.

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/api/attendance/record` | Record new attendance (JSON body) |
| `GET` | `/api/attendance/all` | List all attendance records |
| `GET` | `/api/attendance/get?id={id}` | Get single record by ID |
| `GET` | `/api/attendance/student?id={studentId}` | Get records by student |
| `GET` | `/api/attendance/course?id={courseId}` | Get records by course |
| `GET` | `/api/attendance/summary?studentId={id}&courseId={id}` | Get attendance summary |
| `PUT` | `/api/attendance/update` | Update a record (JSON body) |
| `DELETE` | `/api/attendance/delete?id={id}` | Delete a record |
| `GET` | `/api/attendance/check?studentId={id}&courseId={id}` | Check eligibility (dummy endpoint) |

### Example: Record Attendance
```json
POST /api/attendance/record
Content-Type: application/json

{
  "studentId": 1,
  "courseId": 101,
  "date": "2026-02-18",
  "status": "PRESENT"
}
```

### Example: Summary Response
```json
GET /api/attendance/summary?studentId=1&courseId=101

{
  "studentId": 1,
  "courseId": 101,
  "totalClasses": 5,
  "present": 3,
  "absent": 1,
  "late": 1,
  "percentage": 80.0
}
```

### Example: Eligibility Check (Dummy Endpoint)
```json
GET /api/attendance/check?studentId=1&courseId=101

{
  "studentId": 1,
  "courseId": 101,
  "eligible": true
}
```

## 🔗 Inter-Service Communication

### Consumed Service
- **Student Service** at `http://localhost:8082/StudentService/student/validate?id={id}`
- Used to validate student ID before recording attendance
- Falls back gracefully if Student Service is unavailable

### Exposed Dummy Endpoint
- `GET /api/attendance/check?studentId={id}&courseId={id}`
- Returns eligibility status based on ≥75% attendance
- Can be consumed by **Result Service** (Group 7)

## 👥 Group Members

- *(Add your group member names here)*

## 📄 License

Rwanda Polytechnic — SmartCampus Distributed University Management System
>>>>>>> cd6a9b5 (Paul commit)
