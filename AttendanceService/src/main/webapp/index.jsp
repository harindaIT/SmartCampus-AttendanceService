<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Attendance Service - SmartCampus</title>
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

            .hero-section {
                padding: 60px 0 40px;
                text-align: center;
            }

            .hero-section h1 {
                font-size: 2.6rem;
                font-weight: 800;
                background: linear-gradient(135deg, #7c4dff, #448aff);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
            }

            .hero-section p {
                color: #a0a0c0;
                font-size: 1.15rem;
            }

            .card-feature {
                background: rgba(255, 255, 255, 0.05);
                border: 1px solid rgba(255, 255, 255, 0.08);
                border-radius: 16px;
                padding: 32px 24px;
                text-align: center;
                transition: all 0.3s ease;
                text-decoration: none;
                color: inherit;
                display: block;
            }

            .card-feature:hover {
                transform: translateY(-6px);
                background: rgba(124, 77, 255, 0.1);
                border-color: rgba(124, 77, 255, 0.3);
                color: inherit;
                box-shadow: 0 12px 40px rgba(124, 77, 255, 0.15);
            }

            .card-feature .icon {
                width: 64px;
                height: 64px;
                border-radius: 16px;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 18px;
                font-size: 1.6rem;
            }

            .card-feature h5 {
                font-weight: 600;
                margin-bottom: 8px;
            }

            .card-feature p {
                color: #a0a0c0;
                font-size: 0.9rem;
                margin: 0;
            }

            .icon-record {
                background: linear-gradient(135deg, #7c4dff, #536dfe);
                color: #fff;
            }

            .icon-list {
                background: linear-gradient(135deg, #00bcd4, #0097a7);
                color: #fff;
            }

            .icon-course {
                background: linear-gradient(135deg, #e91e63, #c2185b);
                color: #fff;
            }

            .icon-summary {
                background: linear-gradient(135deg, #ff9800, #f57c00);
                color: #fff;
            }

            .icon-api {
                background: linear-gradient(135deg, #4caf50, #388e3c);
                color: #fff;
            }

            .api-section {
                background: rgba(255, 255, 255, 0.03);
                border: 1px solid rgba(255, 255, 255, 0.06);
                border-radius: 16px;
                padding: 32px;
                margin-top: 40px;
            }

            .api-section h3 {
                font-weight: 700;
                margin-bottom: 20px;
            }

            .api-endpoint {
                background: rgba(0, 0, 0, 0.3);
                border-radius: 8px;
                padding: 12px 16px;
                margin-bottom: 8px;
                font-family: 'Courier New', monospace;
                font-size: 0.88rem;
                display: flex;
                align-items: center;
                gap: 12px;
            }

            .method-badge {
                padding: 3px 10px;
                border-radius: 4px;
                font-weight: 700;
                font-size: 0.75rem;
                min-width: 60px;
                text-align: center;
            }

            .method-get {
                background: #2196f3;
                color: #fff;
            }

            .method-post {
                background: #4caf50;
                color: #fff;
            }

            .method-put {
                background: #ff9800;
                color: #fff;
            }

            .method-delete {
                background: #f44336;
                color: #fff;
            }

            footer {
                text-align: center;
                padding: 30px 0;
                color: #606080;
                font-size: 0.85rem;
                margin-top: 60px;
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
                        <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/"><i
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
                        <li class="nav-item"><a class="nav-link"
                                href="${pageContext.request.contextPath}/pages/attendance?action=summary"><i
                                    class="fas fa-chart-bar me-1"></i>Summary</a></li>
                    </ul>
                </div>
            </div>
        </nav>

        <!-- Hero -->
        <div class="container hero-section">
            <h1><i class="fas fa-graduation-cap me-3"></i>SmartCampus</h1>
            <p class="mt-3">Attendance Service — Group 6 Microservice<br>
                <small>Distributed University Management System</small>
            </p>
            <span class="badge bg-secondary mt-2" style="font-size:0.85rem;">
                <i class="fas fa-server me-1"></i>Running on Port 8086
            </span>
        </div>

        <!-- Feature Cards -->
        <div class="container">
            <div class="row g-4">
                <div class="col-md-4 col-lg">
                    <a href="${pageContext.request.contextPath}/pages/attendance?action=new" class="card-feature">
                        <div class="icon icon-record"><i class="fas fa-plus-circle"></i></div>
                        <h5>Record Attendance</h5>
                        <p>Record student attendance for a course session</p>
                    </a>
                </div>
                <div class="col-md-4 col-lg">
                    <a href="${pageContext.request.contextPath}/pages/attendance?action=list" class="card-feature">
                        <div class="icon icon-list"><i class="fas fa-table"></i></div>
                        <h5>View Attendance</h5>
                        <p>Browse and filter all attendance records</p>
                    </a>
                </div>
                <div class="col-md-4 col-lg">
                    <a href="${pageContext.request.contextPath}/pages/attendance?action=byCourse" class="card-feature">
                        <div class="icon icon-course"><i class="fas fa-book-open"></i></div>
                        <h5>By Course</h5>
                        <p>View attendance records filtered by course</p>
                    </a>
                </div>
                <div class="col-md-4 col-lg">
                    <a href="${pageContext.request.contextPath}/pages/attendance?action=summary" class="card-feature">
                        <div class="icon icon-summary"><i class="fas fa-chart-pie"></i></div>
                        <h5>Summary</h5>
                        <p>View attendance statistics and percentages</p>
                    </a>
                </div>
                <div class="col-md-4 col-lg">
                    <a href="${pageContext.request.contextPath}/api/attendance/all" class="card-feature">
                        <div class="icon icon-api"><i class="fas fa-code"></i></div>
                        <h5>JSON API</h5>
                        <p>Access REST API endpoints for integration</p>
                    </a>
                </div>
            </div>

            <!-- API Documentation -->
            <div class="api-section">
                <h3><i class="fas fa-plug me-2"></i>API Endpoints</h3>
                <div class="api-endpoint">
                    <span class="method-badge method-post">POST</span>
                    <span>/api/attendance/record</span>
                </div>
                <div class="api-endpoint">
                    <span class="method-badge method-get">GET</span>
                    <span>/api/attendance/all</span>
                </div>
                <div class="api-endpoint">
                    <span class="method-badge method-get">GET</span>
                    <span>/api/attendance/student?id={studentId}</span>
                </div>
                <div class="api-endpoint">
                    <span class="method-badge method-get">GET</span>
                    <span>/api/attendance/course?id={courseId}</span>
                </div>
                <div class="api-endpoint">
                    <span class="method-badge method-get">GET</span>
                    <span>/api/attendance/summary?studentId={id}&courseId={id}</span>
                </div>
                <div class="api-endpoint">
                    <span class="method-badge method-get">GET</span>
                    <span>/api/attendance/check?studentId={id}&courseId={id}</span>
                </div>
                <div class="api-endpoint">
                    <span class="method-badge method-get">GET</span>
                    <span>/api/attendance/get?id={id}</span>
                </div>
                <div class="api-endpoint">
                    <span class="method-badge method-put">PUT</span>
                    <span>/api/attendance/update</span>
                </div>
                <div class="api-endpoint">
                    <span class="method-badge method-delete">DELETE</span>
                    <span>/api/attendance/delete?id={id}</span>
                </div>
            </div>
        </div>

        <footer>
            <p>&copy; 2026 SmartCampus — Attendance Service (Group 6) | Rwanda Polytechnic</p>
        </footer>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>

    </html>