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

-- Creacion tabla temporal

CREATE TABLE t04_temporal(
    medico_cedula  VARCHAR2(11) NOT NULL,
    medico_nombre VARCHAR2(40) NOT NULL,
    medico_apellido VARCHAR2(40) NOT NULL,
    medico_provincia VARCHAR2(15) NOT NULL,
    especialidades VARCHAR2(200) NOT NULL,
    hospitales VARCHAR2(40) NOT NULL
);

INSERT INTO t04_temporal values('3-0098-8768', 'Marta', 'Morales', 'Cartago',
 'Alergologo, Pediatra, Nutricionista, Odontologo', 'Hospital Max Peralta');
INSERT INTO t04_temporal values('2-0876-4527', 'Flor', 'Flores', 'Heredia',
 'Nutricionista, Cardiologa, Medico General', 'Hospital San Vicente de Paul');
INSERT INTO t04_temporal values('1-9976-0442', 'Kevin', 'Moraga', 'Alajuela',
 'Cardiologo, Pediatra, Hepatologo', 'Hospital San Rafael');
 
Select * FROM t04_temporal;

--bloque anonimo
SET serveroutput ON;

DECLARE
    v_medico_cedula  VARCHAR2(11);
    v_medico_nombre VARCHAR2(40);
    v_medico_apellido VARCHAR2(40);
    v_medico_provincia VARCHAR2(15);
    CURSOR cur_medicos IS
        SELECT medico_cedula, medico_nombre, medico_apellido, medico_provincia
        FROM t04_temporal;
BEGIN
    OPEN cur_medicos;
    LOOP --ciclo
        FETCH cur_medicos
            INTO v_medico_cedula, v_medico_nombre, v_medico_apellido, v_medico_provincia;
        
        EXIT WHEN cur_medicos%NOTFOUND; -- condicion de salida
        DBMS_OUTPUT.PUT_LINE(v_medico_cedula || ' ,' || v_medico_nombre || ' ,' || v_medico_apellido || ' ,' || v_medico_provincia);
    
    END LOOP;
    CLOSE cur_medicos;
END;
/

-- funcion; obtener el id mayor
CREATE OR REPLACE FUNCTION calcular_siguiente_id_medico
    RETURN NUMBER IS
    new_id NUMBER;
BEGIN
    SELECT (max(t04_medico.id_medico) + 1) INTO new_id
    FROM t04_medico;
    
    RETURN new_id;
END;
/

Select calcular_siguiente_id_medico() FROM dual;