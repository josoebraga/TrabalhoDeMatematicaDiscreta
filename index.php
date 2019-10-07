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

include 'conectar.php';

$post = filter_input_array(INPUT_POST, FILTER_DEFAULT);

?>

<form method="POST">
<br>
<div id="divInputText">

<?php 

#$qsinputs = "SELECT * FROM md.inputs ORDER BY x DESC, y DESC, z DESC;";
$qsinputs = "SELECT * FROM md.inputs ORDER BY id ASC;";


$query = $pdo->prepare($qsinputs);
$query->execute();
  for($i=0; $escrever = $query->fetch(); $i++){
  
$id = $escrever['id'];

?>
x<?php echo $id; ?><input type='text' id="x<?php echo $id; ?>" name="x<?php echo $id; ?>" value="<?php echo $escrever['x']; ?>">
y<?php echo $id; ?><input type='text' id="y<?php echo $id; ?>" name="y<?php echo $id; ?>" value="<?php echo $escrever['y']; ?>">
z<?php echo $id; ?><input type='text' id="z<?php echo $id; ?>" name="z<?php echo $id; ?>" value="<?php echo $escrever['z']; ?>"> 
<button type="button" class="btn btn-danger" onclick="subInput(<?php echo $id; ?>);">-</button><br>
<?php
  }
?>
</div>
<input type="hidden" id="controle" name="controle" value="<?php echo $id; ?>"><br>

<br>
<button type="button" class="btn btn-primary" onclick="addInput();">+</button>
<button type="submit" class="btn btn-primary">Calcular</button>

</form>

<?php

if(!empty($post['x0']) && !empty($post['y0']) /*&& !empty($post['x1']) && !empty($post['y1'])*/) {


$statement = $pdo->prepare("TRUNCATE TABLE md.inputs;");
$statement->execute();
#Em breve, update pela coluna ID se não tiver valores;

for($i=0;$i<100;$i++) {
  if(!empty($post["x$i"])) { $qtdTOtal = $i; }
}

for($i=0;$i<($qtdTOtal+1);$i++) {
  $x = $post["x$i"];
  $y = $post["y$i"];
  $z = $post["z$i"];
if(!empty($x)) {  
$insert = "INSERT INTO md.inputs (id, X, Y, z, n) VALUES ('$i', '$x', '$y', '$z', null);";  # isnull $x0 = 0;
$statement = $pdo->prepare($insert);
$statement->execute();
}

}
  ?>
<script>
  window.location.replace('http://localhost/recursaomd/');
</script>
  <?php
}


?>

</body>

<script>

function addInput() {

  var val = 0;
  var inputText = "";
  val = document.getElementById('controle').value * 1 + 1 ;

for(i=0; i < val; i++) {

var valorX = document.getElementById('x'+i).value;
var valorY = document.getElementById('y'+i).value;
var valorZ = document.getElementById('z'+i).value;

  inputText  =  inputText + 
  " x" +i+"<input type='text' id='x"+i+"' name='x"+i+"' value='"+valorX+"'>"+ 
  " y"+i+"<input type='text' id='y"+i+"' name='y"+i+"' value='"+valorY+"'>" + 
  " z"+i+"<input type='text' id='z"+i+"' name='z"+i+"' value='"+valorZ+"'>" + 
  " <button type='button' class='btn btn-danger' onclick='subInput("+i+");'>-</button>" +"<br>";
}

inputText  =  inputText + 
  " x" +i+ "<input type='text' id='x"+i+"' name='x"+i+"' value='"+"0.0"+"'>"+ 
  " y"+i+"<input type='text' id='y"+i+"' name='y"+i+"' value='"+"0.0"+"'>" + 
  " z"+i+"<input type='text' id='z"+i+"' name='z"+i+"' value='"+"0.0"+"'>" +  
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
for(i=0; i < (val ); i++) {
var valorX = document.getElementById('x'+i).value;
var valorY = document.getElementById('y'+i).value;
var valorZ = document.getElementById('z'+i).value;

  if(i != posicao) {
    inputText  =  inputText + 
    " x" +id+ "<input type='text' id='x"+id+"' name='x"+id+"' value='"+valorX+"'>"+ 
    " y"+id+"<input type='text' id='y"+id+"' name='y"+id+"' value='"+valorY+"'>" + 
    " z"+id+"<input type='text' id='z"+id+"' name='z"+id+"' value='"+valorZ+"'>" + 
    " <button type='button' class='btn btn-danger' onclick='subInput("+i+");'>-</button>" +"<br>";
    id++;
  }
}

document.getElementById("divInputText").innerHTML = inputText;

document.getElementById("divInputText").innerHTML = inputText;

document.getElementById('controle').value = (id);  

}

</script>

</html>





