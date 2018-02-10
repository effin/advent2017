<?php

$map = array(0 => ".");

function setInfected($row, $col, $inf) {
    $x = $row * 10000000 + $col;
    $GLOBALS["map"][$x] = $inf;
}

function getInfected($row, $col) {
    $x = $row * 10000000 + $col;
    return $GLOBALS["map"][$x];
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
	    setInfected($x, $y, $s);
	}
}

$d = 40000000;
$dir = $dirs[$d % 4];
$count = 0;
$num_bursts = 10000000;
for ($x = 0; $x < $num_bursts; $x++) {
    if (getInfected($row, $col) == "#") {
        $d = $d + 1;
        setInfected($row, $col, "F");
    } else if (getInfected($row, $col) == "F") {
        $d = $d + 2;
        setInfected($row, $col, ".");
    } else if (getInfected($row, $col) == "W") {
        setInfected($row, $col, "#");
        $count = $count + 1;
    } else {
        $d = $d - 1;
        setInfected($row, $col, "W");
    }
    $dir = $dirs[$d % 4];
    $col = $col + $dir["x"];
    $row = $row + $dir["y"];
}

echo $count;
?>