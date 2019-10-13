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
?>

<form method="POST">
<br>
<Span>Critério de Parada (Usuário): </Span><input type="text" id="criterioDeParada" name="criterioDeParada">
&hArr;
<Span>Critério de Parada (System):  </Span><input type="text" id="criterioDeParada" name="criterioDeParada" value="0.001"readonly>
<br><br>
<Span>Arredontamento:  </Span><input type="number" id="arredontamento" name="arredontamento" value="5">
<br><br>
<div id="divInputText">

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
<button type="button" class="btn btn-primary" onclick="calcular();">Calcular</button>

</form>
<br>
<div id="divCalculo">

</div>


<?php
if(!empty($post['a11']) /*&& !empty($post['x1']) && !empty($post['y1'])*/) {
$statement = $pdo->prepare("TRUNCATE TABLE inputs;");
$statement->execute();
$qtdTOtal = $post["controle"];
for($i=1;$i<($qtdTOtal+1);$i++) {
  $a1 = $post["a$i"."1"];
  $a2 = $post["a$i"."2"];
  $a3 = $post["a$i"."3"];
  $b =   $post["b$i"];
if(!empty($a1)) {  
  $insert = "INSERT INTO inputs (id, x1, x2, x3, b) VALUES ($i, $a1, $a2, $a3, $b);"; echo"<br>";  # isnull $x0 = 0;
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
function calcular() {
arred = document.getElementById("arredontamento").value; 
var texto = "";  
var i = 0 * 1;
var resultX0 = 0;
var b1 = document.getElementById("n0").value * 1; 
var b2 = document.getElementById("n1").value * 1;  
var b3 = document.getElementById("n2").value * 1;  
var a11 = document.getElementById("x0").value * 1;  
var a21 = document.getElementById("x1").value * 1;  
var a31 = document.getElementById("x2").value * 1;  
var a12 = document.getElementById("y0").value * 1;  
var a22 = document.getElementById("y1").value * 1;  
var a32 = document.getElementById("y2").value * 1;  
var a13 = document.getElementById("z0").value * 1;  
var a23 = document.getElementById("z1").value * 1;  
var a33 = document.getElementById("z2").value * 1;  
var deltaX1 = []
var deltaX2 = []
var deltaX3 = []
var deltaX1Max = []
var deltaX2Max = []
var deltaX3Max = []
//while(i < 0.99 /*resultX0 < 0.99*/ /* Critério System */  /* || resultX0 < criterioUsuario */) {
for(i=0; i< 6; i++) {
//while(i == 0 || deltaX1Max[i]*1 != 1 && deltaX1Max[i]*1 >= 1 && deltaX1Max[i]*1 < 2) {
if( i == 0) {  
deltaX1.push( 0 );
deltaX2.push( 0 );
deltaX3.push( 0 );
deltaX1Max.push(0);
deltaX2Max.push(0);
deltaX3Max.push(0);
} else {
//deltaX1.push( parseFloat((n0 + 2 * deltaX2[i-1] - deltaX3[i-1]) /  x0).toPrecision(arred) * 1 );
deltaX1.push( parseFloat((b1 - a12 * deltaX2[i-1] - a13 * deltaX3[i-1])/a11 ).toPrecision(arred) * 1 );
deltaX2.push( parseFloat((b2 - a21 * deltaX1[i] - a23 * deltaX3[i-1])/a22 ).toPrecision(arred) * 1 );
deltaX3.push( parseFloat((b3 - a31 * deltaX1[i] - a32 * deltaX2[i-1])/a33 ).toPrecision(arred) * 1 );

deltaX1Max.push((deltaX1[i] - deltaX1Max[i-1])*1);
deltaX2Max.push((deltaX2[i] - deltaX2Max[i-1])*1);
deltaX3Max.push((deltaX3[i] - deltaX3Max[i-1])*1);
}
texto = texto + deltaX1[i] + ' - ' + deltaX2[i] + ' - ' + deltaX3[i] + '<br>';
/* i++;
} */
}
document.getElementById("divCalculo").innerHTML = texto;
}
</script>


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
