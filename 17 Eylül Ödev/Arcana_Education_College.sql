PRAGMA foreign_keys = ON;


-- ESKİ TABLOLARI TEMİZLEME İŞLEMİ

DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS departments;


-- DEPARTMANLAR

CREATE TABLE departments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    department_code TEXT UNIQUE NOT NULL,
    department_name TEXT NOT NULL
);


-- ÖĞRENCİLER

CREATE TABLE students (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    student_number TEXT UNIQUE NOT NULL,
    full_name TEXT NOT NULL,
    department_id INTEGER NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (department_id)
        REFERENCES departments(id)
        ON DELETE RESTRICT
);


-- DERSLER

CREATE TABLE courses (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    course_code TEXT UNIQUE NOT NULL,
    course_name TEXT NOT NULL,
    credit INTEGER NOT NULL CHECK (credit > 0),
    department_id INTEGER NOT NULL,

    FOREIGN KEY (department_id)
        REFERENCES departments(id)
        ON DELETE RESTRICT
);

-- ÖĞRENCİ

CREATE TABLE enrollments (
    student_id INTEGER NOT NULL,
    course_id INTEGER NOT NULL,
    enrollment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    final_grade INTEGER CHECK (final_grade BETWEEN 0 AND 100),

    PRIMARY KEY (student_id, course_id),

    FOREIGN KEY (student_id)
        REFERENCES students(id)
        ON DELETE CASCADE,

    FOREIGN KEY (course_id)
        REFERENCES courses(id)
        ON DELETE RESTRICT
);

-- DEPARTMANLAR

INSERT INTO departments (department_code, department_name)
VALUES
('ARC01', 'Arcana Kuramları ve Rezonans'),
('RUN01', 'Rün, Tılsım ve Mühür Sanatları'),
('ELM01', 'Elemental Akış ve Dönüşüm'),
('FLD01', 'Saha Arcana ve Keşif'),
('BIO01', 'Büyülü Canlılar ve Ekosistemler'),
('HIS01', 'Antik Diller, Tarih ve Metinler');


-- ÖĞRENCİLER

INSERT INTO students (student_number, full_name, department_id)
VALUES

-- Arcana Kuramları ve Rezonans
('ARK001', 'Ael Varyn', 1),
('ARK002', 'Serenna Vaelor', 1),
('ARK003', 'Tor Evin', 1),
('ARK004', 'Meliora Caelwyn', 1),

-- Rün, Tılsım ve Mühür Sanatları
('ARK005', 'Neris Tal', 2),
('ARK006', 'Vaela Morren', 2),
('ARK007', 'Iren', 2),
('ARK008', 'Dorevan Silcrest', 2),

-- Elemental Akış ve Dönüşüm
('ARK009', 'Kael', 3),
('ARK010', 'Elira Voss', 3),
('ARK011', 'Theron Maelis', 3),
('ARK012', 'Nyra Solenvar', 3),

-- Saha Arcana ve Keşif
('ARK013', 'Rin Vey', 4),
('ARK014', 'Tavia Dornel', 4),
('ARK015', 'Orven', 4),
('ARK016', 'Selene Arveth', 4),

-- Büyülü Canlılar ve Ekosistemler
('ARK017', 'Mira Fen', 5),
('ARK018', 'Calen Vor', 5),
('ARK019', 'Ysara Delmire', 5),
('ARK020', 'Lio', 5),

-- Antik Diller, Tarih ve Metinler
('ARK021', 'Eren Val', 6),
('ARK022', 'Thalia Noren', 6),
('ARK023', 'Veyr', 6),
('ARK024', 'Aurelia Sennovar', 6);


-- DERSLER

INSERT INTO courses (course_code, course_name, credit, department_id)
VALUES

-- ARCANA KURAMLARI VE REZONANS

('ARC101', 'Arcana Temelleri', 4, 1),
('ARC102', 'Arcana Enerji Yapıları', 4, 1),
('ARC201', 'Rezonans Teorisi', 5, 1),
('ARC202', 'Arcana Akış Dinamikleri', 4, 1),
('ARC301', 'İleri Arcana Kuramları', 5, 1),
('ARC302', 'Arcana Sistem Analizi', 5, 1),


-- RÜN, TILSIM VE MÜHÜR SANATLARI

('RUN101', 'Rün Okuma ve Yazımı', 3, 2),
('RUN102', 'Temel Tılsım Tasarımı', 4, 2),
('RUN201', 'Koruyucu Mühürler', 4, 2),
('RUN202', 'Rün Kombinasyonları', 5, 2),
('RUN301', 'İleri Tılsım Mimarisi', 5, 2),
('RUN302', 'Mühür Sistemleri Analizi', 4, 2),


-- ELEMENTAL AKIŞ VE DÖNÜŞÜM

('ELM101', 'Elemental Enerjiye Giriş', 4, 3),
('ELM102', 'Ateş ve Isı Akışları', 4, 3),
('ELM201', 'Su ve Akış Kontrolü', 4, 3),
('ELM202', 'Hava ve Basınç Dinamikleri', 5, 3),
('ELM301', 'Toprak ve Mineral Rezonansı', 5, 3),
('ELM302', 'Birleşik Element Uygulamaları', 5, 3),


-- SAHA ARCANA VE KEŞİF

('FLD101', 'Arcana Saha Güvenliği', 3, 4),
('FLD102', 'Harita ve Rota Okuma', 3, 4),
('FLD201', 'Arcana İz Takibi', 4, 4),
('FLD202', 'Tehlikeli Bölge Analizi', 4, 4),
('FLD301', 'İleri Keşif Teknikleri', 5, 4),
('FLD302', 'Kriz ve Tahliye Yönetimi', 4, 4),


-- BÜYÜLÜ CANLILAR VE EKOSİSTEMLER

('BIO101', 'Büyülü Varlıklara Giriş', 4, 5),
('BIO102', 'Fantastik Flora Bilgisi', 3, 5),
('BIO201', 'Fantastik Fauna Bilgisi', 4, 5),
('BIO202', 'Arcana Ekolojisi', 5, 5),
('BIO301', 'Büyülü Varlık Davranışları', 5, 5),
('BIO302', 'Ekosistem Koruma Teknikleri', 4, 5),


-- ANTİK DİLLER, TARİH VE METİNLER

('HIS101', 'Arcana Tarihine Giriş', 3, 6),
('HIS102', 'Antik Uygarlıklar', 4, 6),
('HIS201', 'Antik Yazı Sistemleri', 4, 6),
('HIS202', 'Eski Arcana Metinleri', 4, 6),
('HIS301', 'Arcana Kültür Tarihi', 5, 6),
('HIS302', 'Antik Metin Çözümleme', 5, 6);

-- DERS NOTLARI

INSERT INTO enrollments (student_id, course_id, final_grade)
VALUES

(1, 1, 88),
(1, 2, 79),
(1, 3, 91),

(2, 1, 93),
(2, 3, 87),
(2, 4, 90),

(3, 2, 72),
(3, 4, 81),
(3, 5, 77),

(4, 1, 96),
(4, 5, 94),
(4, 6, 98),

(5, 7, 84),
(5, 8, 89),
(5, 9, 82),

(6, 7, 92),
(6, 10, 94),
(6, 11, 91),

(7, 8, 73),
(7, 9, 77),
(7, 12, 80),

(8, 10, 96),
(8, 11, 95),
(8, 12, 98),

(9, 13, 85),
(9, 14, 88),
(9, 15, 90),

(10, 13, 78),
(10, 16, 82),
(10, 17, 86),

(11, 14, 94),
(11, 17, 96),
(11, 18, 93),

(12, 15, 89),
(12, 16, 91),
(12, 18, 95),

(13, 19, 84),
(13, 20, 87),
(13, 21, 90),

(14, 19, 76),
(14, 22, 82),
(14, 23, 85),

(15, 20, 95),
(15, 23, 97),
(15, 24, 94),

(16, 21, 80),
(16, 22, 83),
(16, 24, 86),

(17, 25, 91),
(17, 26, 87),
(17, 27, 93),

(18, 25, 79),
(18, 28, 84),
(18, 29, 82),

(19, 26, 95),
(19, 29, 97),
(19, 30, 96),

(20, 27, 75),
(20, 28, 78),
(20, 30, 81),

(21, 31, 88),
(21, 32, 91),
(21, 33, 86),

(22, 31, 80),
(22, 34, 85),
(22, 35, 89),

(23, 32, 94),
(23, 35, 96),
(23, 36, 93),

(24, 33, 92),
(24, 34, 95),
(24, 36, 98);