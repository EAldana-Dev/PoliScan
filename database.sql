CREATE DATABASE IF NOT EXISTS ipn_inventory
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE ipn_inventory;

CREATE TABLE academic_units (
                                id INT AUTO_INCREMENT PRIMARY KEY,
                                name VARCHAR(100) NOT NULL UNIQUE,
                                active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE areas (
                       id INT AUTO_INCREMENT PRIMARY KEY,
                       name VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE zones (
                       id INT AUTO_INCREMENT PRIMARY KEY,
                       academic_unit_id INT NOT NULL,
                       area_id INT NOT NULL,
                       name VARCHAR(120) NOT NULL,
                       qr_code VARCHAR(120) UNIQUE,
                       FOREIGN KEY (academic_unit_id) REFERENCES academic_units(id),
                       FOREIGN KEY (area_id) REFERENCES areas(id)
);

CREATE TABLE resources (
                           id INT AUTO_INCREMENT PRIMARY KEY,
                           academic_unit_id INT NOT NULL,
                           area_id INT NOT NULL,
                           zone_id INT NULL,
                           name VARCHAR(150) NOT NULL,
                           inventory_number VARCHAR(100) NOT NULL UNIQUE,
                           qr_code VARCHAR(120) UNIQUE,
                           identification_type ENUM(
        'INDIVIDUAL_QR',
        'ZONE_QR',
        'MANUAL_ID'
    ) NOT NULL DEFAULT 'INDIVIDUAL_QR',
                           description VARCHAR(500),
                           condition_status ENUM(
        'GOOD',
        'MINOR_DAMAGE',
        'REQUIRES_MAINTENANCE',
        'OUT_OF_SERVICE'
    ) NOT NULL DEFAULT 'GOOD',
                           active BOOLEAN NOT NULL DEFAULT TRUE,
                           created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                           FOREIGN KEY (academic_unit_id)
                               REFERENCES academic_units(id),
                           FOREIGN KEY (area_id)
                               REFERENCES areas(id),
                           FOREIGN KEY (zone_id)
                               REFERENCES zones(id)
);

CREATE TABLE reports (
                         id BIGINT AUTO_INCREMENT PRIMARY KEY,
                         resource_id INT NOT NULL,
                         reported_status ENUM(
        'GOOD',
        'MINOR_DAMAGE',
        'REQUIRES_MAINTENANCE',
        'OUT_OF_SERVICE'
    ) NOT NULL,
                         description TEXT NOT NULL,
                         photo_path VARCHAR(255),
                         report_status ENUM(
        'PENDING',
        'IN_REVIEW',
        'ATTENDED',
        'CLOSED'
    ) NOT NULL DEFAULT 'PENDING',
                         created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                         FOREIGN KEY (resource_id)
                             REFERENCES resources(id)
);

CREATE TABLE users (
                       id INT AUTO_INCREMENT PRIMARY KEY,
                       name VARCHAR(120) NOT NULL,
                       email VARCHAR(150) NOT NULL UNIQUE,
                       password_hash VARCHAR(255) NOT NULL,
                       role ENUM(
        'STUDENT',
        'ADMIN'
    ) NOT NULL DEFAULT 'STUDENT',
                       active BOOLEAN NOT NULL DEFAULT TRUE,
                       created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO areas(name)
VALUES
    ('Aulas'),
    ('Talleres'),
    ('Laboratorios'),
    ('Deportes'),
    ('Áreas comunes');

INSERT INTO academic_units(name)
VALUES
    ('CECyT 1'),
    ('CECyT 2'),
    ('CECyT 3'),
    ('CECyT 4'),
    ('CECyT 5'),
    ('CECyT 6'),
    ('CECyT 7'),
    ('CECyT 8'),
    ('CECyT 9'),
    ('CECyT 10'),
    ('CECyT 11'),
    ('CECyT 12'),
    ('CECyT 13'),
    ('CECyT 14'),
    ('CECyT 15'),
    ('CECyT 16'),
    ('CECyT 17'),
    ('CECyT 18'),
    ('CECyT 19'),
    ('CECyT 20'),
    ('CET 1');

INSERT INTO zones(
    academic_unit_id,
    area_id,
    name,
    qr_code
)
SELECT
    au.id,
    a.id,
    'Almacén deportivo',
    CONCAT(
            REPLACE(au.name, ' ', ''),
            '-DEP-ZONE-01'
    )
FROM academic_units au
         JOIN areas a
              ON a.name = 'Deportes';

INSERT INTO resources(
    academic_unit_id,
    area_id,
    name,
    inventory_number,
    qr_code,
    identification_type,
    description,
    condition_status
)
SELECT
    au.id,
    a.id,
    'Proyector',
    CONCAT(
            REPLACE(au.name, ' ', ''),
            '-AUL-001'
    ),
    CONCAT(
            REPLACE(au.name, ' ', ''),
            '-AUL-001'
    ),
    'INDIVIDUAL_QR',
    'Proyector para uso en aulas',
    'GOOD'
FROM academic_units au
         JOIN areas a
              ON a.name = 'Aulas';

INSERT INTO resources(
    academic_unit_id,
    area_id,
    name,
    inventory_number,
    qr_code,
    identification_type,
    description,
    condition_status
)
SELECT
    au.id,
    a.id,
    'Torno',
    CONCAT(
            REPLACE(au.name, ' ', ''),
            '-TAL-001'
    ),
    CONCAT(
            REPLACE(au.name, ' ', ''),
            '-TAL-001'
    ),
    'INDIVIDUAL_QR',
    'Torno para prácticas de taller',
    'REQUIRES_MAINTENANCE'
FROM academic_units au
         JOIN areas a
              ON a.name = 'Talleres';

INSERT INTO resources(
    academic_unit_id,
    area_id,
    name,
    inventory_number,
    qr_code,
    identification_type,
    description,
    condition_status
)
SELECT
    au.id,
    a.id,
    'Microscopio',
    CONCAT(
            REPLACE(au.name, ' ', ''),
            '-LAB-001'
    ),
    CONCAT(
            REPLACE(au.name, ' ', ''),
            '-LAB-001'
    ),
    'INDIVIDUAL_QR',
    'Microscopio de laboratorio',
    'MINOR_DAMAGE'
FROM academic_units au
         JOIN areas a
              ON a.name = 'Laboratorios';

INSERT INTO resources(
    academic_unit_id,
    area_id,
    zone_id,
    name,
    inventory_number,
    identification_type,
    description,
    condition_status
)
SELECT
    au.id,
    a.id,
    z.id,
    'Balón de fútbol #001',
    CONCAT(
            REPLACE(au.name, ' ', ''),
            '-DEP-001'
    ),
    'ZONE_QR',
    'Material deportivo identificado por inventario y zona',
    'GOOD'
FROM academic_units au
         JOIN areas a
              ON a.name = 'Deportes'
         JOIN zones z
              ON z.academic_unit_id = au.id
                  AND z.area_id = a.id;

INSERT INTO resources(
    academic_unit_id,
    area_id,
    zone_id,
    name,
    inventory_number,
    identification_type,
    description,
    condition_status
)
SELECT
    au.id,
    a.id,
    z.id,
    'Balón de fútbol #002',
    CONCAT(
            REPLACE(au.name, ' ', ''),
            '-DEP-002'
    ),
    'ZONE_QR',
    'Material deportivo identificado por inventario y zona',
    'MINOR_DAMAGE'
FROM academic_units au
         JOIN areas a
              ON a.name = 'Deportes'
         JOIN zones z
              ON z.academic_unit_id = au.id
                  AND z.area_id = a.id;