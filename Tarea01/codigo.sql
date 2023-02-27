-- 1.0 =>
-- creación de la base de datos
CREATE DATABASE "T01-JOINS"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
	
-- tablas
CREATE TABLE public."MEDICO"
(
    id serial,
    cedula character varying(30) NOT NULL,
    nombre character varying(60) NOT NULL,
    primer_apellido character varying(30) NOT NULL,
    provincia_vivienda character varying(30) NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS public."MEDICO"
    OWNER to postgres;

CREATE TABLE public."HOSPITAL"
(
    id serial,
    nombre character varying(60) NOT NULL,
    provincia_ubicacion character varying(30) NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS public."HOSPITAL"
    OWNER to postgres;
	
CREATE TABLE public."MEDICO_HOSPITAL"
(
    id serial,
    hospital_id integer NOT NULL,
    medico_id integer NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT tabla_hospital FOREIGN KEY (hospital_id)
        REFERENCES public."HOSPITAL" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT tabla_medico FOREIGN KEY (medico_id)
        REFERENCES public."MEDICO" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

ALTER TABLE IF EXISTS public."MEDICO_HOSPITAL"
    OWNER to postgres;
	
CREATE TABLE public."ESPECIALIDAD"
(
    id serial,
    nombre character varying(120) NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS public."ESPECIALIDAD"
    OWNER to postgres;

CREATE TABLE public."MEDICO_ESPECIALIDAD"
(
    id serial,
    medico_id integer NOT NULL,
    especialidad_id integer NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT tabla2_medico FOREIGN KEY (medico_id)
        REFERENCES public."MEDICO" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT tabla2_especialidad FOREIGN KEY (especialidad_id)
        REFERENCES public."ESPECIALIDAD" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

ALTER TABLE IF EXISTS public."MEDICO_ESPECIALIDAD"
    OWNER to postgres;

-- datos de prueba
insert into "HOSPITAL" values(1,'Hospital Max Peralta', 'Cartago');
insert into "HOSPITAL" values(2,'Hospital San Rafael', 'Alajuela');
insert into "HOSPITAL" values(3,'Hospital San Vicente de Paul', 'Heredia');

insert into "MEDICO" values(1, '4-0071-0076', 'Gloria', 'Morales', 'Alajuela' );
insert into "MEDICO" values(2, '1-0651-0656', 'Andrea', 'Porras', 'Heredia' );
insert into "MEDICO" values(3, '4-9876-6535', 'Aurelio', 'Sanabria', 'Alajuela' );
insert into "MEDICO" values(4, '3-7879-8765', 'Jaime', 'Vargas', 'Cartago');

insert into "MEDICO_HOSPITAL" values(1, 2, 1);
insert into "MEDICO_HOSPITAL" values(2, 2, 1); -- aqui me equivoque (2, 1, 2)
insert into "MEDICO_HOSPITAL" values(3, 3, 4);

insert into "ESPECIALIDAD" values(1, 'Cardiologo');
insert into "ESPECIALIDAD" values(2, 'Alergologo');
insert into "ESPECIALIDAD" values(3, 'Pediatra');
insert into "ESPECIALIDAD" values(4, 'Nutricionista');

insert into "MEDICO_ESPECIALIDAD" values(1, 1, 1);
insert into "MEDICO_ESPECIALIDAD" values(2, 1, 2);
insert into "MEDICO_ESPECIALIDAD" values(3, 2, 3);
insert into "MEDICO_ESPECIALIDAD" values(4, 2, 4);
insert into "MEDICO_ESPECIALIDAD" values(5, 3, 4);
insert into "MEDICO_ESPECIALIDAD" values(6, 4, 4);

-- 1.1 Liste los datos de todos los hospitales que cuenten con almenos un cardiologo asociado
-- nombre-hospital x cedula-medico x nombre-medico x apellido x provincia_ubicacion

SELECT h.nombre,  me.cedula, me.nombre, me.primer_apellido, me.provincia_vivienda
FROM "HOSPITAL" as h 
INNER JOIN "MEDICO_HOSPITAL" as mh on h.id = mh.hospital_id
INNER JOIN "MEDICO" as me on me.id = mh.medico_id
INNER JOIN "MEDICO_ESPECIALIDAD" as mesp on mesp.medico_id = me.id
INNER JOIN "ESPECIALIDAD" as esp on esp.id = mesp.especialidad_id 
WHERE esp.nombre = 'Cardiologo'
ORDER BY h.nombre ASC;

-- 1.2 Liste todos los medicos con toos sus datos disponibles
-- medico: cedula x nombre x apellido x direccion-probincia
-- hospital: nombre ( de todos los hospitales donde esta registrado el medico )
-- especialidad: nombre ( de todas las especialidades del medico )

SELECT me.cedula, me.nombre, me.primer_apellido, me.provincia_vivienda, h.nombre, esp.nombre
FROM "MEDICO" as me
INNER JOIN "MEDICO_ESPECIALIDAD" as mesp on mesp.medico_id = me.id
RIGHT JOIN "ESPECIALIDAD" as esp on esp.id = mesp.especialidad_id
LEFT JOIN "MEDICO_HOSPITAL" as mh on me.id = mh.medico_id
LEFT JOIN "HOSPITAL" as h on h.id = mh.hospital_id
ORDER BY me.nombre ASC;

-- 1.3 Liste todos los hospitales y la especialidad medica con las que cuenta el personal medico asociado
-- hospital x nombre especialidad

SELECT h.nombre as "Hospital", esp.nombre as "Especialidad"
FROM "HOSPITAL" as h
LEFT JOIN "MEDICO_HOSPITAL" as mh on h.id = mh.hospital_id
LEFT JOIN "MEDICO" as me on mh.medico_id = me.id
LEFT JOIN "MEDICO_ESPECIALIDAD" as mesp on mesp.medico_id = me.id
LEFT JOIN "ESPECIALIDAD" as esp on esp.id = mesp.especialidad_id 
ORDER BY h.nombre ASC;

-- 2. Ejercicios de URI Online Judge
2.1) 2606
SELECT pd.id, pd.name
FROM products as pd
INNER JOIN categories as ct on pd.id_categories = ct.id
WHERE ct.name LIKE 'super%';

2.2) 2616
SELECT cus.name, ren.rentals_date
FROM customers as cus
INNER JOIN rentals as ren on ren.id_customers = cus.id
WHERE EXTRACT(MONTH FROM ren.rentals_date) = 9
AND EXTRACT(YEAR FROM ren.rentals_date) = 2016;

2.3) 2623
SELECT pr.name, cat.name
FROM products as pr
INNER JOIN categories as cat on pr.id_categories = cat.id
WHERE pr.amount > 100
AND (cat.id = 1 or cat.id = 2 or cat.id = 3 or cat.id = 6 or cat.id = 9)
ORDER BY cat.id ASC;