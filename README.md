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
