-- Fecha: 24 de abril de 2017
-- Servidor: LINUX CENTOS 7
-- Versión de PHP: 5.4.16 
-- Base de datos: PostgreSQL version 9.4.7 nombre=DIP
-- Programadora: Diana Carolina Chacón López 


-- *******************************************************
-- INSTRUCCIONES PARA BORRAR LAS TABLAS                  *
-- *******************************************************
DROP TABLE tab_significado;
DROP TABLE tab_concepto;
DROP TABLE tab_diccionario;
DROP TABLE tab_usuario;
DROP TABLE tab_test;


-- *******************************************************
-- INSTRUCCIONES PARA CREAR LAS TABLAS DEL SISTEMA ACTUAL*
-- *******************************************************

CREATE TABLE tab_usuario(  								--Un usuario es el que interactúa con el sistema, al cual debemos controlar para validar qué puede o no hacer
 id_usuario 			    BIGINT		 NOT NULL,	 	--Cédula del usuario
 foto 					    VARCHAR(100) NULL DEFAULT 'uploads/fotoperfil.jpg',		--Espacio para guardar directorio de la foto del usuario
 nom_usuario			    VARCHAR(30)	 NOT NULL,	 	--nombre del usuario
 apell_usuario		    	VARCHAR(30)	 NOT NULL,		--Apellido del usuario
 celular				    BIGINT			 NULL,		    --Número de celular del usuario
 correo_electronico			VARCHAR(50)	 NOT NULL,		--Correo electrónico del usuario
 clave					    VARCHAR(100) NOT NULL,		--Contraseña de ingreso al sistema
 pregunta				    VARCHAR(100) NULL,		    --Pregunta de seguridad para recuperar contraseña
 respuesta				    VARCHAR(100) NULL,		    --Respuesta de seguridad para recuperar contraseña
 PRIMARY KEY (id_usuario)
);

CREATE TABLE tab_diccionario
(
  id_diccionario			BIGINT,
  nom_diccionario			VARCHAR(30)				NOT NULL,	--Identificador de la tabla diccionario
  id_usuario				BIGINT						NOT NULL,	 	--cedula del usuario
  PRIMARY KEY (id_diccionario),
  FOREIGN KEY (id_usuario) REFERENCES tab_usuario (id_usuario)
);

CREATE TABLE tab_concepto
(
  id_concepto     			BIGINT	    				NOT NULL,	--Identificador de la tabla concepto
  concepto     				VARCHAR(50)   				NOT NULL,	--Nombre asignado por usuario para el concepto
  id_diccionario     		SMALLINT    				NOT NULL,	--Identificador de la tabla diccionario
  PRIMARY KEY (id_concepto),
  FOREIGN KEY (id_diccionario) REFERENCES tab_diccionario (id_diccionario)
  );

CREATE TABLE tab_significado
(
  id_significado    	BIGINT	    				NOT NULL,	--Identificador de la tabla significado
  significado 				VARCHAR(500)				NOT NULL,	--Palabras atribuidas al concepto
  id_concepto	     		SMALLINT    				NOT NULL,	--Identificador de la tabla concepto
  id_diccionario     	SMALLINT    				NOT NULL,	--Identificador de la tabla diccionario
  PRIMARY KEY (id_significado),
  FOREIGN KEY (id_concepto) REFERENCES tab_concepto (id_concepto),
  FOREIGN KEY (id_diccionario) REFERENCES tab_diccionario (id_diccionario)
  );

CREATE TABLE tab_test
(
  id_test					BIGINT					NOT NULL, --Identificador de la tabla test
  id_concepto     BIGINT	    		NOT NULL,	--Identificador de la tabla concepto
  concepto     		VARCHAR(50)   	NOT NULL,	--Nombre asignado por usuario para el concepto
  id_significado  BIGINT	    		NOT NULL,	--Identificador de la tabla significado
  significado 		VARCHAR(500)		NOT NULL,	--Palabras atribuidas al concepto
  respuesta 			BOOLEAN					NOT NULL, --Verifica si el concepto y el significado corresponden
  id_usuario      BIGINT          NOT NULL, --Cédula del usuario
  PRIMARY KEY (id_test),
  FOREIGN KEY (id_usuario) REFERENCES tab_usuario (id_usuario)
  );

-- ******************************************************************************************************
-- FUNCION PARA HACER NÚMEROS CONSECUTIVOS SIN NECESIDAD DEL CAMPO SERIAL *******************************
-- ******************************************************************************************************

DROP FUNCTION fun_id_diccionario() CASCADE;
CREATE FUNCTION fun_id_diccionario() RETURNS "trigger"
 AS $$
 DECLARE wid INTEGER;
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
 DECLARE wid INTEGER;
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

DROP FUNCTION fun_id_significado() CASCADE;
CREATE FUNCTION fun_id_significado() RETURNS "trigger"
 AS $$
 DECLARE wid INTEGER;
 BEGIN
	 SELECT MAX(id_significado) FROM tab_significado INTO wid;
	 IF wid IS NULL OR wid = 0 THEN wid = 1;
	 NEW.id_significado=wid;
	 NEW.id_concepto=wid;
	 RETURN NEW;
	 ELSE
	 wid = wid + 1;
	 NEW.id_significado=wid;
	 NEW.id_concepto=wid;
	 RETURN NEW;
	 END IF;
	RETURN NEW;
 END;
$$ LANGUAGE plpgsql;	 

DROP FUNCTION fun_id_test() CASCADE;
CREATE FUNCTION fun_id_test() RETURNS "trigger"
 AS $$
 DECLARE wid INTEGER;
 BEGIN
	SELECT MAX(id_test) FROM tab_test INTO wid;
	IF wid IS NULL OR wid = 0 THEN wid =1;
	NEW.id_test=wid;
	RETURN NEW;
	ELSE
	wid=wid+1;
	NEW.id_test=wid;
	RETURN NEW;
	END IF;
 RETURN NULL;
 END;
$$ LANGUAGE plpgsql; 

-- *******************************************************************************
-- DISPARADORES PARA GENERAR NÚMEROS DE IDENTIFICACIÓN DE TABLAS AUTOMÁTICOS *****
-- *******************************************************************************

CREATE TRIGGER tri_id_diccionario
BEFORE INSERT ON tab_diccionario
FOR EACH ROW EXECUTE PROCEDURE fun_id_diccionario();

CREATE TRIGGER tri_id_concepto
 BEFORE INSERT ON tab_concepto
 FOR EACH ROW EXECUTE PROCEDURE fun_id_concepto();

CREATE TRIGGER tri_id_significado
 BEFORE INSERT ON tab_significado
 FOR EACH ROW EXECUTE PROCEDURE fun_id_significado();

CREATE TRIGGER tri_id_test
 BEFORE INSERT ON tab_test
 FOR EACH ROW EXECUTE PROCEDURE fun_id_test();

--ADMINISTRADOR DEL PROGRAMA
INSERT INTO tab_usuario (id_usuario,nom_usuario,apell_usuario,celular,correo_electronico,clave) VALUES (1234,'USUARIO ROOT','DEL SISTEMA',0,'usuario@usuario.com','MTIzNA==');

-- *******************************************************************************
-- FUNCIÓN PARA REALIZAR EL PRIMER JUEGO DE DIP **********************************
-- *******************************************************************************
-- Se requiere que primero se haya insertado un concepto para que se pueda implementar

DROP FUNCTION fun_test(diccionario_seleccionado integer, usuario bigint);
CREATE OR REPLACE FUNCTION fun_test(diccionario_seleccionado integer, usuario bigint)
  RETURNS character varying AS
$BODY$
    DECLARE wcursor1              REFCURSOR;
    DECLARE wregistro1            RECORD;
    DECLARE wcursor2              REFCURSOR;
    DECLARE wregistro2            RECORD;
  BEGIN
      TRUNCATE TABLE tab_test;
      
      OPEN wcursor1 for SELECT a.id_concepto as A, a.concepto as B FROM tab_concepto a, tab_usuario b WHERE a.id_diccionario=diccionario_seleccionado and b.id_usuario=usuario ORDER BY random();
      FETCH wcursor1 INTO wregistro1;
      OPEN wcursor2 for SELECT c.id_significado as C, c.significado as D FROM tab_significado c, tab_usuario b WHERE c.id_diccionario=diccionario_seleccionado and b.id_usuario=usuario ORDER BY random();
      FETCH wcursor2 INTO wregistro2;
      IF wregistro1.A=wregistro2.C THEN 
      INSERT INTO tab_test (id_concepto,concepto,id_significado,significado,respuesta,id_usuario) VALUES (wregistro1.A,wregistro1.B,wregistro2.C,wregistro2.D,true,usuario);  
      ELSE
      INSERT INTO tab_test (id_concepto,concepto,id_significado,significado,respuesta,id_usuario) VALUES (wregistro1.A,wregistro1.B,wregistro2.C,wregistro2.D,false,usuario);
     
END IF;
      CLOSE wcursor1;
      CLOSE wcursor2;               
  RETURN 'OK';
  END;
  $BODY$
  LANGUAGE plpgsql;

SELECT fun_test(1,1234);
--SELECT * FROM tab_test;
--SELECT a.id_concepto, a.concepto FROM tab_concepto a, tab_usuario b WHERE a.id_diccionario=1 and b.id_usuario=1234;
--SELECT a.id_concepto, a.concepto FROM tab_concepto a, tab_usuario b WHERE a.id_diccionario=2 and b.id_usuario=1234;