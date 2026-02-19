package org.example.attendanceservice.service;

import org.example.attendanceservice.dao.AttendanceDAO;
import org.example.attendanceservice.model.Attendance;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

/**
 * Service layer for attendance business logic.
 * Handles inter-service communication and delegates to DAO.
 */
public class AttendanceService {

    private final AttendanceDAO attendanceDAO = new AttendanceDAO();

    // Student Service URL (change IP/port if running on different machine)
    private static final String STUDENT_SERVICE_URL = "https://dshgo-197-157-184-238.a.free.pinggy.link/AttendanceService_war_exploded/";
    // Course Service URL (change IP/port if running on different machine)
    private static final String COURSE_SERVICE_URL = "https://cziml-154-68-72-81.a.free.pinggy.link/CourseService_war_exploded/courses";
    // Enrollment Service URL (change IP/port if running on different machine)
    private static final String ENROLLMENT_SERVICE_URL = "https://mpxwo-197-157-186-163.a.free.pinggy.link/enrollments?courseId";

    // ==================== CRUD Operations ====================

    /**
     * Record a new attendance entry.
     */
    public boolean recordAttendance(Attendance attendance) throws SQLException {
        // Validate status
        String status = attendance.getStatus();
        if (!"PRESENT".equals(status) && !"ABSENT".equals(status) && !"LATE".equals(status)) {
            throw new IllegalArgumentException("Invalid status. Must be PRESENT, ABSENT, or LATE.");
        }

        return attendanceDAO.insert(attendance);
    }

    /**
     * Get attendance record by ID.
     */
    public Attendance getAttendanceById(int id) throws SQLException {
        return attendanceDAO.getById(id);
    }

    /**
     * Get all attendance records for a student.
     */
    public List<Attendance> getAttendanceByStudent(int studentId) throws SQLException {
        return attendanceDAO.getByStudentId(studentId);
    }

    /**
     * Get all attendance records for a course.
     */
    public List<Attendance> getAttendanceByCourse(int courseId) throws SQLException {
        return attendanceDAO.getByCourseId(courseId);
    }

    /**
     * Get all attendance records.
     */
    public List<Attendance> getAllAttendance() throws SQLException {
        return attendanceDAO.getAll();
    }

    /**
     * Update an attendance record.
     */
    public boolean updateAttendance(Attendance attendance) throws SQLException {
        String status = attendance.getStatus();
        if (!"PRESENT".equals(status) && !"ABSENT".equals(status) && !"LATE".equals(status)) {
            throw new IllegalArgumentException("Invalid status. Must be PRESENT, ABSENT, or LATE.");
        }
        return attendanceDAO.update(attendance);
    }

    /**
     * Delete an attendance record.
     */
    public boolean deleteAttendance(int id) throws SQLException {
        return attendanceDAO.delete(id);
    }

    /**
     * Get attendance summary for a student in a course.
     */
    public Map<String, Object> getAttendanceSummary(int studentId, int courseId) throws SQLException {
        return attendanceDAO.getSummary(studentId, courseId);
    }

    // ==================== Inter-Service Communication ====================

    /**
     * Validate a student by calling the Student Service.
     * Returns true if the student is valid, false otherwise.
     * Falls back to true if the Student Service is unavailable (graceful
     * degradation).
     */
    public boolean validateStudent(int studentId) {
        try {
            String urlStr = STUDENT_SERVICE_URL + "/validate?id=" + studentId;
            URL url = new URL(urlStr);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(3000);
            conn.setReadTimeout(3000);

            int responseCode = conn.getResponseCode();
            if (responseCode == 200) {
                BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                StringBuilder response = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    response.append(line);
                }
                reader.close();
                conn.disconnect();

                // Simple JSON check — look for "valid": true
                String responseBody = response.toString();
                return responseBody.contains("\"valid\"") && responseBody.contains("true");
            }
            conn.disconnect();
        } catch (Exception e) {
            // Student Service unavailable — log and allow graceful fallback
            System.out.println("[AttendanceService] WARNING: Student Service unavailable. Skipping validation. Error: "
                    + e.getMessage());
        }
        // Graceful degradation: allow recording even if Student Service is down
        return true;
    }

    /**
     * Check if a student is eligible based on attendance (>= 75%).
     * This is the DUMMY ENDPOINT logic exposed for other services (e.g., Result
     * Service).
     */
    public boolean checkEligibility(int studentId, int courseId) throws SQLException {
        Map<String, Object> summary = attendanceDAO.getSummary(studentId, courseId);
        double percentage = (double) summary.get("percentage");
        return percentage >= 75.0;
    }

    /**
     * Validate if a student is enrolled in a course via Enrollment Service.
     */
    public boolean validateEnrollment(int studentId, int courseId) {
        String urlStr = ENROLLMENT_SERVICE_URL + "/check?studentId=" + studentId + "&courseId=" + courseId;
        String response = callExternalService(urlStr);
        // Assuming response is boolean or contains "true"
        return response.contains("true");
    }

    /**
     * Get enrolled student IDs from Enrollment Service.
     */
    public List<Integer> getEnrolledStudentIds(int courseId) {
        // This would parse the JSON array of student IDs from Enrollment Service
        // For now, implementing a mock or basic parsing logic if usage requires it
        // But the main requirement is fetching details.
        return java.util.Collections.emptyList(); // Placeholder, logic moved to getEnrolledStudentsDetails
    }

    /**
     * Fetch enrolled students with details (ID, Name) for a specific course.
     * Orchestrates calls to Enrollment Service and Student Service.
     */
    public String getEnrolledStudentsDetails(int courseId) {
        // 1. Get Student IDs from Enrollment Service
        String enrollmentResponse = callExternalService(ENROLLMENT_SERVICE_URL + "/course/" + courseId);

        // Dummy fallback for testing
        if (enrollmentResponse.equals("[]") || enrollmentResponse.isEmpty() || enrollmentResponse.startsWith("Error")) {
            // Return specific students for Java and PHP courses
            return "[{\"studentId\":1,\"name\":\"Nikuze Josiane\"},{\"studentId\":2,\"name\":\"HARINDINTWALI Emilien\"},{\"studentId\":3,\"name\":\"UMUTONI Angella\"},{\"studentId\":4,\"name\":\"MUGISHA Girbert\"},{\"studentId\":5,\"name\":\"NIYONIRINGIYE Jean Paul\"}]";
        }

        return enrollmentResponse;
    }

    // ==================== External API Data Fetching ====================

    /**
     * Fetch the list of all students from Student Service as a JSON string.
     * Falls back to an empty JSON array if the service is unavailable.
     */
    public String fetchStudentList() {
        String response = callExternalService(STUDENT_SERVICE_URL + "/list");
        if (response.equals("[]")) {
            // Dummy fallback for testing
            return "[{\"id\":1,\"name\":\"NIKUZE Josiane\",\"registrationNumber\":\"STU001\"}," +
                    "{\"id\":2,\"name\":\"HARINDINTWALI Emilien\",\"registrationNumber\":\"STU002\"}," + "{\"id\":3,\"name\":\"UMUTONI Angella\",\"registrationNumber\":\"STU003\"}," + "{\"id\":4,\"name\":\"MUGISHA Girbert\",\"registrationNumber\":\"STU004\"}," + "{\"id\":5,\"name\":\"NIYONIRINGIYE Jean Paul\",\"registrationNumber\":\"STU005\"}]";
        }
        return response;
    }

    /**
     * Fetch the list of all courses from Course Service as a JSON string.
     * Falls back to dummy data if the service is unavailable.
     */
    public String fetchCourseList() {
        String response = callExternalService(COURSE_SERVICE_URL + "/course/list");
        if (response.equals("[]") || response.isEmpty() || response.startsWith("Error")) {
            // Dummy fallback for testing
            return "[{\"id\":101,\"name\":\"Java Programming\",\"code\":\"CS101\"}," +
                    "{\"id\":102,\"name\":\"PHP Web Development\",\"code\":\"CS202\"}]";
        }
        return response;
    }

    /**
     * Generic helper to make a GET request to an external service URL and return
     * the response body as a string. Returns "[]" on failure.
     */
    private String callExternalService(String urlStr) {
        try {
            URL url = new URL(urlStr);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(3000);
            conn.setReadTimeout(3000);

            int responseCode = conn.getResponseCode();
            if (responseCode == 200) {
                BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                StringBuilder response = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    response.append(line);
                }
                reader.close();
                conn.disconnect();
                return response.toString();
            }
            conn.disconnect();
        } catch (Exception e) {
            System.out.println("[AttendanceService] WARNING: External service unavailable at " + urlStr
                    + ". Error: " + e.getMessage());
        }
        return "[]";
    }
}
