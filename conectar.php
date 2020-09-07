<?php //Archivo para conectarse een la base de datos de forma local
$dbconn = pg_connect("host=localhost
					  port=5432 
					  dbname=db_DIP
					  user=postgres 
					  password=postgresql")
or die('No se ha podido conectar: ' . pg_last_error());
?>