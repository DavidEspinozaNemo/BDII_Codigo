-- Estructura de Entidad Bancaria

-- Tablas Independientes
DROP TABLE SUCURSAL;

CREATE TABLE sucursal 
(     nombre_sucursal VARCHAR2(35)
    , ciudad_sucursal VARCHAR2(35) NOT NULL
    , activos         NUMBER(8) NOT NULL
);

ALTER TABLE sucursal 
ADD CONSTRAINT pk_sucursal PRIMARY KEY (nombre_sucursal);

DROP TABLE CLIENTE;

CREATE TABLE cliente 
(     nombre_cliente VARCHAR2(35)
    , calle_client   VARCHAR2(35) NOT NULL
    , ciudad_client  VARCHAR2(35) NOT NULL
);

ALTER TABLE cliente 
ADD CONSTRAINT pk_cliente PRIMARY KEY (nombre_cliente);

-- Tablas dependiente
DROP TABLE CUENTA;

CREATE TABLE cuenta 
(     numero_cuenta   VARCHAR2(35)
    , nombre_sucursal VARCHAR2(35)
    , saldo           NUMBER(8) NOT NULL
);

ALTER TABLE cuenta 
ADD ( CONSTRAINT pk_cuenta PRIMARY KEY (numero_cuenta)
    , CONSTRAINT fk_cuenta_x_sucursal FOREIGN KEY (nombre_sucursal)
      REFERENCES sucursal(nombre_sucursal)
    );

DROP TABLE PRESTAMO;

CREATE TABLE prestamo 
(     numero_prestamo VARCHAR2(35)
    , nombre_sucursal VARCHAR2(35)
    , importe         NUMBER(8) NOT NULL
);

ALTER TABLE prestamo 
ADD ( CONSTRAINT pk_prestamo PRIMARY KEY (numero_prestamo)
    , CONSTRAINT fk_prestamo_x_sucursal FOREIGN KEY (nombre_sucursal)
      REFERENCES sucursal(nombre_sucursal)
    );

-- Tablas de Transición
DROP TABLE PRESTATARIO;

CREATE TABLE prestatario 
(     nombre_cliente  VARCHAR2(35)
    , numero_prestamo VARCHAR2(35)
);

ALTER TABLE prestatario 
ADD ( CONSTRAINT fk_tr01_pres_client FOREIGN KEY (nombre_cliente)
      REFERENCES cliente(nombre_cliente)
    , CONSTRAINT fk_tr02_pres_prestamo FOREIGN KEY (numero_prestamo)
      REFERENCES prestamo(numero_prestamo)
    );

DROP TABLE IMPOSITOR;

CREATE TABLE impositor
(     nombre_cliente  VARCHAR2(35)
    , numero_cuenta   VARCHAR2(35)
);

ALTER TABLE impositor 
ADD ( CONSTRAINT fk_tr03_impos_cliente FOREIGN KEY (nombre_cliente)
      REFERENCES cliente(nombre_cliente)
    , CONSTRAINT fk_tr04_impos_cuenta FOREIGN KEY (numero_cuenta)
      REFERENCES cuenta(numero_cuenta)
    );
    
-- llenado de datos de prueba

INSERT INTO sucursal values ('Becerril'            ,'Aluche'           ,  400000);
INSERT INTO sucursal values ('Centro'              ,'Arganzuela'       , 9000000);
INSERT INTO sucursal values ('Collado Mediano'     ,'Aluche'           , 8000000);
INSERT INTO sucursal values ('Galapagar'           ,'Arganzuela'       , 7100000);
INSERT INTO sucursal values ('Moralzarzal'         ,'La Granja'        , 2100000);
INSERT INTO sucursal values ('Navacerrada'         ,'Aluche'           , 1700000);
INSERT INTO sucursal values ('Navas de la Asuncion','Alcala de Henares',  300000);
INSERT INTO sucursal values ('Segovia'             ,'Cerceda'          , 3700000);

INSERT INTO cliente values ('Abril'     , 'Preciados'  ,    'Valsain');
INSERT INTO cliente values ('Amo'       , 'Embajadores', 'Arganzuela');
INSERT INTO cliente values ('Badorrey'  , 'Delicias'   ,    'Valsain');
INSERT INTO cliente values ('Fernandez' , 'Jazmin'     ,       'Leon');
INSERT INTO cliente values ('Gomez'     , 'Carretas'   ,    'Cerceda');
INSERT INTO cliente values ('Gonzalez'  , 'Arenal'     ,  'La Granja');
INSERT INTO cliente values ('Lopez'     , 'Mayor'      , 'Peguerinos');
INSERT INTO cliente values ('Perez'     , 'Carretas'   ,    'Cerceda');
INSERT INTO cliente values ('Rodriguez' , 'Yeserias'   ,      'Cadiz');
INSERT INTO cliente values ('Ruperez'   , 'Ramblas'    ,       'Leon');
INSERT INTO cliente values ('Santos'    , 'Mayor'      , 'Peguerinos');
INSERT INTO cliente values ('Valdivieso', 'Goya'       ,       'Vigo');

INSERT INTO cuenta values ('C-101', 'Centro'         , 500);
INSERT INTO cuenta values ('C-215', 'Becerril'       , 700);
INSERT INTO cuenta values ('C-102', 'Navacerrada'    , 400);
INSERT INTO cuenta values ('C-305', 'Collado Mediano', 350);
INSERT INTO cuenta values ('C-201', 'Galapagar'      , 900);
INSERT INTO cuenta values ('C-222', 'Moralzarzal'    , 700);
INSERT INTO cuenta values ('C-217', 'Galapagar'      , 750);

INSERT INTO prestamo values ('P-11', 'Collado Mediano',  900);
INSERT INTO prestamo values ('P-14', 'Centro'         , 1500);
INSERT INTO prestamo values ('P-15', 'Navacerrada'    , 1500);
INSERT INTO prestamo values ('P-16', 'Navacerrada'    , 1300);
INSERT INTO prestamo values ('P-17', 'Centro'         , 1000);
INSERT INTO prestamo values ('P-23', 'Moralzarzal'    , 2000);
INSERT INTO prestamo values ('P-93', 'Becerril'       ,  500);

INSERT INTO prestatario values ('Fernandez' , 'P-16');
INSERT INTO prestatario values ('Gomez'     , 'P-11');
INSERT INTO prestatario values ('Gomez'     , 'P-23');
INSERT INTO prestatario values ('Lopez'     , 'P-15');
INSERT INTO prestatario values ('Perez'     , 'P-93');
INSERT INTO prestatario values ('Santos'    , 'P-17');
INSERT INTO prestatario values ('Santos'    , 'P-14');
INSERT INTO prestatario values ('Valdivieso', 'P-17');

INSERT INTO impositor values ('Abril'   , 'C-305');
INSERT INTO impositor values ('Gomez'   , 'C-215');
INSERT INTO impositor values ('Gonzalez', 'C-101');
INSERT INTO impositor values ('Gonzalez', 'C-201');
INSERT INTO impositor values ('Lopez'   , 'C-102');
INSERT INTO impositor values ('Ruperez' , 'C-222');
INSERT INTO impositor values ('Santos'  , 'C-217');

-- Ejercicios de repaso JOINS

-- Liste todos los clientes y sus prestamos en caso de que tengan uno

SELECT c.nombre_cliente, c.ciudad_client, p.numero_prestamo, t.importe
FROM cliente c
LEFT JOIN prestatario p
  ON c.nombre_cliente = p.nombre_cliente
LEFT JOIN prestamo t
  ON p.numero_prestamo = t.numero_prestamo;

-- Liste todas las cuentas y todas las sucursales

SELECT c.numero_cuenta, c.nombre_sucursal, s.ciudad_sucursal
FROM cuenta c
FULL OUTER JOIN sucursal s
  ON s.nombre_sucursal = c.nombre_sucursal;
  
-- Liste todas las sucursales y sus clientes si existen (incluya la ciudad en la que vive).

SELECT s.nombre_sucursal, t.nombre_cliente, t.ciudad_client
FROM sucursal s
LEFT JOIN cuenta c
  ON s.nombre_sucursal = c.nombre_sucursal
LEFT JOIN impositor i
  ON c.numero_cuenta = i.numero_cuenta
LEFT JOIN cliente t
  ON t.nombre_cliente = i.nombre_cliente;

-- practica de procedimientos

-- procedimiento ejemplo, creacion de una sucursal
CREATE OR REPLACE PROCEDURE agregar_sucursal (v_nombre   IN VARCHAR2,
                                              v_ciudad   IN VARCHAR2,
                                              v_activos  IN NUMBER )
IS
BEGIN
    INSERT INTO sucursal
    VALUES (v_nombre, v_ciudad, v_activos);
    
    DBMS_OUTPUT.put_line ('Se ha insertado la sucursal: ' || v_nombre);
END;
/

-- ejecucion
EXEC agregar_sucursal ('Aquella ubicacion', 'Cartago', 150);

SELECT * FROM sucursal;

-- procedimiento 2

CREATE OR REPLACE PROCEDURE cuentas_mayores_sp (v_cuenta VARCHAR2,
                                                c1 IN OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN c1 FOR
        SELECT *
        FROM cuenta
        WHERE saldo > (SELECT saldo FROM cuenta WHERE numero_cuenta = v_cuenta);
END;
/

-- step 1
VAR c1 REFCURSOR;
EXEC cuentas_mayores_sp('C-102', :c1);

--step 2
PRINT c1;

-- Creacion de una funcion

CREATE OR REPLACE FUNCTION valida_cuenta (v_cuenta VARCHAR2)
    RETURN BOOLEAN IS
    v_saldo     NUMBER;
    v_promedio  NUMBER;
BEGIN
    SELECT saldo INTO v_saldo
    FROM cuenta
    WHERE numero_cuenta = v_cuenta;
    
    SELECT AVG (saldo) INTO v_promedio
    FROM cuenta;
    
    IF v_saldo < v_promedio THEN
        RETURN FALSE;
    ELSE
        RETURN TRUE;
    END IF;
END;
/

-- ejecucion / retorna TRUE/FALSE
SET SERVEROUTPUT ON;

BEGIN
    IF valida_cuenta ('C-333') THEN
        DBMS_OUTPUT.put_line ('Cuenta valida');
    ELSE
        DBMS_OUTPUT.put_line ('Cuenta por debajo del promedio !!');
    END IF;
END;
/

-- ejemplo de la funcion SYSDATE / retorna un valor
-- dual es una tabla virtual
SELECT SYSDATE FROM dual;


-- variables compuestas
DECLARE -- Bloque anonimo
    -- Associate array indexed by string:
    
    TYPE population IS TABLE OF NUMBER -- Associate array type
        INDEX BY VARCHAR2(64);         --  indexed by string
    
    city_population population; -- Associate array variable
    i VARCHAR2(64);             -- Scalar variable
    
BEGIN
    -- Add elements (key-value pairs) to associative array:
    
    city_population('Smallville')  := 2000;
    city_population('Midland')     := 750000;
    city_population('Megalopolis') := 1000000;
    
    -- Change value associated with key 'Smallville':
    
    city_population('Smallville') := 2001;
    
    -- Print associate array:
    
    i := city_population.FIRST; -- Get first element of array
    
    WHILE i IS NOT NULL LOOP
        DBMS_Output.PUT_LINE('Population of ' || i || ' is ' || city_population(i) );
        i := city_population.NEXT(i); -- Get next element of array
    END LOOP;
END;
/

-- Ejemplo %ROWTYPE

-- DESC = describir la tabla X
DESC employees;

DECLARE
    regEmp employees%ROWTYPE;
    v_income employees.salary%TYPE;
BEGIN
    regEmp.first_name := 'Alberto';
    DBMS_OUTPUT.Put_Line(regEmp.first_name);
    v_income := 9500;
    DBMS_OUTPUT.Put_Line(v_income);
END;
/

-- cursores

-- ejemplo
DECLARE
    v_nombre_sucursal VARCHAR2(30);
    v_saldo NUMBER(10);
    CURSOR cur_cuentas IS
        SELECT nombre_sucursal, saldo
          FROM cuenta;
BEGIN
    OPEN cur_cuentas; -- apertura
    
    FETCH cur_cuentas --recuperar datos
        INTO v_nombre_sucursal, v_saldo;
        
    DBMS_OUTPUT.Put_Line('Sucursal: ' ||
                         v_nombre_sucursal ||
                         ' / Saldo ' ||
                         v_saldo);
    CLOSE cur_cuentas; --cierre
END;
/
