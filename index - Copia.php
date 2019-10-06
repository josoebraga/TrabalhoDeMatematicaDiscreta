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


function fatorial ($num) {
    if ($num <= 1) {
    
    return (1);
    
    }
    
    else {
    
    return ($num * fatorial ($num - 1));
    
    }
    
    }

  echo fatorial (4).'<br>';
  echo gmp_fact (4);


?>

<form method="POST">

<input type="hidden" id="controle" name="controle" value="1"><br>

<div id="divInputText">x0<input type='text' id='x0' name='x0'>y0<input type='text' id='y0' name='y0'>z0<input type='text' id='z0' name='z0'><br></div>

<br>
<button type="button" class="btn btn-primary" onclick="addInput();">+</button>
<button type="submit" class="btn btn-primary">Calcular</button>

</form>

<?php

if(!empty($post['x0']) && !empty($post['y0']) /*&& !empty($post['x1']) && !empty($post['y1'])*/) {

#  include 'variaveis.php';
#SELECT * FROM md.inputs ORDER BY x DESC, y DESC;

$statement = $pdo->prepare("TRUNCATE TABLE md.inputs;");
$statement->execute();

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
  


#echo 'aaa';


}


?>

</body>

<script>

function addInput() {
  var val = 0;
  var inputText = "";
  val = document.getElementById('controle').value * 1 + 1 ;

for(i=0; i < val; i++) {
  inputText  =  inputText + "x" + i + "<input type='text' id='x"+i+"' name='x"+i+"'>"+ "y"+i+"<input type='text' id='y"+i+"' name='y"+i+"'>" + "z"+i+"<input type='text' id='z"+i+"' name='z"+i+"'>" +"<br>";

}
document.getElementById("divInputText").innerHTML = inputText;

document.getElementById('controle').value = val;  

}

</script>


</html>





