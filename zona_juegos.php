<!DOCTYPE html>
<!--[if IE 8]> <html lang="en" class="ie8"> <![endif]-->
<!--[if IE 9]> <html lang="en" class="ie9"> <![endif]-->
<!--[if !IE]><!--> <html lang="en"> <!--<![endif]-->
<!-- BEGIN HEAD -->
<head>
    <meta charset="UTF-8" />
    <title>DIP </title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
	<meta content="" name="description" />
	<meta content="" name="author" />
	<link rel="icon" href="images/favicon.ico" type="image/x-icon">  

     <!--[if IE]>
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <![endif]-->
    <!-- GLOBAL STYLES -->
    <link rel="stylesheet" href="assets/plugins/bootstrap/css/bootstrap.css" />
    <link rel="stylesheet" href="assets/css/main2.css" />
    <link rel="stylesheet" href="assets/css/theme.css" />
    <link rel="stylesheet" href="assets/css/MoneAdmin.css" />
    <link rel="stylesheet" href="assets/plugins/Font-Awesome/css/font-awesome.css" />
    <!--END GLOBAL STYLES -->

    <!-- PAGE LEVEL STYLES -->
    <link href="assets/css/layout2.css" rel="stylesheet" />
    <link href="assets/plugins/flot/examples/examples.css" rel="stylesheet" />
    <link rel="stylesheet" href="assets/plugins/timeline/timeline.css" />
    <!-- END PAGE LEVEL  STYLES -->
     <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
      <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
    <![endif]-->

</head>

    <!-- END HEAD -->

    <!-- BEGIN BODY -->
<body class="padTop53 " >

    <!-- MAIN WRAPPER -->
    <div id="wrap" >
        

        <!-- HEADER SECTION -->
        <div id="top">

            <nav class="navbar navbar-inverse navbar-fixed-top" style="padding-top: 10px;">
                <a data-original-title="Show/Hide Menu" data-placement="bottom" data-tooltip="tooltip" class="accordion-toggle btn btn-primary btn-sm visible-xs" data-toggle="collapse" href="#menu" id="menu-toggle">
                    <i class="icon-align-justify"></i>
                </a>
                <!-- LOGO SECTION -->
                <header class="navbar-header">
                    <!--<a href="index.html" class="navbar-brand"><img src="assets/img/logo.png" alt="" /></a>-->
                </header>
                <!-- END LOGO SECTION -->
                <ul class="nav navbar-top-links navbar-right"></ul>
            </nav>
        </div>
        <!-- END HEADER SECTION -->

        <!-- MENU SECTION -->
      <div id="left" >
        <div class="media user-media well-small">
                <br>
                <?php
					  @session_start();
                      include("conectar.php");

            require_once('functions.php');
            noCache();


                      $id_usuario=$_SESSION['id_usuario'];
                      if(!isset($_SESSION['id_usuario'])){ 
                            Header("Location:login.html"); //si el ususario no esta logeado 
                        }
                      $consulta = "SELECT foto FROM tab_usuario WHERE id_usuario=$id_usuario";
                      $resultado = pg_query($consulta)or die ('Error. Intente de nuevo'. pg_last_error());
                      while ($fila = pg_fetch_array($resultado)){
                     
                      echo "<img class='media-object img-thumbnail user-img' alt='User Picture' src='".$fila[0]."''>";
                      }
                                          
                      pg_close($dbconn);

                        ?>


                <br />
                <div class="media-body">
                    <h6 class="media-heading"> Usuario: </h6>
                    <ul class="list-unstyled user-info">
                    </ul>
  

<div class="media-body">
<ul id="menu" class="collapse">               
<li class="panel">
                    <a href="home.php" data-parent="#menu" data-toggle="collapse" class="accordion-toggle" data-target="#pagesr-nav">

<h6 class="media-heading">
                   <?php
            @session_start();
            include("conectar.php");
            $id_usuario=$_SESSION['id_usuario'];
            $consulta = "SELECT nom_usuario, apell_usuario FROM tab_usuario WHERE id_usuario=$id_usuario";
            $resultado = pg_query($consulta)or die ('Error. Intente de nuevo'. pg_last_error());
            while ($fila = pg_fetch_array($resultado)){
            echo $fila[0]. " ".$fila[1];}
            pg_close($dbconn);
            ?> 
                    </h6></a></li></ul> </br></a></li></ul></div>
                </div>
                <br/>
           </div>

        </div>
        <!--END MENU SECTION -->

        <!--PAGE CONTENT -->
        <div id="content">     
            <div class="inner" style="min-height: 700px;">
                <div class="row">
                    <div class="col-lg-12">
                        <h1><center>Bienvenido</center></h1>
                    </div>
                </div>
                  <hr/>                           

                 <!--  SECCIÓN CENTRAL   -->
                <div class="row">
                  <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">                   
                    	<div id="diccionario" class="tab-pane">
                <form action="" method="POST" class="form-signin">
                <p class="text-muted text-center btn-block btn btn-primary btn-rect">Seleccione un diccionario para jugar</p><br>
                <?php 
                @session_start();
                include("conectar.php");
                $id_usuario=$_SESSION['id_usuario'];
                $orden="SELECT id_diccionario, nom_diccionario FROM tab_diccionario WHERE id_usuario=$id_usuario;"; // Realizando una consulta SQL
                if($consulta=pg_query($orden))
                {echo "<select required name='id_diccionario' id='id_diccionario' class='form-control'>
                                <option selected='selected' value=''>Opciones </option>";
                                while($fila=pg_fetch_row($consulta)) //Bucle para mostrar todos los registros
                                    {
                                      $id_diccionario=$fila[0];
                                      $nom_diccionario=$fila[1];
                                      echo ' <option value="'.$id_diccionario.'">'.$nom_diccionario.'</option>';
                                    }

                                echo '</select></td>'; }
                echo '<br/><button class="btn btn-default btn-primary" name="enviar_diccionario" type="submit">ENVIAR</button></form><br>';


                    if (isset($_POST['enviar_diccionario'])){
 

                    $id_usuario = $_SESSION['id_usuario']; //Numero de cedula del usuario 
                    $id_diccionario=$_POST['id_diccionario'];
                    $sql = "SELECT fun_test($id_diccionario,$id_usuario)";
                    $rs = pg_query($sql) or die ('Error. Intente de nuevo'. pg_last_error());
                    $consulta ="SELECT concepto, significado FROM tab_test WHERE id_usuario=$id_usuario;";
                    $resultado = pg_query($consulta) or die ('Error. Intente de nuevo'. pg_last_error());
                    //Imprimir la consulta
                    echo "
                    <table class='table table-striped table-bordered table-hover'>
                    <tr>
                    <th><center>CONCEPTO</center></th>
                    <th><center>DEFINICION</center></th>
                    </tr>
                    ";

                    while ($fila = pg_fetch_array($resultado)){
                    echo "<tr><td>".$fila['concepto']."</td>
                          <td>".$fila['significado']."</td>";
                    }

                    echo "</table><a href='falso.php' class='btn btn-danger btn-grad'>FALSO</a>
                          <a href='verdadero.php' class='btn btn-success btn-grad'>VERDADERO</a>";
                    echo "<br><hr>";

                    pg_close($dbconn);}

                                ?>
                                </div>
            
                        

                        <div class="panel-heading">
                          

                    
                    
                
                          </div>
                        </div>   
                    </div>
                  </div>                  
                </div>
                 <!--FIN SECCIÓN CENTRAL  -->
            </div>
        </div>
        <!--END PAGE CONTENT -->


         <!-- RIGHT STRIP  SECTION -->
        <div id="right">
            <div class="well well-small">
            
            	<form action="configuracion.php">
                <button type="submit" name="config"class="btn btn-info btn-block">Configuración</button>
                </form>
                <br>
                <form action="pass.html">
                <button type="submit" name="pass"class="btn btn-info btn-block">Contraseña</button>         
                </form>
                <br>
                <form action="salir.php">
                <button type="submit" class="btn btn-success btn-block">Salir</button>
                </form>
            </div>
            
            </div>
        </div>
         <!-- END RIGHT STRIP  SECTION -->
    </div>

    <!--END MAIN WRAPPER -->


    <!-- GLOBAL SCRIPTS -->
    <script src="assets/plugins/jquery-2.0.3.min.js"></script>
    <script src="assets/plugins/bootstrap/js/bootstrap.min.js"></script>
    <script src="assets/plugins/modernizr-2.6.2-respond-1.1.0.min.js"></script>
    <!-- END GLOBAL SCRIPTS -->

    <!-- PAGE LEVEL SCRIPTS -->
    <script src="assets/plugins/flot/jquery.flot.js"></script>
    <script src="assets/plugins/flot/jquery.flot.resize.js"></script>
    <script src="assets/plugins/flot/jquery.flot.time.js"></script>
    <script src="assets/plugins/flot/jquery.flot.stack.js"></script>
    <script src="assets/js/for_index.js"></script>
   
    <!-- END PAGE LEVEL SCRIPTS -->

</body>
    <!-- END BODY -->
</html>