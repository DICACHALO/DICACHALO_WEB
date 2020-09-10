-- *******************************************************
-- INSTRUCCIONES PARA BORRAR LAS TABLAS                  *
-- *******************************************************
DROP TABLE tab_historico_evaluacion;
DROP TABLE tab_definicion;
DROP TABLE tab_concepto;
DROP TABLE tab_diccionario;
DROP TABLE tab_usuario;
DROP TABLE tab_respaldos;

-- *******************************************************
-- INSTRUCCIONES PARA CREAR LAS TABLAS DEL SISTEMA ACTUAL*
-- *******************************************************

CREATE TABLE tab_usuario --Esta tabla es para almacenar los datos de los usuarios registrados
(
  correo_electronico		VARCHAR(30)					NOT NULL,
  nickname					VARCHAR(12)					NOT NULL,    --Nombre único de usuario
  contrasena				SMALLINT					NOT NULL, 	 --Contraseña
  usr_insert           	 	VARCHAR(12)                 NOT NULL,	 --Aquí comienza la sección de auditoría //Usuario que inserta nuevo dato
  fec_insert            	TIMESTAMP WITHOUT TIME ZONE NOT NULL,    --Fecha de inserción
  usr_update                VARCHAR(12),  							 --Usuario que actualiza
  fec_update            	TIMESTAMP WITHOUT TIME ZONE,   			 --Fecha de actualización
  PRIMARY KEY (correo_electronico)
);

CREATE TABLE tab_diccionario
(
  id_diccionario			BIGINT,
  nom_diccionario			VARCHAR(30)					NOT NULL,	--Identificador de la tabla diccionario
  correo_electronico		VARCHAR(30) 				NOT NULL,	--Nombre asignado por usuario para el diccionario
  usr_insert           	 	VARCHAR(12)					NOT NULL,	--Aquí comienza la sección de auditoría  //Usuario que inserta nuevo dato
  fec_insert            	TIMESTAMP WITHOUT TIME ZONE NOT NULL,   --Fecha de inserción
  usr_update                VARCHAR(12),  							--Usuario que actualiza
  fec_update            	TIMESTAMP WITHOUT TIME ZONE,   			--Fecha de actualización
  PRIMARY KEY (id_diccionario),
  FOREIGN KEY (correo_electronico) REFERENCES tab_usuario(correo_electronico)
);

CREATE TABLE tab_concepto
(
  id_concepto     			BIGINT	    				NOT NULL,	--Identificador de la tabla concepto
  nom_concepto     			VARCHAR(15)   				NOT NULL,	--Nombre asignado por usuario para el concepto
  id_diccionario     		SMALLINT    				NOT NULL,	--Identificador de la tabla diccionario
  usr_insert           	 	VARCHAR(12)					NOT NULL,	--Aquí comienza la sección de auditoría  //Usuario que inserta nuevo dato
  fec_insert            	TIMESTAMP WITHOUT TIME ZONE NOT NULL,   --Fecha de inserción
  usr_update                VARCHAR(12),  							--Usuario que actualiza
  fec_update            	TIMESTAMP WITHOUT TIME ZONE,   			--Fecha de actualización
  PRIMARY KEY (id_concepto),
  FOREIGN KEY (id_diccionario) REFERENCES tab_diccionario (id_diccionario)
  );

CREATE TABLE tab_definicion
(
  id_definicion				BIGINT						NOT NULL, 	--Identificador de la tabla definición
  nom_definicion			VARCHAR(200)				NOT NULL, 	--Nombre asignado por usuario para la definición
  id_concepto				SMALLINT					NOT NULL, 	--Identificador de la tabla concepto
  usr_insert           	 	VARCHAR(12)					NOT NULL,	--Aquí comienza la sección de auditoría  //Usuario que inserta nuevo dato
  fec_insert            	TIMESTAMP WITHOUT TIME ZONE NOT NULL,   --Fecha de inserción
  usr_update                VARCHAR(12),  							--Usuario que actualiza
  fec_update            	TIMESTAMP WITHOUT TIME ZONE,   			--Fecha de actualización
  PRIMARY KEY (id_definicion),
  FOREIGN KEY (id_concepto) REFERENCES tab_concepto (id_concepto)
);

CREATE TABLE tab_historico_evaluacion
(
 id_evaluacion				BIGINT						NOT NULL, 	--Identificador para la tabla evaluación
 correo_electronico			VARCHAR(30) 				NOT NULL,	--Correo electronico que identifica al usuario
 puntaje					SMALLINT					NOT NULL, 	--Puntaje obtenido en esa evaluación
 usr_insert           	 	VARCHAR(12)					NOT NULL,	--Aquí comienza la sección de auditoría  //Usuario que inserta nuevo dato
 fec_insert            		TIMESTAMP WITHOUT TIME ZONE NOT NULL,   --Fecha de inserción
 usr_update                VARCHAR(12),  							--Usuario que actualiza
 fec_update            	TIMESTAMP WITHOUT TIME ZONE,   				--Fecha de actualización
 PRIMARY KEY (id_evaluacion, correo_electronico),
 FOREIGN KEY (correo_electronico) 	REFERENCES tab_usuario(correo_electronico)
);


-- **********************************************************************************
-- TABLA PARA TENER INFORMACION DEL USUARIO QUE BORRA ALGUN DATO DE CUALQUIER TABLA *
--  *********************************************************************************

CREATE TABLE tab_respaldos
(
 id_respaldo				BIGINT						NOT NULL,	--Identificador de la tabla respaldo 
 nom_tabla					VARCHAR						NOT NULL,	--Nombre de la tabla que fue eliminada
 usr_delete             	VARCHAR(12) 				NOT NULL,	--Nombre del usuario que elimina el registro
 fec_delete             	TIMESTAMP WITHOUT TIME ZONE NOT NULL,   --Fecha en la cual se ha eliminado el registro
PRIMARY KEY (id_respaldo)
);

-- ******************************************************************************************************
-- FUNCION AUDITORIA PARA TENER INFORMACION DE LAS ACTUALIZACIONES Y INSERCIONES DE DATOS EN LAS TABLAS *
-- ******************************************************************************************************

DROP FUNCTION fun_auditoria() CASCADE;
CREATE FUNCTION fun_auditoria() RETURNS "trigger"
 AS $$
 DECLARE wid_respaldo tab_respaldos.id_respaldo%TYPE;
 BEGIN
	 IF TG_OP = 'INSERT' THEN
	     NEW.usr_insert = CURRENT_USER;
	     NEW.fec_insert = CURRENT_TIMESTAMP;
	    RETURN NEW;
	 END IF;
	  
	 IF TG_OP = 'UPDATE' THEN
	     NEW.usr_update = CURRENT_USER;
	     NEW.fec_update = CURRENT_TIMESTAMP;
	       RETURN NEW;
	 END IF;
	  	  
	 IF TG_OP = 'DELETE' THEN
	    SELECT MAX(id_respaldo) INTO wid_respaldo FROM tab_respaldos;
	    IF wid_respaldo IS NULL OR wid_respaldo = 0 THEN wid_respaldo = 1;
	    ELSE
	    wid_respaldo = wid_respaldo + 1;
	    END IF;
	    INSERT INTO tab_respaldos VALUES (wid_respaldo, tg_table_name, CURRENT_USER, CURRENT_TIMESTAMP);
	    RETURN OLD;
	 END IF;
    RETURN NULL;
 END;
$$ LANGUAGE plpgsql;


-- ******************************************************************************************************
-- FUNCION PARA HACER NÚMEROS CONSECUTIVOS SIN NECESIDAD DEL CAMPO SERIAL *******************************
-- ******************************************************************************************************

DROP FUNCTION fun_id_diccionario() CASCADE;
CREATE FUNCTION fun_id_diccionario() RETURNS "trigger"
 AS $$
 DECLARE wid BIGINT;
 BEGIN
	SELECT MAX(id_diccionario) FROM tab_diccionario INTO wid;
	IF wid IS NULL OR wid = 0 THEN wid =1;
	NEW.id_diccionario=wid;
	RETURN NEW;
	ELSE
	wid=wid+1;
	NEW.id_diccionario=wid;
	RETURN NEW;
	END IF;
 RETURN NULL;
 END;
$$ LANGUAGE plpgsql;

DROP FUNCTION fun_id_concepto() CASCADE;
CREATE FUNCTION fun_id_concepto() RETURNS "trigger"
 AS $$
 DECLARE wid BIGINT;
 BEGIN
	 SELECT MAX(id_concepto) FROM tab_concepto INTO wid;
	 IF wid IS NULL OR wid = 0 THEN wid = 1;
	 NEW.id_concepto=wid;
	 RETURN NEW;
	 ELSE
	 wid = wid + 1;
	 NEW.id_concepto=wid;
	 RETURN NEW;
	 END IF;
	RETURN NEW;
 END;
$$ LANGUAGE plpgsql;
	  
DROP FUNCTION fun_id_definicion() CASCADE;
CREATE FUNCTION fun_id_definicion() RETURNS "trigger"
 AS $$
 DECLARE wid BIGINT;
 BEGIN
	  SELECT MAX(id_definicion) FROM tab_definicion INTO wid;
	  IF wid IS NULL OR wid = 0 THEN wid = 1;
	  NEW.id_definicion=wid;
	  RETURN NEW;
	  ELSE
	  wid = wid + 1;
	  NEW.id_definicion=wid;
	  RETURN NEW;
	  END IF;
	RETURN NEW;
 END;
$$ LANGUAGE plpgsql;
	  	 
DROP FUNCTION fun_id_evaluacion() CASCADE;
CREATE FUNCTION fun_id_evaluacion() RETURNS "trigger"
 AS $$
 DECLARE wid BIGINT;
 BEGIN
  SELECT MAX(id_evaluacion) FROM tab_historico_evaluacion INTO wid;
	  IF wid IS NULL OR wid = 0 THEN wid = 1;
		  NEW.id_evaluacion=wid;
		  RETURN NEW;
		  ELSE
		  wid = wid + 1;
		  NEW.id_evaluacion=wid;
		  RETURN NEW;
		  INSERT INTO tab_historico_evaluacion(id_evaluacion,correo_electronico,puntaje) VALUES (NEW.id_evaluacion,NEW.correo_electronico,NEW.puntaje);
      END IF;
	RETURN NULL;
 END;
$$ LANGUAGE plpgsql;
	  

-- *********************************************************************  
-- DISPARADORES PARA LAS ACTUALIZACIONES Y LAS INSERCION DE LAS TABLAS *
-- *********************************************************************

CREATE TRIGGER tri_auditoria
 BEFORE INSERT OR UPDATE ON tab_historico_evaluacion
 FOR EACH ROW EXECUTE PROCEDURE fun_auditoria();

CREATE TRIGGER tri_auditoria
 BEFORE INSERT OR UPDATE ON tab_definicion
 FOR EACH ROW EXECUTE PROCEDURE fun_auditoria();

CREATE TRIGGER tri_auditoria
 BEFORE INSERT OR UPDATE ON tab_concepto
 FOR EACH ROW EXECUTE PROCEDURE fun_auditoria();

CREATE TRIGGER tri_auditoria
 BEFORE INSERT OR UPDATE ON tab_diccionario
 FOR EACH ROW EXECUTE PROCEDURE fun_auditoria();

CREATE TRIGGER tri_auditoria
 BEFORE INSERT OR UPDATE ON tab_usuario
 FOR EACH ROW EXECUTE PROCEDURE fun_auditoria();

-- *******************************************************************************
-- DISPARADORES DE LA FUNCION RESPALDOS PARA LOS REGISTROS QUE HAN SIDO BORRADOS *
-- *******************************************************************************

CREATE TRIGGER tri_auditoriadelete
 AFTER DELETE ON tab_historico_evaluacion
 FOR EACH ROW EXECUTE PROCEDURE fun_auditoria();

CREATE TRIGGER tri_auditoriadelete
 AFTER DELETE ON tab_definicion
 FOR EACH ROW EXECUTE PROCEDURE fun_auditoria();

CREATE TRIGGER tri_auditoriadelete
 AFTER DELETE ON tab_concepto
 FOR EACH ROW EXECUTE PROCEDURE fun_auditoria();
 
CREATE TRIGGER tri_auditoriadelete
 AFTER DELETE ON tab_diccionario
 FOR EACH ROW EXECUTE PROCEDURE fun_auditoria();

CREATE TRIGGER tri_auditoriadelete
 AFTER DELETE ON tab_usuario
 FOR EACH ROW EXECUTE PROCEDURE fun_auditoria();


-- *******************************************************************************
-- DISPARADORES PARA GENERAR NÚMEROS DE IDENTIFICACIÓN DE TABLAS AUTOMÁTICOS *****
-- *******************************************************************************

CREATE TRIGGER tri_id_diccionario
BEFORE INSERT ON tab_diccionario
FOR EACH ROW EXECUTE PROCEDURE fun_id_diccionario();

CREATE TRIGGER tri_id_concepto
 BEFORE INSERT ON tab_concepto
 FOR EACH ROW EXECUTE PROCEDURE fun_id_concepto();

CREATE TRIGGER tri_id_definicion
 BEFORE INSERT ON tab_definicion
 FOR EACH ROW EXECUTE PROCEDURE fun_id_definicion();

CREATE TRIGGER tri_id_evaluacion
 BEFORE INSERT ON tab_historico_evaluacion
 FOR EACH ROW EXECUTE PROCEDURE fun_id_evaluacion();

--INSERTS PARAR PROBAR EL SCRIPT
INSERT INTO tab_usuario VALUES ('chaconlopezdiana@gmail.com','DICACHALO',12345);

INSERT INTO tab_diccionario (nom_diccionario, correo_electronico) VALUES ('BASE DE DATOS','chaconlopezdiana@gmail.com');
INSERT INTO tab_diccionario (nom_diccionario, correo_electronico) VALUES ('ALGORITMIA','chaconlopezdiana@gmail.com');
INSERT INTO tab_diccionario (nom_diccionario, correo_electronico) VALUES ('LENGUAJES DE PROGRAMACION','chaconlopezdiana@gmail.com');

INSERT INTO tab_concepto (nom_concepto,id_diccionario) VALUES ('ENTIDAD',1);
INSERT INTO tab_concepto (nom_concepto,id_diccionario) VALUES ('ESPECIALIZACIÓN',1);
INSERT INTO tab_concepto (nom_concepto,id_diccionario) VALUES ('GENERALIZACIÓN',1);
INSERT INTO tab_concepto (nom_concepto,id_diccionario) VALUES ('AGREGACIÓN',1);

INSERT INTO tab_definicion (nom_definicion, id_concepto) VALUES ('Un ente conceptual o físico del cual se desea tener información',1);
INSERT INTO tab_definicion (nom_definicion, id_concepto) VALUES ('Es el proceso de tomar un tipo de entidad y generar subtipos que tengan atributos específicos',2);
INSERT INTO tab_definicion (nom_definicion, id_concepto) VALUES ('Es el proceso de tomar un conjunto de tipos de entidades y abstraer sus atributos comunes en un tipo d eentidad padre o superior',3);
INSERT INTO tab_definicion (nom_definicion, id_concepto) VALUES ('Es una abstracción a través de la cual las relaciones se tratan como entidades de un nivel más alto',4);

INSERT INTO tab_historico_evaluacion (correo_electronico,puntaje) VALUES ('chaconlopezdiana@gmail.com',20);
INSERT INTO tab_historico_evaluacion (correo_electronico,puntaje) VALUES ('chaconlopezdiana@gmail.com',20);

--INSTRUCCIONES SQL DE PRUEBA
SELECT*FROM tab_usuario;
SELECT*FROM tab_diccionario;
DELETE FROM tab_diccionario WHERE id_diccionario=3;
SELECT*FROM tab_concepto;
SELECT*FROM tab_definicion;
SELECT*FROM tab_historico_evaluacion;

--INSTRUCCIONES SQL
--SELECT (correo_electronico, nickname) FROM tab_usuario;
--SELECT * FROM tab_definicion;
--UPDATE tab_concepto SET nom_concepto='ENTIDAD2' WHERE nom_concepto='ENTIDAD';
--SELECT * FROM tab_concepto ORDER BY 1;
--DELETE FROM tab_definicion WHERE id_definicion=1;
--SELECT * FROM tab_respaldos; 
--SELECT * FROM tab_definicion;
--SELECT PARA CORRELACIONAR CONCEPTOS CON DEFINICIONES
--SELECT nom_concepto, nom_definicion FROM tab_concepto, tab_definicion WHERE tab_concepto.id_concepto=tab_definicion.id_concepto;
