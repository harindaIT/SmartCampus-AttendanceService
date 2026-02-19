package org.example.attendanceservice.controller;

import org.example.attendanceservice.model.Attendance;
import org.example.attendanceservice.service.AttendanceService;

import javax.json.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringReader;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * REST-style API Servlet for Attendance Service.
 * Handles JSON requests and responses for all CRUD and business operations.
 *
 * Endpoints:
 * POST /api/attendance/record — Record attendance
 * GET /api/attendance/student?id=X — Get by student
 * GET /api/attendance/course?id=X — Get by course
 * GET /api/attendance/summary?studentId=X&courseId=Y — Summary
 * GET /api/attendance/check?studentId=X&courseId=Y — Eligibility (dummy)
 * GET /api/attendance/all — List all
 * GET /api/attendance/get?id=X — Get single record
 * PUT /api/attendance/update — Update record
 * DELETE /api/attendance/delete?id=X — Delete record
 */
@WebServlet(name = "AttendanceServlet", urlPatterns = { "/api/attendance/*" })
public class AttendanceServlet extends HttpServlet {

    private final AttendanceService attendanceService = new AttendanceService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String pathInfo = request.getPathInfo();
        if (pathInfo == null)
            pathInfo = "/";

        PrintWriter out = response.getWriter();

        try {
            switch (pathInfo) {
                case "/student":
                    handleGetByStudent(request, response, out);
                    break;
                case "/course":
                    handleGetByCourse(request, response, out);
                    break;
                case "/summary":
                    handleGetSummary(request, response, out);
                    break;
                case "/check":
                    handleCheckEligibility(request, response, out);
                    break;
                case "/all":
                    handleGetAll(response, out);
                    break;
                case "/get":
                    handleGetById(request, response, out);
                    break;
                case "/enrolled-students":
                    handleGetEnrolledStudents(request, response, out);
                    break;
                default:
                    sendError(response, out, 404, "Endpoint not found: " + pathInfo);
            }
        } catch (Exception e) {
            sendError(response, out, 500, "Internal server error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String pathInfo = request.getPathInfo();
        if (pathInfo == null)
            pathInfo = "/";

        PrintWriter out = response.getWriter();

        try {
            if ("/record".equals(pathInfo)) {
                handleRecord(request, response, out);
            } else if ("/bulk-record".equals(pathInfo)) {
                handleBulkRecord(request, response, out);
            } else {
                sendError(response, out, 404, "Endpoint not found: " + pathInfo);
            }
        } catch (Exception e) {
            sendError(response, out, 500, "Internal server error: " + e.getMessage());
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String pathInfo = request.getPathInfo();
        if (pathInfo == null)
            pathInfo = "/";

        PrintWriter out = response.getWriter();

        try {
            if ("/update".equals(pathInfo)) {
                handleUpdate(request, response, out);
            } else {
                sendError(response, out, 404, "Endpoint not found: " + pathInfo);
            }
        } catch (Exception e) {
            sendError(response, out, 500, "Internal server error: " + e.getMessage());
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String pathInfo = request.getPathInfo();
        if (pathInfo == null)
            pathInfo = "/";

        PrintWriter out = response.getWriter();

        try {
            if ("/delete".equals(pathInfo)) {
                handleDelete(request, response, out);
            } else {
                sendError(response, out, 404, "Endpoint not found: " + pathInfo);
            }
        } catch (Exception e) {
            sendError(response, out, 500, "Internal server error: " + e.getMessage());
        }
    }

    // ==================== Handler Methods ====================

    private void handleRecord(HttpServletRequest request, HttpServletResponse response, PrintWriter out)
            throws IOException, SQLException {
        String body = request.getReader().lines().collect(Collectors.joining());
        JsonObject json = Json.createReader(new StringReader(body)).readObject();

        int studentId = json.getInt("studentId");
        int courseId = json.getInt("courseId");
        String dateStr = json.getString("date");
        String status = json.getString("status").toUpperCase();

        // Validate student via Student Service (inter-service communication)
        if (!attendanceService.validateStudent(studentId)) {
            sendError(response, out, 400, "Invalid student ID: " + studentId);
            return;
        }

        Attendance attendance = new Attendance(studentId, courseId, Date.valueOf(dateStr), status);

        try {
            boolean success = attendanceService.recordAttendance(attendance);
            if (success) {
                response.setStatus(201);
                out.print(Json.createObjectBuilder()
                        .add("message", "Attendance recorded successfully")
                        .build().toString());
            } else {
                sendError(response, out, 500, "Failed to record attendance");
            }
        } catch (IllegalArgumentException e) {
            sendError(response, out, 400, e.getMessage());
        } catch (SQLException e) {
            if (e.getMessage().contains("Duplicate")) {
                sendError(response, out, 409, "Attendance already recorded for this student, course, and date");
            } else {
                throw e;
            }
        }
    }

    private void handleGetByStudent(HttpServletRequest request, HttpServletResponse response, PrintWriter out)
            throws SQLException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            sendError(response, out, 400, "Missing required parameter: id");
            return;
        }
        int studentId = Integer.parseInt(idStr);
        List<Attendance> list = attendanceService.getAttendanceByStudent(studentId);
        out.print(buildJsonArray(list).toString());
    }

    private void handleGetByCourse(HttpServletRequest request, HttpServletResponse response, PrintWriter out)
            throws SQLException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            sendError(response, out, 400, "Missing required parameter: id");
            return;
        }
        int courseId = Integer.parseInt(idStr);
        List<Attendance> list = attendanceService.getAttendanceByCourse(courseId);
        out.print(buildJsonArray(list).toString());
    }

    private void handleGetSummary(HttpServletRequest request, HttpServletResponse response, PrintWriter out)
            throws SQLException {
        String studentIdStr = request.getParameter("studentId");
        String courseIdStr = request.getParameter("courseId");

        if (studentIdStr == null || courseIdStr == null) {
            sendError(response, out, 400, "Missing required parameters: studentId and courseId");
            return;
        }

        int studentId = Integer.parseInt(studentIdStr);
        int courseId = Integer.parseInt(courseIdStr);

        Map<String, Object> summary = attendanceService.getAttendanceSummary(studentId, courseId);

        out.print(Json.createObjectBuilder()
                .add("studentId", studentId)
                .add("courseId", courseId)
                .add("totalClasses", (int) summary.get("totalClasses"))
                .add("present", (int) summary.get("present"))
                .add("absent", (int) summary.get("absent"))
                .add("late", (int) summary.get("late"))
                .add("percentage", (double) summary.get("percentage"))
                .build().toString());
    }

    private void handleCheckEligibility(HttpServletRequest request, HttpServletResponse response, PrintWriter out)
            throws SQLException {
        String studentIdStr = request.getParameter("studentId");
        String courseIdStr = request.getParameter("courseId");

        if (studentIdStr == null || courseIdStr == null) {
            sendError(response, out, 400, "Missing required parameters: studentId and courseId");
            return;
        }

        int studentId = Integer.parseInt(studentIdStr);
        int courseId = Integer.parseInt(courseIdStr);

        boolean eligible = attendanceService.checkEligibility(studentId, courseId);

        out.print(Json.createObjectBuilder()
                .add("studentId", studentId)
                .add("courseId", courseId)
                .add("eligible", eligible)
                .build().toString());
    }

    private void handleGetAll(HttpServletResponse response, PrintWriter out) throws SQLException {
        List<Attendance> list = attendanceService.getAllAttendance();
        out.print(buildJsonArray(list).toString());
    }

    private void handleGetById(HttpServletRequest request, HttpServletResponse response, PrintWriter out)
            throws SQLException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            sendError(response, out, 400, "Missing required parameter: id");
            return;
        }
        int id = Integer.parseInt(idStr);
        Attendance attendance = attendanceService.getAttendanceById(id);
        if (attendance == null) {
            sendError(response, out, 404, "Attendance record not found with id: " + id);
        } else {
            out.print(buildJsonObject(attendance).toString());
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response, PrintWriter out)
            throws IOException, SQLException {
        String body = request.getReader().lines().collect(Collectors.joining());
        JsonObject json = Json.createReader(new StringReader(body)).readObject();

        int id = json.getInt("id");
        int studentId = json.getInt("studentId");
        int courseId = json.getInt("courseId");
        String dateStr = json.getString("date");
        String status = json.getString("status").toUpperCase();

        Attendance attendance = new Attendance(studentId, courseId, Date.valueOf(dateStr), status);
        attendance.setId(id);

        try {
            boolean success = attendanceService.updateAttendance(attendance);
            if (success) {
                out.print(Json.createObjectBuilder()
                        .add("message", "Attendance updated successfully")
                        .build().toString());
            } else {
                sendError(response, out, 404, "Attendance record not found with id: " + id);
            }
        } catch (IllegalArgumentException e) {
            sendError(response, out, 400, e.getMessage());
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response, PrintWriter out)
            throws SQLException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            sendError(response, out, 400, "Missing required parameter: id");
            return;
        }
        int id = Integer.parseInt(idStr);
        boolean success = attendanceService.deleteAttendance(id);
        if (success) {
            out.print(Json.createObjectBuilder()
                    .add("message", "Attendance record deleted successfully")
                    .build().toString());
        } else {
            sendError(response, out, 404, "Attendance record not found with id: " + id);
        }
    }

    // ==================== Utility Methods ====================

    private JsonArray buildJsonArray(List<Attendance> list) {
        JsonArrayBuilder builder = Json.createArrayBuilder();
        for (Attendance a : list) {
            builder.add(buildJsonObject(a));
        }
        return builder.build();
    }

    private JsonObject buildJsonObject(Attendance a) {
        JsonObjectBuilder builder = Json.createObjectBuilder()
                .add("id", a.getId())
                .add("studentId", a.getStudentId())
                .add("courseId", a.getCourseId())
                .add("date", a.getDate().toString())
                .add("status", a.getStatus());
        if (a.getRecordedAt() != null) {
            builder.add("recordedAt", a.getRecordedAt().toString());
        }
        return builder.build();
    }

    private void sendError(HttpServletResponse response, PrintWriter out, int status, String message) {
        response.setStatus(status);
        out.print(Json.createObjectBuilder()
                .add("error", message)
                .build().toString());
    }

    private void handleBulkRecord(HttpServletRequest request, HttpServletResponse response, PrintWriter out)
            throws IOException {
        String body = request.getReader().lines().collect(Collectors.joining());
        JsonObject json = Json.createReader(new StringReader(body)).readObject();

        int courseId = json.getInt("courseId");
        String dateStr = json.getString("date");
        JsonArray attendances = json.getJsonArray("attendances");

        Date date = Date.valueOf(dateStr);
        int successCount = 0;
        int failCount = 0;

        for (JsonValue val : attendances) {
            JsonObject att = (JsonObject) val;
            int studentId = att.getJsonNumber("studentId").intValue();
            String status = att.getString("status").toUpperCase();

            Attendance attendance = new Attendance(studentId, courseId, date, status);
            try {
                if (attendanceService.recordAttendance(attendance)) {
                    successCount++;
                } else {
                    failCount++;
                }
            } catch (Exception e) {
                failCount++;
                System.err.println("[AttendanceServlet] Error recording bulk attendance: " + e.getMessage());
            }
        }

        response.setStatus(200);
        out.print(Json.createObjectBuilder()
                .add("message", "Bulk recording complete")
                .add("success", successCount)
                .add("failed", failCount)
                .build().toString());
    }

    private void handleGetEnrolledStudents(HttpServletRequest request, HttpServletResponse response, PrintWriter out) {
        String courseIdStr = request.getParameter("courseId");
        if (courseIdStr == null || courseIdStr.isEmpty()) {
            sendError(response, out, 400, "Missing courseId parameter");
            return;
        }
        int courseId = Integer.parseInt(courseIdStr);
        String jsonResponse = attendanceService.getEnrolledStudentsDetails(courseId);
        out.print(jsonResponse);
    }
}
