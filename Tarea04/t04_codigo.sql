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
