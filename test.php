<?php
include("conectar.php");
@session_start();
echo "<br>";
echo "<br>";
echo "<h1>BIENVENID@ ".$_SESSION['id_usuario']."</h1>";

//ESTABLECER una consulta

$consulta = 'SELECT concepto, significado FROM tab_test';

//Ejecutar la consulta
$resultado = pg_query($consulta)or die ('Error. Intente de nuevo'. pg_last_error());
//Imprimir la consulta
echo "
<table class='alt' border='1'>
<tr>
<th><center>CONCEPTO</center></th>
<th><center>DEFINICION</center></th>
<th><center>FALSO</center></th>
<th><center>VERDADERO</center></th>
</tr>
";

while ($fila = pg_fetch_array($resultado)){
echo "<tr><td>".$fila['concepto']."</td>
		  <td>".$fila['significado']."</td>
		  <td></td><td></td>";
}

echo "</table>";
echo "<br><hr>";

pg_close($dbconn);
?>