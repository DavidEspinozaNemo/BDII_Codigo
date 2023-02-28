-- Tarea04

-- 1. creacion del modelo relacional

-- tablas independientes

CREATE TABLE t04_hospital(
    id_hospital NUMBER,
    nombre_hospital VARCHAR2(40) NOT NULL,
    provincia VARCHAR2(10) NOT NULL
);

ALTER TABLE t04_hospital 
ADD CONSTRAINT pk_t04_hospital PRIMARY KEY (id_hospital);

CREATE TABLE t04_especialidad(
    id_especialidad NUMBER,
    nombre_espec VARCHAR2(40) NOT NULL
);

ALTER TABLE t04_especialidad 
ADD CONSTRAINT pk_t04_especialidad PRIMARY KEY (id_especialidad);

CREATE TABLE t04_medico(
    id_medico NUMBER,
    cedula_medico VARCHAR2(11) NOT NULL,
    nombre_medico VARCHAR2(40) NOT NULL,
    primer_apellido VARCHAR2(40) NOT NULL,
    direccion_provincia VARCHAR2(10) NOT NULL
);

ALTER TABLE t04_medico 
ADD ( CONSTRAINT pk_t04_medico PRIMARY KEY (id_medico),
      CONSTRAINT unique_cedula_medico UNIQUE(cedula_medico)
    );

-- tablas de transición

CREATE TABLE t04_medico_especialidad(
    medico_id NUMBER,
    especialidad_id NUMBER
);

ALTER TABLE t04_medico_especialidad 
ADD ( CONSTRAINT fk_tr04_medico FOREIGN KEY (medico_id)
      REFERENCES t04_medico(id_medico)
    , CONSTRAINT fk_tr04_espec FOREIGN KEY (especialidad_id)
      REFERENCES t04_especialidad(id_especialidad)
    );

CREATE TABLE t04_medico_hospital(
    medico_id NUMBER,
    hospital_id NUMBER
);

ALTER TABLE t04_medico_hospital 
ADD ( CONSTRAINT fk_tr04_medico2 FOREIGN KEY (medico_id)
      REFERENCES t04_medico(id_medico)
    , CONSTRAINT fk_tr04_hospital FOREIGN KEY (hospital_id)
      REFERENCES t04_hospital(id_hospital)
    );

-- datos de prueba

INSERT INTO t04_hospital values (1, 'Hospital Max peralta', 'Cartago');
INSERT INTO t04_hospital values (2, 'Hospital San Rafael', 'Alajuela');
INSERT INTO t04_hospital values (3, 'Hospital San Vicente de Paul', 'Heredia');

INSERT INTO t04_medico values (1, '4-0071-0076', 'Gloria', 'Morales', 'Alajuela');
INSERT INTO t04_medico values (2, '1-0651-0656', 'Andrea', 'Porras', 'Heredia');
INSERT INTO t04_medico values (3, '4-9876-6535', 'Aurelio', 'Sanabria', 'Alajuela');
INSERT INTO t04_medico values (4, '3-7879-8765', 'Jaime', 'Vargas', 'Cartago');

INSERT INTO t04_especialidad values(1, 'Cardiologo');
INSERT INTO t04_especialidad values(2, 'Alergologo');
INSERT INTO t04_especialidad values(3, 'Pediatra');
INSERT INTO t04_especialidad values(4, 'Nutricionista');

INSERT INTO t04_medico_hospital values(1, 2);
INSERT INTO t04_medico_hospital values(1, 3);
INSERT INTO t04_medico_hospital values(4, 3);

INSERT INTO t04_medico_especialidad values(1, 1);
INSERT INTO t04_medico_especialidad values(1, 2);
INSERT INTO t04_medico_especialidad values(2, 3);
INSERT INTO t04_medico_especialidad values(2, 4);
INSERT INTO t04_medico_especialidad values(3, 4);
INSERT INTO t04_medico_especialidad values(4, 4);