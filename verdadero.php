<?php  
include("conectar.php");
@session_start();
$id_usuario = $_SESSION['id_usuario']; //Numero de cedula del usuario 
$consulta ="SELECT respuesta FROM tab_test WHERE id_usuario=$id_usuario;";
$resultado = pg_query($consulta) or die ('Error. Intente de nuevo'. pg_last_error());
while ($fila = pg_fetch_array($resultado)){
if ($fila[0]==='t'){echo"<script>alert('La respuesta es correcta.');
          </script>";
    echo "<html>
		<head>
			<meta http-equiv='REFRESH' content='0;url=zona_juegos.php'>
		</head>
	</html>
	";}
else { echo"<script>alert('Respuesta equivocada.');
          </script> ";
          echo "
	<html>
		<head>
			<meta http-equiv='REFRESH' content='0;url=zona_juegos.php'>
		</head>
	</html>
	";
}
}

pg_close($dbconn);
?>