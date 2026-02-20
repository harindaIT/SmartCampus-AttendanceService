<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Attendance Summary - SmartCampus</title>
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
                    padding: 40px;
                    max-width: 700px;
                    margin: 40px auto;
                }

                .content-card h2 {
                    font-weight: 700;
                    margin-bottom: 30px;
                    background: linear-gradient(135deg, #7c4dff, #448aff);
                    -webkit-background-clip: text;
                    -webkit-text-fill-color: transparent;
                }

                .form-label {
                    font-weight: 500;
                    color: #c0c0d0;
                }

                .form-select {
                    background: rgba(255, 255, 255, 0.08);
                    border: 1px solid rgba(255, 255, 255, 0.15);
                    color: #e0e0e0;
                    border-radius: 10px;
                    padding: 10px 14px;
                }

                .form-select:focus {
                    background: rgba(255, 255, 255, 0.12);
                    border-color: #7c4dff;
                    box-shadow: 0 0 0 3px rgba(124, 77, 255, 0.2);
                    color: #e0e0e0;
                }

                .form-select option {
                    background: #1a1a2e;
                    color: #e0e0e0;
                }

                .btn-primary {
                    background: linear-gradient(135deg, #7c4dff, #536dfe);
                    border: none;
                    padding: 12px 32px;
                    border-radius: 10px;
                    font-weight: 600;
                }

                .btn-primary:hover {
                    background: linear-gradient(135deg, #6a3de8, #4a60e8);
                    transform: translateY(-2px);
                }

                .stat-card {
                    background: rgba(0, 0, 0, 0.25);
                    border-radius: 14px;
                    padding: 24px;
                    text-align: center;
                    border: 1px solid rgba(255, 255, 255, 0.06);
                }

                .stat-card .stat-value {
                    font-size: 2.4rem;
                    font-weight: 800;
                    line-height: 1.1;
                }

                .stat-card .stat-label {
                    font-size: 0.85rem;
                    color: #a0a0b0;
                    margin-top: 6px;
                    text-transform: uppercase;
                    letter-spacing: 0.5px;
                }

                .stat-total .stat-value {
                    color: #64b5f6;
                }

                .stat-present .stat-value {
                    color: #66bb6a;
                }

                .stat-absent .stat-value {
                    color: #ef5350;
                }

                .stat-late .stat-value {
                    color: #ffa726;
                }

                .progress-ring {
                    margin: 24px auto;
                    text-align: center;
                }

                .percentage-display {
                    font-size: 3.5rem;
                    font-weight: 800;
                    text-align: center;
                    margin: 20px 0;
                }

                .percentage-label {
                    text-align: center;
                    color: #a0a0b0;
                    font-size: 0.9rem;
                }

                .eligible-badge {
                    display: inline-block;
                    padding: 8px 24px;
                    border-radius: 20px;
                    font-weight: 700;
                    font-size: 1rem;
                    margin-top: 12px;
                }

                .eligible-yes {
                    background: rgba(46, 125, 50, 0.3);
                    color: #66bb6a;
                    border: 1px solid rgba(46, 125, 50, 0.4);
                }

                .eligible-no {
                    background: rgba(198, 40, 40, 0.3);
                    color: #ef5350;
                    border: 1px solid rgba(198, 40, 40, 0.4);
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
                            <li class="nav-item"><a class="nav-link"
                                    href="${pageContext.request.contextPath}/pages/attendance?action=byCourse"><i
                                        class="fas fa-book me-1"></i>By Course</a></li>
                            <li class="nav-item"><a class="nav-link active"
                                    href="${pageContext.request.contextPath}/pages/attendance?action=summary"><i
                                        class="fas fa-chart-bar me-1"></i>Summary</a></li>
                        </ul>
                    </div>
                </div>
            </nav>

            <div class="container">
                <div class="content-card">
                    <h2><i class="fas fa-chart-pie me-2"></i>Attendance Summary</h2>

                    <!-- Query Form -->
                    <form method="get" action="${pageContext.request.contextPath}/pages/attendance" class="mb-4">
                        <input type="hidden" name="action" value="summary">
                        <div class="row g-3">
                            <div class="col-md-5">
                                <label for="studentId" class="form-label"><i
                                        class="fas fa-user-graduate me-1"></i>Student</label>
                                <select class="form-select" id="studentId" name="studentId" required>
                                    <option value="">-- Select Student --</option>
                                </select>
                            </div>
                            <div class="col-md-5">
                                <label for="courseId" class="form-label"><i class="fas fa-book me-1"></i>Course</label>
                                <select class="form-select" id="courseId" name="courseId" required>
                                    <option value="">-- Select Course --</option>
                                </select>
                            </div>
                            <div class="col-md-2 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary w-100">
                                    <i class="fas fa-search"></i>
                                </button>
                            </div>
                        </div>
                    </form>

                    <!-- Summary Results -->
                    <c:if test="${not empty summary}">
                        <hr style="border-color:rgba(255,255,255,0.1);">

                        <!-- Percentage Display -->
                        <div class="progress-ring">
                            <c:set var="pct" value="${summary.percentage}" />
                            <div class="percentage-display" style="color: ${pct >= 75 ? '#66bb6a' : '#ef5350'};">
                                ${summary.percentage}%
                            </div>
                            <div class="percentage-label">Attendance Rate</div>
                            <div class="text-center mt-2">
                                <c:choose>
                                    <c:when test="${pct >= 75}">
                                        <span class="eligible-badge eligible-yes">
                                            <i class="fas fa-check-circle me-1"></i>ELIGIBLE
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="eligible-badge eligible-no">
                                            <i class="fas fa-times-circle me-1"></i>NOT ELIGIBLE
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <small class="text-muted d-block mt-1">Minimum 75% required for eligibility</small>
                        </div>

                        <!-- Stat Cards -->
                        <div class="row g-3 mt-3">
                            <div class="col-6 col-md-3">
                                <div class="stat-card stat-total">
                                    <div class="stat-value">${summary.totalClasses}</div>
                                    <div class="stat-label">Total</div>
                                </div>
                            </div>
                            <div class="col-6 col-md-3">
                                <div class="stat-card stat-present">
                                    <div class="stat-value">${summary.present}</div>
                                    <div class="stat-label">Present</div>
                                </div>
                            </div>
                            <div class="col-6 col-md-3">
                                <div class="stat-card stat-absent">
                                    <div class="stat-value">${summary.absent}</div>
                                    <div class="stat-label">Absent</div>
                                </div>
                            </div>
                            <div class="col-6 col-md-3">
                                <div class="stat-card stat-late">
                                    <div class="stat-value">${summary.late}</div>
                                    <div class="stat-label">Late</div>
                                </div>
                            </div>
                        </div>

                        <!-- Summary Info -->
                        <div class="text-center mt-4" style="color:#808090; font-size:0.85rem;">
                            <i class="fas fa-info-circle me-1"></i>
                            Student ID: <strong>${studentId}</strong> | Course ID: <strong>${courseId}</strong>
                        </div>
                    </c:if>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                // Populate student dropdown
                (function () {
                    var studentsJson = '${studentsJson}';
                    var selectedStudentId = '${not empty studentId ? studentId : ""}';
                    var studentSelect = document.getElementById('studentId');

                    try {
                        var students = JSON.parse(studentsJson);
                        if (students.length > 0) {
                            students.forEach(function (s) {
                                var opt = document.createElement('option');
                                opt.value = s.id || s.studentId || '';
                                opt.textContent = s.name || s.names || s.firstName || ('Student ' + opt.value);
                                if (opt.value == selectedStudentId) opt.selected = true;
                                studentSelect.appendChild(opt);
                            });
                        } else {
                            studentSelect.outerHTML = '<input type="number" class="form-select" id="studentId" name="studentId" value="' + selectedStudentId + '" placeholder="Enter Student ID" required min="1">';
                        }
                    } catch (e) {
                        studentSelect.outerHTML = '<input type="number" class="form-select" id="studentId" name="studentId" value="' + selectedStudentId + '" placeholder="Enter Student ID" required min="1">';
                    }
                })();

                // Populate course dropdown
                (function () {
                    var coursesJson = '${coursesJson}';
                    var selectedCourseId = '${not empty courseId ? courseId : ""}';
                    var courseSelect = document.getElementById('courseId');

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
                            courseSelect.outerHTML = '<input type="number" class="form-select" id="courseId" name="courseId" value="' + selectedCourseId + '" placeholder="Enter Course ID" required min="1">';
                        }
                    } catch (e) {
                        courseSelect.outerHTML = '<input type="number" class="form-select" id="courseId" name="courseId" value="' + selectedCourseId + '" placeholder="Enter Course ID" required min="1">';
                    }
                })();
            </script>
        </body>

        </html>