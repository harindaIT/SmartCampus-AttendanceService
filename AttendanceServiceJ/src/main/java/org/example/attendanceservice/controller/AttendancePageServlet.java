package org.example.attendanceservice.controller;

import org.example.attendanceservice.model.Attendance;
import org.example.attendanceservice.service.AttendanceService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

/**
 * Servlet controller for JSP views.
 * Handles form submissions and forwards to JSP pages.
 * Fetches student/course lists from external services for dynamic dropdowns.
 */
@WebServlet(name = "AttendancePageServlet", urlPatterns = { "/pages/attendance" })
public class AttendancePageServlet extends HttpServlet {

    private final AttendanceService attendanceService = new AttendanceService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null)
            action = "list";

        try {
            switch (action) {
                case "new":
                    populateDropdowns(request);
                    request.getRequestDispatcher("/attendance.jsp").forward(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "list":
                    listAttendance(request, response);
                    break;
                case "student":
                    listByStudent(request, response);
                    break;
                case "course":
                    listByCourse(request, response);
                    break;
                case "byCourse":
                    populateDropdowns(request);
                    // If a course ID was submitted, fetch its attendance
                    String cIdStr = request.getParameter("id");
                    if (cIdStr != null && !cIdStr.isEmpty()) {
                        int courseId = Integer.parseInt(cIdStr);
                        List<Attendance> attendanceList = attendanceService.getAttendanceByCourse(courseId);
                        request.setAttribute("attendanceList", attendanceList);
                        request.setAttribute("selectedCourseId", courseId);
                    }
                    request.getRequestDispatcher("/attendance-course.jsp").forward(request, response);
                    break;
                case "summary":
                    showSummary(request, response);
                    break;
                case "delete":
                    deleteAttendance(request, response);
                    break;
                default:
                    listAttendance(request, response);
            }
        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/attendance-list.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null)
            action = "";

        try {
            switch (action) {
                case "record":
                    recordAttendance(request, response);
                    break;
                case "update":
                    updateAttendance(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/pages/attendance?action=list");
            }
        } catch (SQLException e) {
            populateDropdowns(request);
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/attendance.jsp").forward(request, response);
        }
    }

    // ==================== Helper ====================

    /**
     * Fetch student and course lists from external services and set as request
     * attributes.
     */
    private void populateDropdowns(HttpServletRequest request) {
        request.setAttribute("studentsJson", attendanceService.fetchStudentList());
        request.setAttribute("coursesJson", attendanceService.fetchCourseList());
    }

    // ==================== Action Handlers ====================

    private void listAttendance(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        populateDropdowns(request);
        List<Attendance> attendanceList = attendanceService.getAllAttendance();
        request.setAttribute("attendanceList", attendanceList);
        request.getRequestDispatcher("/attendance-list.jsp").forward(request, response);
    }

    private void listByStudent(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        populateDropdowns(request);
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            int studentId = Integer.parseInt(idStr);
            List<Attendance> attendanceList = attendanceService.getAttendanceByStudent(studentId);
            request.setAttribute("attendanceList", attendanceList);
            request.setAttribute("filterType", "Student ID: " + studentId);
        }
        request.getRequestDispatcher("/attendance-list.jsp").forward(request, response);
    }

    private void listByCourse(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        populateDropdowns(request);
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            int courseId = Integer.parseInt(idStr);
            List<Attendance> attendanceList = attendanceService.getAttendanceByCourse(courseId);
            request.setAttribute("attendanceList", attendanceList);
            request.setAttribute("filterType", "Course ID: " + courseId);
        }
        request.getRequestDispatcher("/attendance-list.jsp").forward(request, response);
    }

    private void showSummary(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        populateDropdowns(request);
        String studentIdStr = request.getParameter("studentId");
        String courseIdStr = request.getParameter("courseId");

        if (studentIdStr != null && courseIdStr != null && !studentIdStr.isEmpty() && !courseIdStr.isEmpty()) {
            int studentId = Integer.parseInt(studentIdStr);
            int courseId = Integer.parseInt(courseIdStr);
            Map<String, Object> summary = attendanceService.getAttendanceSummary(studentId, courseId);
            request.setAttribute("summary", summary);
            request.setAttribute("studentId", studentId);
            request.setAttribute("courseId", courseId);
        }
        request.getRequestDispatcher("/attendance-summary.jsp").forward(request, response);
    }

    private void recordAttendance(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        int studentId = Integer.parseInt(request.getParameter("studentId"));
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        String dateStr = request.getParameter("date");
        String status = request.getParameter("status");

        Attendance attendance = new Attendance(studentId, courseId, Date.valueOf(dateStr), status);

        try {
            attendanceService.recordAttendance(attendance);
            populateDropdowns(request);
            request.setAttribute("success", "Attendance recorded successfully!");
        } catch (IllegalArgumentException e) {
            populateDropdowns(request);
            request.setAttribute("error", e.getMessage());
        } catch (SQLException e) {
            populateDropdowns(request);
            if (e.getMessage().contains("Duplicate")) {
                request.setAttribute("error", "Attendance already recorded for this student, course, and date.");
            } else {
                request.setAttribute("error", "Database error: " + e.getMessage());
            }
        }
        request.getRequestDispatcher("/attendance.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Attendance attendance = attendanceService.getAttendanceById(id);
        if (attendance != null) {
            populateDropdowns(request);
            request.setAttribute("attendance", attendance);
            request.getRequestDispatcher("/attendance.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/pages/attendance?action=list");
        }
    }

    private void updateAttendance(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        int id = Integer.parseInt(request.getParameter("id"));
        int studentId = Integer.parseInt(request.getParameter("studentId"));
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        String dateStr = request.getParameter("date");
        String status = request.getParameter("status");

        Attendance attendance = new Attendance(studentId, courseId, Date.valueOf(dateStr), status);
        attendance.setId(id);

        try {
            attendanceService.updateAttendance(attendance);
            response.sendRedirect(request.getContextPath() + "/pages/attendance?action=list");
        } catch (IllegalArgumentException e) {
            populateDropdowns(request);
            request.setAttribute("error", e.getMessage());
            request.setAttribute("attendance", attendance);
            request.getRequestDispatcher("/attendance.jsp").forward(request, response);
        }
    }

    private void deleteAttendance(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        attendanceService.deleteAttendance(id);
        response.sendRedirect(request.getContextPath() + "/pages/attendance?action=list");
    }
}
