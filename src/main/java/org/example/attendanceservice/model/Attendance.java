package org.example.attendanceservice.model;

import java.sql.Date;
import java.sql.Timestamp;

/**
 * Model class representing an attendance record.
 */
public class Attendance {

    private int id;
    private int studentId;
    private int courseId;
    private Date date;
    private String status;
    private Timestamp recordedAt;

    public Attendance() {
    }

    public Attendance(int studentId, int courseId, Date date, String status) {
        this.studentId = studentId;
        this.courseId = courseId;
        this.date = date;
        this.status = status;
    }

    public Attendance(int id, int studentId, int courseId, Date date, String status, Timestamp recordedAt) {
        this.id = id;
        this.studentId = studentId;
        this.courseId = courseId;
        this.date = date;
        this.status = status;
        this.recordedAt = recordedAt;
    }

    // Getters and Setters

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getRecordedAt() {
        return recordedAt;
    }

    public void setRecordedAt(Timestamp recordedAt) {
        this.recordedAt = recordedAt;
    }
}
