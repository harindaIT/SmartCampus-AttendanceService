package org.example.attendanceservice.dao;

import org.example.attendanceservice.model.Attendance;
import org.example.attendanceservice.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Data Access Object for attendance records.
 * Performs all CRUD operations using JDBC.
 */
public class AttendanceDAO {

    /**
     * Insert a new attendance record.
     */
    public boolean insert(Attendance attendance) throws SQLException {
        String sql = "INSERT INTO attendance (student_id, course_id, date, status) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, attendance.getStudentId());
            stmt.setInt(2, attendance.getCourseId());
            stmt.setDate(3, attendance.getDate());
            stmt.setString(4, attendance.getStatus());
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Get a single attendance record by ID.
     */
    public Attendance getById(int id) throws SQLException {
        String sql = "SELECT * FROM attendance WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    /**
     * Get all attendance records for a specific student.
     */
    public List<Attendance> getByStudentId(int studentId) throws SQLException {
        String sql = "SELECT * FROM attendance WHERE student_id = ? ORDER BY date DESC";
        List<Attendance> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    /**
     * Get all attendance records for a specific course.
     */
    public List<Attendance> getByCourseId(int courseId) throws SQLException {
        String sql = "SELECT * FROM attendance WHERE course_id = ? ORDER BY date DESC";
        List<Attendance> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, courseId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    /**
     * Get all attendance records.
     */
    public List<Attendance> getAll() throws SQLException {
        String sql = "SELECT * FROM attendance ORDER BY date DESC, student_id ASC";
        List<Attendance> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    /**
     * Update an existing attendance record.
     */
    public boolean update(Attendance attendance) throws SQLException {
        String sql = "UPDATE attendance SET student_id = ?, course_id = ?, date = ?, status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, attendance.getStudentId());
            stmt.setInt(2, attendance.getCourseId());
            stmt.setDate(3, attendance.getDate());
            stmt.setString(4, attendance.getStatus());
            stmt.setInt(5, attendance.getId());
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Delete an attendance record by ID.
     */
    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM attendance WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Get attendance summary for a specific student in a specific course.
     * Returns a map with keys: totalClasses, present, absent, late, percentage
     */
    public Map<String, Object> getSummary(int studentId, int courseId) throws SQLException {
        Map<String, Object> summary = new HashMap<>();

        String sqlTotal = "SELECT COUNT(*) AS total FROM attendance WHERE student_id = ? AND course_id = ?";
        String sqlPresent = "SELECT COUNT(*) AS cnt FROM attendance WHERE student_id = ? AND course_id = ? AND status = 'PRESENT'";
        String sqlAbsent = "SELECT COUNT(*) AS cnt FROM attendance WHERE student_id = ? AND course_id = ? AND status = 'ABSENT'";
        String sqlLate = "SELECT COUNT(*) AS cnt FROM attendance WHERE student_id = ? AND course_id = ? AND status = 'LATE'";

        try (Connection conn = DBConnection.getConnection()) {
            int total = 0, present = 0, absent = 0, late = 0;

            try (PreparedStatement stmt = conn.prepareStatement(sqlTotal)) {
                stmt.setInt(1, studentId);
                stmt.setInt(2, courseId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next())
                        total = rs.getInt("total");
                }
            }

            try (PreparedStatement stmt = conn.prepareStatement(sqlPresent)) {
                stmt.setInt(1, studentId);
                stmt.setInt(2, courseId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next())
                        present = rs.getInt("cnt");
                }
            }

            try (PreparedStatement stmt = conn.prepareStatement(sqlAbsent)) {
                stmt.setInt(1, studentId);
                stmt.setInt(2, courseId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next())
                        absent = rs.getInt("cnt");
                }
            }

            try (PreparedStatement stmt = conn.prepareStatement(sqlLate)) {
                stmt.setInt(1, studentId);
                stmt.setInt(2, courseId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next())
                        late = rs.getInt("cnt");
                }
            }

            double percentage = total > 0 ? ((double) (present + late) / total) * 100 : 0;

            summary.put("totalClasses", total);
            summary.put("present", present);
            summary.put("absent", absent);
            summary.put("late", late);
            summary.put("percentage", Math.round(percentage * 100.0) / 100.0);
        }

        return summary;
    }

    /**
     * Map a ResultSet row to an Attendance object.
     */
    private Attendance mapRow(ResultSet rs) throws SQLException {
        return new Attendance(
                rs.getInt("id"),
                rs.getInt("student_id"),
                rs.getInt("course_id"),
                rs.getDate("date"),
                rs.getString("status"),
                rs.getTimestamp("recorded_at"));
    }
}
