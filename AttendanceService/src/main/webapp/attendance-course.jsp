<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Attendance by Course - SmartCampus</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
            <style>
                body {
                    background: linear-gradient(135deg, #0f0c29, #302b63, #24243e);
                    min-height: 100vh;
                    color: #e0e0e0;
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                }

                .navbar {
                    background: rgba(15, 12, 41, 0.95) !important;
                    backdrop-filter: blur(10px);
                    border-bottom: 1px solid rgba(255, 255, 255, 0.08);
                }

                .navbar-brand {
                    font-weight: 700;
                    font-size: 1.4rem;
                }

                .navbar-brand i {
                    color: #7c4dff;
                }

                .content-card {
                    background: rgba(255, 255, 255, 0.05);
                    border: 1px solid rgba(255, 255, 255, 0.1);
                    border-radius: 16px;
                    padding: 32px;
                    margin: 30px auto;
                }

                .content-card h2 {
                    font-weight: 700;
                    margin-bottom: 24px;
                    background: linear-gradient(135deg, #7c4dff, #448aff);
                    -webkit-background-clip: text;
                    background-clip: text;
                    -webkit-text-fill-color: transparent;
                }

                .filter-bar {
                    background: rgba(0, 0, 0, 0.2);
                    border-radius: 12px;
                    padding: 16px 20px;
                    margin-bottom: 24px;
                }

                .filter-bar .form-select {
                    background: rgba(255, 255, 255, 0.08);
                    border: 1px solid rgba(255, 255, 255, 0.15);
                    color: #e0e0e0;
                    border-radius: 8px;
                }

                .filter-bar .form-select:focus {
                    border-color: #7c4dff;
                    box-shadow: 0 0 0 3px rgba(124, 77, 255, 0.2);
                    background: rgba(255, 255, 255, 0.12);
                    color: #e0e0e0;
                }

                .filter-bar .form-select option {
                    background: #1a1a2e;
                    color: #e0e0e0;
                }

                .filter-bar .btn {
                    border-radius: 8px;
                    font-weight: 600;
                }

                .table-dark {
                    --bs-table-bg: rgba(0, 0, 0, 0.2);
                    --bs-table-border-color: rgba(255, 255, 255, 0.06);
                    --bs-table-hover-bg: rgba(124, 77, 255, 0.1);
                }

                .table-dark thead th {
                    background: rgba(124, 77, 255, 0.15);
                    font-weight: 600;
                    font-size: 0.85rem;
                    text-transform: uppercase;
                    letter-spacing: 0.5px;
                    border-bottom: 2px solid rgba(124, 77, 255, 0.3);
                }

                .badge-present {
                    background: #2e7d32;
                }

                .badge-absent {
                    background: #c62828;
                }

                .badge-late {
                    background: #e65100;
                }

                .badge-verified {
                    background: #00897b;
                    color: white;
                }

                .badge-unverified {
                    background: #757575;
                    color: white;
                }

                .btn-action {
                    padding: 4px 10px;
                    border-radius: 6px;
                    font-size: 0.8rem;
                    margin-right: 4px;
                }

                .btn-edit {
                    background: rgba(33, 150, 243, 0.2);
                    color: #64b5f6;
                    border: 1px solid rgba(33, 150, 243, 0.3);
                }

                .btn-edit:hover {
                    background: rgba(33, 150, 243, 0.3);
                    color: #90caf9;
                }

                .btn-del {
                    background: rgba(244, 67, 54, 0.2);
                    color: #ef9a9a;
                    border: 1px solid rgba(244, 67, 54, 0.3);
                }

                .btn-del:hover {
                    background: rgba(244, 67, 54, 0.3);
                    color: #ffcdd2;
                }

                .empty-state {
                    text-align: center;
                    padding: 60px 20px;
                    color: #808090;
                }

                .empty-state i {
                    font-size: 3rem;
                    margin-bottom: 16px;
                }
            </style>
        </head>

        <body>
            <!-- Navbar -->
            <nav class="navbar navbar-expand-lg navbar-dark">
                <div class="container">
                    <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                        <i class="fas fa-clipboard-check me-2"></i>Attendance Service
                    </a>
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navMenu">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="collapse navbar-collapse" id="navMenu">
                        <ul class="navbar-nav ms-auto">
                            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/"><i
                                        class="fas fa-home me-1"></i>Home</a></li>
                            <li class="nav-item"><a class="nav-link"
                                    href="${pageContext.request.contextPath}/pages/attendance?action=new"><i
                                        class="fas fa-plus me-1"></i>Record</a></li>
                            <li class="nav-item"><a class="nav-link"
                                    href="${pageContext.request.contextPath}/pages/attendance?action=list"><i
                                        class="fas fa-list me-1"></i>View All</a></li>
                            <li class="nav-item"><a class="nav-link active"
                                    href="${pageContext.request.contextPath}/pages/attendance?action=byCourse"><i
                                        class="fas fa-book me-1"></i>By Course</a></li>
                            <li class="nav-item"><a class="nav-link"
                                    href="${pageContext.request.contextPath}/pages/attendance?action=summary"><i
                                        class="fas fa-chart-bar me-1"></i>Summary</a></li>
                        </ul>
                    </div>
                </div>
            </nav>

            <div class="container">
                <div class="content-card">
                    <h2><i class="fas fa-book-open me-2"></i>View Attendance by Course</h2>

                    <!-- Course Selection -->
                    <div class="filter-bar">
                        <form class="row g-2 align-items-end" method="get"
                            action="${pageContext.request.contextPath}/pages/attendance">
                            <input type="hidden" name="action" value="byCourse">
                            <div class="col-md-8">
                                <label class="form-label small">Select Course</label>
                                <select class="form-select form-select-sm" id="courseSelect" name="id" required>
                                    <option value="">-- Select Course --</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <button type="submit" class="btn btn-sm w-100"
                                    style="background:linear-gradient(135deg,#00bcd4,#0097a7);color:#fff;">
                                    <i class="fas fa-search me-1"></i>View Attendance
                                </button>
                            </div>
                        </form>
                    </div>

                    <!-- Table -->
                    <c:choose>
                        <c:when test="${not empty attendanceList}">
                            <div class="alert alert-info py-2">
                                <i class="fas fa-filter me-2"></i>Showing attendance for Course ID:
                                <strong>${selectedCourseId}</strong>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-dark table-hover">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Student ID</th>
                                            <th>Date</th>
                                            <th>Status</th>
                                            <th>Recorded At</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="att" items="${attendanceList}">
                                            <tr>
                                                <td>${att.id}</td>
                                                <td><i class="fas fa-user-graduate me-1"></i>${att.studentId}</td>
                                                <td>${att.date}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${att.status == 'PRESENT'}">
                                                            <span class="badge badge-present">PRESENT</span>
                                                        </c:when>
                                                        <c:when test="${att.status == 'ABSENT'}">
                                                            <span class="badge badge-absent">ABSENT</span>
                                                        </c:when>
                                                        <c:when test="${att.status == 'LATE'}">
                                                            <span class="badge badge-late">LATE</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">${att.status}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td><small>${att.recordedAt}</small></td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/pages/attendance?action=edit&id=${att.id}"
                                                        class="btn btn-action btn-edit">
                                                        <i class="fas fa-edit"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/pages/attendance?action=delete&id=${att.id}"
                                                        class="btn btn-action btn-del"
                                                        onclick="return confirm('Delete this record?');">
                                                        <i class="fas fa-trash"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>
                        <c:when test="${not empty selectedCourseId}">
                            <div class="empty-state">
                                <i class="fas fa-inbox d-block"></i>
                                <h5>No Attendance Records Found</h5>
                                <p>No attendance recorded for this course yet.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <i class="fas fa-hand-pointer d-block"></i>
                                <h5>Select a Course</h5>
                                <p>Choose a course from the dropdown above to view its attendance records.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                // Populate course dropdown from Course Service JSON
                (function () {
                    var coursesJson = '${coursesJson}';
                    var selectedCourseId = '${selectedCourseId}';
                    var courseSelect = document.getElementById('courseSelect');

                    try {
                        var courses = JSON.parse(coursesJson);
                        if (courses.length > 0) {
                            courses.forEach(function (c) {
                                var opt = document.createElement('option');
                                opt.value = c.id || c.courseId || '';
                                var name = c.name || c.courseName || c.title || ('Course ' + opt.value);
                                var code = c.code || c.courseCode || '';
                                opt.textContent = code ? (name + ' (' + code + ')') : name;
                                if (opt.value == selectedCourseId) opt.selected = true;
                                courseSelect.appendChild(opt);
                            });
                        } else {
                            courseSelect.outerHTML = '<input type="number" class="form-control form-control-sm" id="courseSelect" name="id" value="' + selectedCourseId + '" placeholder="Enter Course ID (Service offline)" required min="1">';
                        }
                    } catch (e) {
                        courseSelect.outerHTML = '<input type="number" class="form-control form-control-sm" id="courseSelect" name="id" value="' + selectedCourseId + '" placeholder="Enter Course ID (Service offline)" required min="1">';
                    }
                })();
            </script>
        </body>

        </html>