<?php

$map = array(0 => ".");

function setInfected($map, $row, $col, $inf) {
    $x = $row * 10000 + $col;
    $map[$x] = $inf;
    return $map;
}

function isInfected($map, $row, $col) {
    $x = $row * 10000 + $col;
    return $map[$x] == "#";
}

$dirs = array(
        array("x" => 0, "y" => -1),
        array("x" => 1, "y" => 0),
        array("x" => 0, "y" => 1),
        array("x" => -1, "y" => 0));

$input = file_get_contents("input22.txt");
$rows = explode("\n", $input);
$col = (strlen(trim($rows[0])) - 1)/2;
$row = (sizeof($rows) - 1)/2;

for ($x = 0; $x < sizeof($rows); $x++) {
    $r = trim($rows[$x]);
	for ($y = 0; $y < strlen($r); $y++) {
	    $s = $r[$y];
	    $map = setInfected($map, $x, $y, $s);
	}
}

$d = 40000;
$dir = $dirs[$d % 4];
$count = 0;
$num_bursts = 10000;
for ($x = 0; $x < $num_bursts; $x++) {
    if (isInfected($map, $row, $col)) {
        $d = $d + 1;
        $map = setInfected($map, $row, $col, ".");
    } else {
        $d = $d - 1;
        $map = setInfected($map, $row, $col, "#");
        $count = $count + 1;
    }
    $dir = $dirs[$d % 4];
    $col = $col + $dir["x"];
    $row = $row + $dir["y"];
}

echo $count;
?>