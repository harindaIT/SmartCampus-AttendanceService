<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Record Attendance - SmartCampus</title>
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

                .form-card {
                    background: rgba(255, 255, 255, 0.05);
                    border: 1px solid rgba(255, 255, 255, 0.1);
                    border-radius: 16px;
                    padding: 40px;
                    max-width: 600px;
                    margin: 40px auto;
                }

                .form-card h2 {
                    font-weight: 700;
                    margin-bottom: 30px;
                    background: linear-gradient(135deg, #7c4dff, #448aff);
                    -webkit-background-clip: text;
                    background-clip: text;
                    -webkit-text-fill-color: transparent;
                }

                .form-label {
                    font-weight: 500;
                    color: #c0c0d0;
                }

                .form-control,
                .form-select {
                    background: rgba(255, 255, 255, 0.08);
                    border: 1px solid rgba(255, 255, 255, 0.15);
                    color: #e0e0e0;
                    border-radius: 10px;
                    padding: 10px 14px;
                }

                .form-control:focus,
                .form-select:focus {
                    background: rgba(255, 255, 255, 0.12);
                    border-color: #7c4dff;
                    box-shadow: 0 0 0 3px rgba(124, 77, 255, 0.2);
                    color: #e0e0e0;
                }

                .form-control::placeholder {
                    color: #808090;
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
                    font-size: 1rem;
                }

                .btn-primary:hover {
                    background: linear-gradient(135deg, #6a3de8, #4a60e8);
                    transform: translateY(-2px);
                    box-shadow: 0 6px 20px rgba(124, 77, 255, 0.3);
                }

                .btn-secondary {
                    background: rgba(255, 255, 255, 0.08);
                    border: 1px solid rgba(255, 255, 255, 0.15);
                    border-radius: 10px;
                    padding: 12px 32px;
                    font-weight: 600;
                }

                .alert {
                    border-radius: 10px;
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
                            <li class="nav-item"><a class="nav-link active"
                                    href="${pageContext.request.contextPath}/pages/attendance?action=new"><i
                                        class="fas fa-plus me-1"></i>Record</a></li>
                            <li class="nav-item"><a class="nav-link"
                                    href="${pageContext.request.contextPath}/pages/attendance?action=list"><i
                                        class="fas fa-list me-1"></i>View All</a></li>
                            <li class="nav-item"><a class="nav-link"
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
                <div class="form-card">
                    <c:choose>
                        <c:when test="${not empty attendance}">
                            <h2><i class="fas fa-edit me-2"></i>Edit Attendance</h2>
                        </c:when>
                        <c:otherwise>
                            <h2><i class="fas fa-plus-circle me-2"></i>Record Attendance</h2>
                        </c:otherwise>
                    </c:choose>

                    <!-- Success Message -->
                    <c:if test="${not empty success}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle me-2"></i>${success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <!-- Error Message -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <form method="post" action="${pageContext.request.contextPath}/pages/attendance">
                        <c:choose>
                            <c:when test="${not empty attendance}">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="id" value="${attendance.id}">
                            </c:when>
                            <c:otherwise>
                                <input type="hidden" name="action" value="record">
                            </c:otherwise>
                        </c:choose>

                        <div class="mb-3">
                            <label for="courseId" class="form-label"><i class="fas fa-book me-1"></i>Course</label>
                            <select class="form-select" id="courseId" name="courseId" required
                                onchange="loadEnrolledStudents()">
                                <option value="">-- Select Course --</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label for="date" class="form-label"><i class="fas fa-calendar me-1"></i>Date</label>
                            <input type="date" class="form-control" id="date" name="date"
                                value="${not empty attendance ? attendance.date : ''}" required>
                        </div>

                        <div id="studentTableContainer" style="display:none;">
                            <h5 class="mt-4 mb-3"><i class="fas fa-users me-2"></i>Enrolled Students</h5>
                            <div class="table-responsive">
                                <table class="table table-dark table-sm" id="studentTable">
                                    <thead>
                                        <tr>
                                            <th>Student Name</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody id="studentTableBody">
                                        <!-- Populated via AJAX -->
                                    </tbody>
                                </table>
                            </div>

                            <div class="mt-3 mb-4">
                                <button type="button" class="btn btn-sm btn-outline-info" onclick="markAllPresent()">
                                    <i class="fas fa-check-double me-1"></i>Mark All Present
                                </button>
                            </div>

                            <div class="d-flex gap-3">
                                <button type="button" id="submitBulkBtn" class="btn btn-primary flex-grow-1"
                                    onclick="submitBulkAttendance()">
                                    <i class="fas fa-save me-2"></i>Submit Attendance
                                </button>
                                <a href="${pageContext.request.contextPath}/pages/attendance?action=list"
                                    class="btn btn-secondary">
                                    <i class="fas fa-times me-1"></i>Cancel
                                </a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                // Populate course dropdown from Course Service JSON
                (function () {
                    var coursesJson = `${coursesJson}`; // Use backticks to avoid quote issues
                    var selectedCourseId = '${not empty attendance ? attendance.courseId : ""}';
                    var courseSelect = document.getElementById('courseId');

                    if (!courseSelect) return;

                    try {
                        if (!coursesJson || coursesJson === 'null' || coursesJson === '[]') {
                            // Use dummy data if JSON is empty or null
                            coursesJson = '[{"id":101,"name":"Java Programming","code":"CS101"},{"id":102,"name":"PHP Web Development","code":"CS202"}]';
                        }

                        var courses = JSON.parse(coursesJson);
                        if (courses && courses.length > 0) {
                            courses.forEach(function (c) {
                                var opt = document.createElement('option');
                                opt.value = c.id || c.courseId || '';
                                var name = c.name || c.courseName || c.title || ('Course ' + opt.value);
                                var code = c.code || c.courseCode || '';
                                opt.textContent = code ? (name + ' (' + code + ')') : name;
                                if (opt.value == selectedCourseId) opt.selected = true;
                                courseSelect.appendChild(opt);
                            });
                        }
                    } catch (e) {
                        console.error("Error parsing courses JSON:", e);
                    }
                })();

                function loadEnrolledStudents() {
                    const courseId = document.getElementById('courseId').value;
                    const container = document.getElementById('studentTableContainer');
                    const tbody = document.getElementById('studentTableBody');

                    if (!courseId) {
                        container.style.display = 'none';
                        return;
                    }

                    tbody.innerHTML = '<tr><td colspan="2" class="text-center"><div class="spinner-border spinner-border-sm text-primary"></div> Loading...</td></tr>';
                    container.style.display = 'block';

                    fetch('${pageContext.request.contextPath}/api/attendance/enrolled-students?courseId=' + courseId)
                        .then(response => response.json())
                        .then(data => {
                            tbody.innerHTML = '';
                            if (data.length === 0) {
                                tbody.innerHTML = '<tr><td colspan="2" class="text-center text-muted">No students enrolled.</td></tr>';
                            } else {
                                data.forEach(student => {
                                    const studentId = student.studentId || student.id;
                                    const name = student.name || student.studentName || ('Student ' + studentId);

                                    const row = document.createElement('tr');
                                    row.innerHTML = `
                                        <td>\${name} <small class="text-muted">(ID: \${studentId})</small></td>
                                        <td>
                                            <div class="btn-group btn-group-sm" role="group">
                                                <input type="radio" class="btn-check" name="status_\${studentId}" id="p_\${studentId}" value="PRESENT" checked>
                                                <label class="btn btn-outline-success" for="p_\${studentId}">P</label>
                                                
                                                <input type="radio" class="btn-check" name="status_\${studentId}" id="a_\${studentId}" value="ABSENT">
                                                <label class="btn btn-outline-danger" for="a_\${studentId}">A</label>
                                                
                                                <input type="radio" class="btn-check" name="status_\${studentId}" id="l_\${studentId}" value="LATE">
                                                <label class="btn btn-outline-warning" for="l_\${studentId}">L</label>
                                            </div>
                                            <input type="hidden" class="student-id-input" value="\${studentId}">
                                        </td>
                                    `;
                                    tbody.appendChild(row);
                                });
                            }
                        })
                        .catch(err => {
                            tbody.innerHTML = '<tr><td colspan="2" class="text-center text-danger">Error loading students.</td></tr>';
                        });
                }

                function markAllPresent() {
                    document.querySelectorAll('input[value="PRESENT"]').forEach(radio => radio.checked = true);
                }

                function submitBulkAttendance() {
                    const courseId = document.getElementById('courseId').value;
                    const date = document.getElementById('date').value;

                    if (!date) {
                        alert('Please select a date');
                        return;
                    }

                    const attendances = [];
                    document.querySelectorAll('.student-id-input').forEach(input => {
                        const studentId = parseInt(input.value);
                        const status = document.querySelector(`input[name="status_\${studentId}"]:checked`).value;
                        attendances.push({ studentId, status });
                    });

                    if (attendances.length === 0) {
                        alert('No students to record attendance for.');
                        return;
                    }

                    const payload = {
                        courseId: parseInt(courseId),
                        date: date,
                        attendances: attendances
                    };

                    const btn = document.getElementById('submitBulkBtn');
                    btn.disabled = true;
                    btn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Submitting...';

                    fetch('${pageContext.request.contextPath}/api/attendance/bulk-record', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify(payload)
                    })
                        .then(response => response.json())
                        .then(data => {
                            alert(data.message + '\nSuccess: ' + data.success + '\nFailed: ' + data.failed);
                            window.location.href = '${pageContext.request.contextPath}/pages/attendance?action=list';
                        })
                        .catch(err => {
                            alert('Error submitting attendance: ' + err);
                            btn.disabled = false;
                            btn.innerHTML = '<i class="fas fa-save me-2"></i>Submit Attendance';
                        });
                }
            </script>
        </body>

        </html>