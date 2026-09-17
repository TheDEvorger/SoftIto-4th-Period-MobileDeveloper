CREATE TABLE IF NOT EXISTS students (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    student_number TEXT UNIQUE NOT NULL,
    full_name TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS courses (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    course_code TEXT UNIQUE NOT NULL,
    title TEXT NOT NULL,
    credit INTEGER NOT NULL CHECK(credit > 0)
);


CREATE TABLE IF NOT EXISTS enrollments (
    student_id INTEGER NOT NULL, -- student_id
    course_id INTEGER NOT NULL,  -- course_id
    enrollment_code DATETIME DEFAULT CURRENT_TIMESTAMP,
    final_grade INTEGER CHECK(final_grade BETWEEN 0 AND 100),
            
    PRIMARY KEY(student_id, course_id),

    FOREIGN KEY(student_id)
        REFERENCES students(id)
        ON DELETE CASCADE,

    FOREIGN KEY(course_id)
        REFERENCES courses(id)
        ON DELETE RESTRICT
);