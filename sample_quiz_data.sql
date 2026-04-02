-- ===========================================
-- QuizApp: Expanded Dummy Data Setup
-- Each quiz now has 5 questions with 4 options each
-- Teachers: Alice & Bob | Students: Charlie & Diana
-- ===========================================

-- Disable foreign key checks for truncation
SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE question_answers;
TRUNCATE TABLE quiz_attempts;
TRUNCATE TABLE question_options;
TRUNCATE TABLE questions;
TRUNCATE TABLE quizzes;
TRUNCATE TABLE students;
TRUNCATE TABLE teachers;
TRUNCATE TABLE users;

-- Enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- ===========================================
-- USERS
-- ===========================================
INSERT INTO users (id, name, email, password, role, phone, created_at, updated_at) VALUES
(1, 'Alice Teacher', 'alice.teacher@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'teacher', '1111111111', NOW(), NOW()),
(2, 'Bob Teacher', 'bob.teacher@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'teacher', '2222222222', NOW(), NOW()),
(3, 'Charlie Student', 'charlie.student@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'student', '3333333333', NOW(), NOW()),
(4, 'Diana Student', 'diana.student@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'student', '4444444444', NOW(), NOW());

-- ===========================================
-- TEACHERS
-- ===========================================
INSERT INTO teachers (id, user_id, department, bio, created_at, updated_at) VALUES
(1, 1, 'Computer Science', 'Expert in web development', NOW(), NOW()),
(2, 2, 'Mathematics', 'Experienced in teaching math', NOW(), NOW());

-- ===========================================
-- STUDENTS
-- ===========================================
INSERT INTO students (id, user_id, student_id, enrollment_date, created_at, updated_at) VALUES
(1, 3, 'STU001', NOW(), NOW(), NOW()),
(2, 4, 'STU002', NOW(), NOW(), NOW());

-- ===========================================
-- QUIZZES
-- ===========================================
INSERT INTO quizzes (id, teacher_id, title, description, duration, total_marks, passing_percentage, is_published, shuffle_questions, show_results_immediately, created_at, updated_at) VALUES
(1, 1, 'Vue.js Basics', 'Test your Vue.js knowledge', 30, 25, 70, 1, 1, 0, NOW(), NOW()),
(2, 2, 'Math Basics', 'Test your basic math skills', 45, 25, 60, 1, 1, 1, NOW(), NOW());

-- ===========================================
-- QUESTIONS
-- ===========================================
-- Quiz 1: Vue.js
INSERT INTO questions (id, quiz_id, question_text, question_type, marks, `order`, created_at, updated_at) VALUES
(1, 1, 'What is Vue.js?', 'multiple_choice', 5, 1, NOW(), NOW()),
(2, 1, 'Which directive is used for two-way data binding?', 'multiple_choice', 5, 2, NOW(), NOW()),
(3, 1, 'Vue.js is reactive.', 'multiple_choice', 5, 3, NOW(), NOW()),
(4, 1, 'The v-for directive is used for?', 'multiple_choice', 5, 4, NOW(), NOW()),
(5, 1, 'Which lifecycle hook runs when component is mounted?', 'multiple_choice', 5, 5, NOW(), NOW());

-- Quiz 2: Math
INSERT INTO questions (id, quiz_id, question_text, question_type, marks, `order`, created_at, updated_at) VALUES
(6, 2, '2 + 2 = ?', 'multiple_choice', 5, 1, NOW(), NOW()),
(7, 2, '5 * 3 = ?', 'multiple_choice', 5, 2, NOW(), NOW()),
(8, 2, 'Square root of 16?', 'multiple_choice', 5, 3, NOW(), NOW()),
(9, 2, '10 / 2 = ?', 'multiple_choice', 5, 4, NOW(), NOW()),
(10, 2, '7 - 3 = ?', 'multiple_choice', 5, 5, NOW(), NOW());

-- ===========================================
-- QUESTION OPTIONS
-- ===========================================
-- Quiz 1 Options
INSERT INTO question_options (question_id, option_text, is_correct, `order`, created_at, updated_at) VALUES
(1, 'A JavaScript framework', 1, 1, NOW(), NOW()),
(1, 'A CSS library', 0, 2, NOW(), NOW()),
(1, 'A database', 0, 3, NOW(), NOW()),
(1, 'A backend language', 0, 4, NOW(), NOW()),

(2, 'v-model', 1, 1, NOW(), NOW()),
(2, 'v-if', 0, 2, NOW(), NOW()),
(2, 'v-for', 0, 3, NOW(), NOW()),
(2, 'v-bind', 0, 4, NOW(), NOW()),

(3, 'Vue uses reactive data', 1, 1, NOW(), NOW()),
(3, 'Vue uses static data', 0, 2, NOW(), NOW()),
(3, 'Vue has no reactivity', 0, 3, NOW(), NOW()),
(3, 'Vue is server-side only', 0, 4, NOW(), NOW()),

(4, 'Loop through items', 1, 1, NOW(), NOW()),
(4, 'Conditional rendering', 0, 2, NOW(), NOW()),
(4, 'Two-way binding', 0, 3, NOW(), NOW()),
(4, 'Event handling', 0, 4, NOW(), NOW()),

(5, 'mounted()', 1, 1, NOW(), NOW()),
(5, 'created()', 0, 2, NOW(), NOW()),
(5, 'beforeMount()', 0, 3, NOW(), NOW()),
(5, 'updated()', 0, 4, NOW(), NOW());

-- Quiz 2 Options
INSERT INTO question_options (question_id, option_text, is_correct, `order`, created_at, updated_at) VALUES
(6, '4', 1, 1, NOW(), NOW()),
(6, '3', 0, 2, NOW(), NOW()),
(6, '5', 0, 3, NOW(), NOW()),
(6, '2', 0, 4, NOW(), NOW()),

(7, '15', 1, 1, NOW(), NOW()),
(7, '10', 0, 2, NOW(), NOW()),
(7, '20', 0, 3, NOW(), NOW()),
(7, '8', 0, 4, NOW(), NOW()),

(8, '4', 1, 1, NOW(), NOW()),
(8, '5', 0, 2, NOW(), NOW()),
(8, '3', 0, 3, NOW(), NOW()),
(8, '2', 0, 4, NOW(), NOW()),

(9, '5', 1, 1, NOW(), NOW()),
(9, '4', 0, 2, NOW(), NOW()),
(9, '6', 0, 3, NOW(), NOW()),
(9, '10', 0, 4, NOW(), NOW()),

(10, '4', 1, 1, NOW(), NOW()),
(10, '5', 0, 2, NOW(), NOW()),
(10, '6', 0, 3, NOW(), NOW()),
(10, '3', 0, 4, NOW(), NOW());

-- ===========================================
-- QUIZ ATTEMPTS
-- ===========================================
INSERT INTO quiz_attempts (id, quiz_id, student_id, start_time, end_time, obtained_marks, is_submitted, created_at, updated_at) VALUES
(1, 1, 1, NOW(), NOW(), 20, 1, NOW(), NOW()),  -- Charlie: Vue.js
(2, 2, 1, NOW(), NOW(), 25, 1, NOW(), NOW()),  -- Charlie: Math
(3, 1, 2, NOW(), NOW(), 15, 1, NOW(), NOW()),  -- Diana: Vue.js
(4, 2, 2, NOW(), NOW(), 20, 1, NOW(), NOW());  -- Diana: Math

-- ===========================================
-- QUESTION ANSWERS
-- ===========================================
-- Quiz 1: Vue.js (Charlie)
INSERT INTO question_answers (quiz_attempt_id, question_id, selected_option_id, answer_text, is_correct, marks_obtained, created_at, updated_at) VALUES
(1, 1, 1, NULL, 1, 5, NOW(), NOW()),
(1, 2, 3, NULL, 1, 5, NOW(), NOW()),
(1, 3, 1, NULL, 1, 5, NOW(), NOW()),
(1, 4, 1, NULL, 1, 5, NOW(), NOW()),
(1, 5, 1, NULL, 1, 0, NOW(), NOW()),

-- Quiz 1: Vue.js (Diana)
(3, 1, 1, NULL, 1, 5, NOW(), NOW()),
(3, 2, 2, NULL, 0, 0, NOW(), NOW()),
(3, 3, 1, NULL, 1, 5, NOW(), NOW()),
(3, 4, 2, NULL, 0, 0, NOW(), NOW()),
(3, 5, 3, NULL, 0, 0, NOW(), NOW()),

-- Quiz 2: Math (Charlie)
(2, 6, 1, NULL, 1, 5, NOW(), NOW()),
(2, 7, 1, NULL, 1, 5, NOW(), NOW()),
(2, 8, 1, NULL, 1, 5, NOW(), NOW()),
(2, 9, 1, NULL, 1, 5, NOW(), NOW()),
(2, 10, 1, NULL, 1, 5, NOW(), NOW()),

-- Quiz 2: Math (Diana)
(4, 6, 1, NULL, 1, 5, NOW(), NOW()),
(4, 7, 2, NULL, 0, 0, NOW(), NOW()),
(4, 8, 1, NULL, 1, 5, NOW(), NOW()),
(4, 9, 1, NULL, 1, 5, NOW(), NOW()),
(4, 10, 1, NULL, 1, 5, NOW(), NOW());