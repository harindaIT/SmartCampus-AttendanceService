-- =============================================
-- Attendance Service Database Script
-- SmartCampus - Group 6
-- =============================================

CREATE DATABASE IF NOT EXISTS attendance_service_db;
USE attendance_service_db;

-- Attendance table
CREATE TABLE IF NOT EXISTS attendance (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    date DATE NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('PRESENT', 'ABSENT', 'LATE')),
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(student_id, course_id, date)
);

-- Sample data for testing
INSERT INTO attendance (student_id, course_id, date, status) VALUES
(1, 101, '2026-02-10', 'PRESENT'),
(1, 101, '2026-02-11', 'PRESENT'),
(1, 101, '2026-02-12', 'ABSENT'),
(1, 101, '2026-02-13', 'PRESENT'),
(1, 101, '2026-02-14', 'LATE'),
(2, 101, '2026-02-10', 'PRESENT'),
(2, 101, '2026-02-11', 'ABSENT'),
(2, 102, '2026-02-10', 'PRESENT'),
(3, 102, '2026-02-10', 'PRESENT'),
(3, 102, '2026-02-11', 'PRESENT');
