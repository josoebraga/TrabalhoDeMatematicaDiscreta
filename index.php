<!DOCTYPE html>

<head>
    <title>Trabalho de Mátemática Discreta - Josoé Schmidt Braga</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
</head>

<body>
  

<?php
#https://www.easycalculation.com/algebra/gauss-seidel-method.php
include 'sqlsrv.php';
$post = filter_input_array(INPUT_POST, FILTER_DEFAULT);
$get = filter_input_array(INPUT_GET, FILTER_DEFAULT);

$qsCriterioDeParadaUser = "SELECT * FROM criterio_parada_user;";
$query = $pdo->prepare($qsCriterioDeParadaUser);
$query->execute();
  for($i=1; $escrever = $query->fetch(); $i++){
    $criterioDeParadaUser = $escrever['valor'];
  }

?>

<form method="POST">
<br>
<Span>Critério de Parada (Usuário): </Span><input type="text" id="criterioDeParadaUser" name="criterioDeParadaUser" value="<?php echo number_format($criterioDeParadaUser, 7); ?>">
&hArr;
<Span>Critério de Parada (System):  </Span><input type="text" id="criterioDeParada" name="criterioDeParada" value="x1<=1"readonly>
<br><br>
<!-- <Span>Arredontamento:  </Span><input type="number" id="arredontamento" name="arredontamento" value="5">
<br><br>
 --><div id="divInputText">

<?php 
#$qsinputs = "SELECT * FROM md.inputs ORDER BY x DESC, y DESC, z DESC;";
$qsinputs = "SELECT * FROM inputs ORDER BY id ASC;";
$query = $pdo->prepare($qsinputs);
$query->execute();
  for($i=1; $escrever = $query->fetch(); $i++){
  
$id = $escrever['id'];
?>
a<?php echo $id.'1'; ?><input type='text' id="a<?php echo $id.'1'; ?>" name="a<?php echo $id.'1'; ?>" value="<?php echo number_format($escrever['x1'], 15, '.', ','); ?>">
a<?php echo $id.'2'; ?><input type='text' id="a<?php echo $id.'2'; ?>" name="a<?php echo $id.'2'; ?>" value="<?php echo number_format($escrever['x2'], 15, '.', ','); ?>">
a<?php echo $id.'3'; ?><input type='text' id="a<?php echo $id.'3'; ?>" name="a<?php echo $id.'3'; ?>" value="<?php echo number_format($escrever['x3'], 15, '.', ','); ?>"> 
b<?php echo $id; ?><input type='text' id="b<?php echo $id; ?>"         name="b<?php echo $id; ?>"     value="<?php echo number_format($escrever['b'], 15, '.', ','); ?>"> 
<button type="button" class="btn btn-danger" onclick="subInput(<?php echo $id; ?>);">-</button><br>
<?php
  }
  if($id == '') { 
    $insert = "INSERT INTO inputs (id, x1, x2, x3, b) VALUES (1, 0.0, 0.0, 0.0, 0.0);"; echo"<br>";  # isnull $x0 = 0;
    $statement = $pdo->prepare($insert);
    $statement->execute();
    ?>
    <script>
      window.location.replace('http://localhost/recursaomd/');
    </script>
      <?php
    } 
?>
</div>
<input type="hidden" id="controle" name="controle" value="<?php echo $id; ?>"><br>

<br>
<button type="button" class="btn btn-primary" onclick="addInput();">+</button>
<button type="submit" class="btn btn-primary">Salvar</button>
<button type="submit" id="calcular" name="calcular" class="btn btn-primary" value="calcular">Calcular</button>

</form>
<br>
<div id="divCalculo">

</div>


<?php

$calcular = $get['result'];


if(!empty($post['a11'] && $calcular == '') /*&& !empty($post['x1']) && !empty($post['y1'])*/) {
  $criterioDeParadaUser = $post['criterioDeParadaUser'];
  $statement = $pdo->prepare("TRUNCATE TABLE inputs;");$statement->execute();
$qtdTOtal = $post["controle"];
for($i=1;$i<($qtdTOtal+1);$i++) {
  $a1 = $post["a$i"."1"];
  $a2 = $post["a$i"."2"];
  $a3 = $post["a$i"."3"];
  $b =   $post["b$i"];
if(!empty($a1)) {  
  $insert = "INSERT INTO inputs (id, x1, x2, x3, b) VALUES ($i, $a1, $a2, $a3, $b);";
  $statement = $pdo->prepare($insert);
  $statement->execute();
} 
}

if(!empty($criterioDeParadaUser)) {
  $statement = $pdo->prepare("truncate table criterio_parada_user");
  $statement->execute();

  $insert = "INSERT INTO criterio_parada_user (valor) VALUES ($criterioDeParadaUser);";
  $statement = $pdo->prepare($insert);
  $statement->execute();
} 



  ?>
<script>
  window.location.replace('http://localhost/recursaomd/index.php?result=calcular');
</script>
  <?php
}

if($calcular != '') {

  $autorizaReordena = 1; #Fazer aparecer um radio caso não atinja os critérios, para que o usuário possa escolher

$sp = "exec sp_calcula_sistema_linear $autorizaReordena;";
$query = $pdo->prepare($sp);
$query->execute();

$qsResultado = "select distinct id, x1, x2, x3 from ##tmpValores order by id asc;";
$query = $pdo->prepare($qsResultado);
$query->execute();


/* for($i=1; $escrever = $query->fetch(); $i++){
    echo $escrever['x1'].'<br>';
  } */

?>
<h4>Resultado das Iterações</h4>
<div class="table-responsive">
<table class="table">
  <thead>
    <tr>
      <th scope="col">Iteração</th>
      <th scope="col">X1</th>
      <th scope="col">X2</th>
      <th scope="col">X3</th>
    </tr>
  </thead>
  <tbody>
<?php 
for($i=1; $escrever = $query->fetch(); $i++) {
  ?>    
    <tr>
      <th scope="row"><?php echo $i; ?></th>
      <td><?php echo $x1 = $escrever['x1']; ?></td>
      <td><?php echo $x2 = $escrever['x2']; ?></td>
      <td><?php echo $x3 = $escrever['x3']; ?></td>
    </tr>
<?php } ?>
  </tbody>
</table>
</div>


<?php } ?>

<h4>Prova...</h4>

<?php  

$qsinputs = "SELECT * FROM inputs ORDER BY id ASC;";
$query = $pdo->prepare($qsinputs);
$query->execute();
for($i=1; $escrever = $query->fetch(); $i++){
  
echo number_format($escrever['x1'], 15, '.', ',').'*'.$x1.'+'.number_format($escrever['x2'], 15, '.', ',').'*'.$x2.'+'.number_format($escrever['x3'], 15, '.', ',').'*'.$x3.' = '.($escrever['x1']*$x1 + $escrever['x2']*$x2 + $escrever['x3']*$x3).'<br>';
  
}

# Lembrar: Erro absoluto e relativo são em módulo?

?>



</body>



<script>
function addInput() {
  var val = 0;
  var inputText = "";
  val = document.getElementById('controle').value * 1 + 1 ;
for(i=1; i < val; i++) {
var valorX = document.getElementById('a'+i+"1").value;
var valorY = document.getElementById('a'+i+"2").value;
var valorZ = document.getElementById('a'+i+"3").value;
var valorN = document.getElementById('b'+i).value;
  inputText  =  inputText + 
  " a"+i+"1<input type='text' id='a"+i+"1' name='a"+i+"1' value='"+valorX+"'>"+ 
  " a"+i+"2<input type='text' id='a"+i+"2' name='a"+i+"2' value='"+valorY+"'>" + 
  " a"+i+"3<input type='text' id='a"+i+"3' name='a"+i+"3' value='"+valorZ+"'>" + 
  " b"+i+"<input type='text'  id='b"+i+"'  name='b"+i+"'  value='"+valorN+"'>" + 
  " <button type='button' class='btn btn-danger' onclick='subInput("+i+");'>-</button>" +"<br>";
}
inputText  =  inputText + 
  " a"+i+"1<input type='text' id='a"+i+"1' name='a"+i+"1' value='"+"0.0"+"'>"+ 
  " a"+i+"2<input type='text' id='a"+i+"2' name='a"+i+"2' value='"+"0.0"+"'>" + 
  " a"+i+"3<input type='text' id='a"+i+"3' name='a"+i+"3' value='"+"0.0"+"'>" +  
  " b"+i+"<input type='text'  id='b"+i+"'  name='b"+i+"'  value='"+"0.0"+"'>" +  
  " <button type='button' class='btn btn-danger' onclick='subInput("+i+");'>-</button>" +"<br>";
document.getElementById("divInputText").innerHTML = inputText;
document.getElementById('controle').value = val;  
}
</script>

<script>
function subInput(posicao) {
//id="controle" = xyz;
  
  var val = 0;
  var inputText = "";
  val = document.getElementById('controle').value * 1 + 1 ;
id = 0;
for(i=1; i < (val ); i++) {
var valorX = document.getElementById('a'+i+"1").value;
var valorY = document.getElementById('a'+i+"2").value;
var valorZ = document.getElementById('a'+i+"3").value;
var valorN = document.getElementById('b'+i).value;
  if(i != posicao) {
    inputText  =  inputText + 
  " a"+i+"1<input type='text' id='a"+i+"1' name='a"+i+"1' value='"+valorX+"'>"+ 
  " a"+i+"2<input type='text' id='a"+i+"2' name='a"+i+"2' value='"+valorY+"'>" + 
  " a"+i+"3<input type='text' id='a"+i+"3' name='a"+i+"3' value='"+valorZ+"'>" + 
  " b"+i+"<input type='text'  id='b"+i+"'  name='b"+i+"'  value='"+valorN+"'>" + 
  " <button type='button' class='btn btn-danger' onclick='subInput("+i+");'>-</button>" +"<br>";
    id++;
  }
}
document.getElementById("divInputText").innerHTML = inputText;
document.getElementById("divInputText").innerHTML = inputText;
document.getElementById('controle').value = (id-1);  
}
</script>

</html>
