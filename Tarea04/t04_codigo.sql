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
 'Alergologo, Pediatra, Nutricionista, Odontologo', 'Hospital Max peralta');
INSERT INTO t04_temporal values('2-0876-4527', 'Flor', 'Flores', 'Heredia',
 'Nutricionista, Cardiologa, Medico General', 'Hospital San Vicente de Paul');
INSERT INTO t04_temporal values('1-9976-0442', 'Kevin', 'Moraga', 'Alajuela',
 'Cardiologo, Pediatra, Hepatologo', 'Hospital San Rafael');

--bloque anonimo
SET serveroutput ON;

/*
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
*/

-- parte 3
-- drop procedure aux_lista_especialidades;

CREATE OR REPLACE FUNCTION lista_especialidades (cedula VARCHAR2) 
    RETURN VARCHAR2 IS
    resultado VARCHAR2(200); 
BEGIN 
  resultado := ' ';
  FOR item IN ( 
    select t04_especialidad.nombre_espec from t04_medico 
    join t04_medico_especialidad on  t04_medico_especialidad.medico_id = t04_medico.id_medico 
    join t04_especialidad on  t04_medico_especialidad.especialidad_id = t04_especialidad.id_especialidad 
    where t04_medico.cedula_medico = cedula 
    ORDER BY t04_especialidad.nombre_espec ASC  
        ) LOOP
        resultado := resultado || item.nombre_espec || ' , ';
        
        END LOOP;
    DBMS_OUTPUT.PUT_LINE (resultado); 
    return resultado;
END;

-- parte 4
-- MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
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

-- function medico existe
CREATE OR REPLACE FUNCTION medico_no_existe ( new_cedula_medico VARCHAR2)
    RETURN BOOLEAN IS
    v_a NUMBER;
BEGIN
    SELECT count(cedula_medico) INTO v_a
    FROM t04_medico 
    WHERE cedula_medico = new_cedula_medico;
    
    IF v_a > 0 THEN 
        RETURN FALSE;
    ELSE 
        RETURN TRUE;
    END IF;
END;
/

-- insertar nuevo medico
CREATE OR REPLACE PROCEDURE nuevo_medico(
    new_cedula_medico VARCHAR2,
    new_nombre_medico VARCHAR2,
    new_primer_apellido VARCHAR2,
    new_direccion VARCHAR2
)
AS
    new_id_medico NUMBER;
    bandera BOOLEAN;
BEGIN
    new_id_medico := calcular_siguiente_id_medico();
    bandera := medico_no_existe(new_cedula_medico);
    IF ( bandera ) THEN 
        INSERT INTO t04_medico values(new_id_medico, new_cedula_medico, new_nombre_medico, new_primer_apellido, new_direccion);
    END IF;
END;
/

CREATE OR REPLACE FUNCTION espec_no_existe (v_nombre_espec VARCHAR2)
   RETURN BOOLEAN IS
    v_a NUMBER;
BEGIN
    SELECT count(id_especialidad) INTO v_a
    FROM t04_especialidad 
    WHERE nombre_espec = v_nombre_espec;
    
    IF v_a > 0 THEN 
        RETURN FALSE;
    ELSE 
        RETURN TRUE;
    END IF;
END;
/
    

CREATE OR REPLACE PROCEDURE nueva_especialidad(
    new_nombre_espec VARCHAR2
)
AS
    new_id_espc NUMBER;
    bandera BOOLEAN;
BEGIN
    SELECT (max(t04_especialidad.id_especialidad) + 1) INTO new_id_espc
    FROM t04_especialidad;
    
    bandera := espec_no_existe(new_nombre_espec);
    
    IF ( bandera ) THEN 
        INSERT INTO t04_especialidad VALUES (new_id_espc, new_nombre_espec);
    END IF;
END;
/

-- funcion para preguntar si un hospital existe
-- retorna la cantidad de hospitales con el nombre, si existe debe ser 1, sino 0
CREATE OR REPLACE FUNCTION existe_hospital( nom_hosp VARCHAR2 )
    RETURN NUMBER IS
    v_numero_hospitales NUMBER;
BEGIN
    SELECT count(t04_hospital.id_hospital) INTO v_numero_hospitales
    FROM t04_hospital
    WHERE t04_hospital.nombre_hospital = nom_hosp;
    
    RETURN v_numero_hospitales;
END;
/

-- procedimiento para enlazar medico con el hospital
CREATE OR REPLACE PROCEDURE p_conectar_medico_hospital(
    p_cedula_medico VARCHAR2,
    p_nombre_hospital VARCHAR2 )
IS
    v_id_medico NUMBER;
    v_id_hospital NUMBER;
BEGIN
    SELECT t04_medico.id_medico INTO v_id_medico
    FROM t04_medico
    WHERE t04_medico.cedula_medico = p_cedula_medico;
    
    SELECT t04_hospital.id_hospital INTO v_id_hospital
    FROM t04_hospital
    WHERE t04_hospital.nombre_hospital = p_nombre_hospital;
    
    DBMS_OUTPUT.PUT_LINE(v_id_medico || ' ,' || v_id_hospital);
    INSERT INTO t04_medico_hospital values(v_id_medico, v_id_hospital);
END;
/

-- procedimiento para enlazar medico con especialidad
CREATE OR REPLACE PROCEDURE p_conectar_medico_especialidad(
    p_cedula_medico VARCHAR2,
    p_nombre_espec VARCHAR2 )
IS
    v_id_medico NUMBER;
    v_id_espec NUMBER;
BEGIN
    SELECT t04_medico.id_medico INTO v_id_medico
    FROM t04_medico
    WHERE t04_medico.cedula_medico = p_cedula_medico;
    
    SELECT t04_especialidad.id_especialidad INTO v_id_espec
    FROM t04_especialidad
    WHERE t04_especialidad.nombre_espec = p_nombre_espec;
    
    DBMS_OUTPUT.PUT_LINE(v_id_medico || ' ,' || v_id_espec);
    INSERT INTO t04_medico_especialidad values(v_id_medico, v_id_espec);
END;
/
-- MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
CREATE OR REPLACE PROCEDURE procesa_medico_hospital_especialidad AS 
v_medico_cedula VARCHAR2(15);  
v_lista_especialidades VARCHAR2(100); 
v_especialidad VARCHAR2(40); 
v_hospital VARCHAR2(40);
v_hospital_id number; 
 
BEGIN 
FOR item IN (SELECT * FROM t04_temporal) LOOP 
    v_lista_especialidades := TRIM(item.especialidades); 
    IF LENGTH(v_lista_especialidades) > 0 THEN 
        LOOP 
            IF INSTR(v_lista_especialidades, ',') > 0 THEN 
            v_especialidad := SUBSTR(v_lista_especialidades, 1, INSTR(v_lista_especialidades, ',') -1); 
            v_lista_especialidades := TRIM(SUBSTR(v_lista_especialidades, INSTR(v_lista_especialidades, ',') +1)); 
            v_hospital_id := v_hospital_id +1; 
            ELSE 
                v_especialidad := v_lista_especialidades; 
                v_lista_especialidades := ''; 
            END IF; 
            DBMS_OUTPUT.PUT_LINE (item.medico_nombre); 
            DBMS_OUTPUT.PUT_LINE (v_hospital_id  || v_especialidad);
            -- insertar medico
            SELECT medico_cedula INTO v_medico_cedula FROM t04_temporal WHERE medico_nombre = item.medico_nombre;
            nuevo_medico(v_medico_cedula, item.medico_nombre, item.medico_apellido, item.medico_provincia);
            -- insertar especialidad
            nueva_especialidad(v_especialidad);
            -- conectar medico con especialidad
            p_conectar_medico_especialidad(v_medico_cedula , v_especialidad);
            -- conectar medico con el hospital
            SELECT hospitales INTO v_hospital FROM t04_temporal WHERE medico_nombre = item.medico_nombre;
            DBMS_OUTPUT.PUT_LINE (v_hospital);
            p_conectar_medico_hospital(v_medico_cedula, v_hospital);
        EXIT WHEN v_lista_especialidades is NULL; 
        END LOOP; 
    END IF; 
END LOOP;    
END;

EXEC procesa_medico_hospital_especialidad();

