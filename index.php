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
include 'conectar.php';
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
$qsinputs = "SELECT * FROM md.inputs ORDER BY id ASC;";
$query = $pdo->prepare($qsinputs);
$query->execute();
  for($i=0; $escrever = $query->fetch(); $i++){
  
$id = $escrever['id'];
?>
x<?php echo $id; ?><input type='text' id="x<?php echo $id; ?>" name="x<?php echo $id; ?>" value="<?php echo $escrever['x']; ?>">
y<?php echo $id; ?><input type='text' id="y<?php echo $id; ?>" name="y<?php echo $id; ?>" value="<?php echo $escrever['y']; ?>">
z<?php echo $id; ?><input type='text' id="z<?php echo $id; ?>" name="z<?php echo $id; ?>" value="<?php echo $escrever['z']; ?>"> 
n<?php echo $id; ?><input type='text' id="n<?php echo $id; ?>" name="n<?php echo $id; ?>" value="<?php echo $escrever['n']; ?>"> 
<button type="button" class="btn btn-danger" onclick="subInput(<?php echo $id; ?>);">-</button><br>
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
  $n = $post["n$i"];
if(!empty($x)) {  
$insert = "INSERT INTO md.inputs (id, x, y, z, n) VALUES ('$i', '$x', '$y', '$z', '$n');";  # isnull $x0 = 0;
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
for(i=0; i < val; i++) {
var valorX = document.getElementById('x'+i).value;
var valorY = document.getElementById('y'+i).value;
var valorZ = document.getElementById('z'+i).value;
var valorN = document.getElementById('n'+i).value;
  inputText  =  inputText + 
  " x" +i+"<input type='text' id='x"+i+"' name='x"+i+"' value='"+valorX+"'>"+ 
  " y"+i+"<input type='text' id='y"+i+"' name='y"+i+"' value='"+valorY+"'>" + 
  " z"+i+"<input type='text' id='z"+i+"' name='z"+i+"' value='"+valorZ+"'>" + 
  " n"+i+"<input type='text' id='n"+i+"' name='n"+i+"' value='"+valorN+"'>" + 
  " <button type='button' class='btn btn-danger' onclick='subInput("+i+");'>-</button>" +"<br>";
}
inputText  =  inputText + 
  " x" +i+ "<input type='text' id='x"+i+"' name='x"+i+"' value='"+"0.0"+"'>"+ 
  " y"+i+"<input type='text' id='y"+i+"' name='y"+i+"' value='"+"0.0"+"'>" + 
  " z"+i+"<input type='text' id='z"+i+"' name='z"+i+"' value='"+"0.0"+"'>" +  
  " n"+i+"<input type='text' id='n"+i+"' name='n"+i+"' value='"+"0.0"+"'>" +  
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
var valorN = document.getElementById('n'+i).value;
  if(i != posicao) {
    inputText  =  inputText + 
    " x" +id+ "<input type='text' id='x"+id+"' name='x"+id+"' value='"+valorX+"'>"+ 
    " y"+id+"<input type='text' id='y"+id+"' name='y"+id+"' value='"+valorY+"'>" + 
    " z"+id+"<input type='text' id='z"+id+"' name='z"+id+"' value='"+valorZ+"'>" + 
    " n"+id+"<input type='text' id='n"+id+"' name='n"+id+"' value='"+valorN+"'>" + 
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
