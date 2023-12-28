<?php

class Rules
{
  public $map;

  function __construct()
  {
    $this->map = [];
  }

  function add($data)
  {
    $inner = explode("{", $data);
    $this->map[$inner[0]] = new Rule(substr($inner[1], 0, -1));
  }
}


class Condition
{
  private $var;
  private $op;
  private $val;
  function __construct($con)
  {
    $this->var = $con[0];
    $this->op = $con[1];
    $this->val = intval(substr($con, 2));
  }
  function evaluate_range($data)
  {
    switch ($this->op) {
      case ('>'):
        $true = array_merge(array(), $data);
        $false = array_merge(array(), $data);
        $true[$this->var][0] = $this->val + 1;
        $false[$this->var][1] = $this->val;
        return [$true, $false];
      case ('<'):
        $true = array_merge(array(), $data);
        $false = array_merge(array(), $data);
        $true[$this->var][1] = $this->val - 1;
        $false[$this->var][0] = $this->val;
        return [$true, $false];
    }
  }
}

class Rule
{
  private $conditions;
  private $last;

  function __construct($data)
  {
    $conditions = explode(",", $data);
    $this->last = array_pop($conditions);
    $this->conditions = array_map(function ($inner) {
      $temp = explode(":", $inner);
      return [new Condition($temp[0]), $temp[1]];
    }, $conditions);
  }

  function evaluate_range($data, $rules)
  {
    $output = 0;
    if (!consider_range($data)) {
      return 0;
    }
    foreach ($this->conditions as $condition) {
      $multi_ranges = $condition[0]->evaluate_range($data);
      $true = $multi_ranges[0];
      $false = $multi_ranges[1];
      $next = $condition[1];
      if ($next == "A") {
        $output += evaluate_range($true);
      } elseif ($next == "R") {
        $output += 0;
      } else {
        $output += $rules->map[$next]->evaluate_range($true, $rules);
      }
      $data = $false;
      if (!consider_range($data)) {
        return $output;
      }
    }


    if ($this->last == "A") {
      return $output + evaluate_range($data);
    } elseif ($this->last == "R") {
      return $output;
    }
    return $output + $rules->map[$this->last]->evaluate_range($data, $rules);
  }
}

function evaluate_range($data)
{
  return array_product(array_map(function ($inner) {
    if ($inner[1] < $inner[0]) return 0;
    else return $inner[1] - $inner[0] + 1;
  }, $data));
}

function consider_range($data)
{
  foreach ($data as $v) {
    if ($v[0] > $v[1]) {
      return false;
    }
  }
  return true;
}

$current = rtrim(fgets(STDIN));


$rules = new Rules();

while ($current != "") {
  $rules->add($current);
  $current = rtrim(fgets(STDIN));
}

$value = [
  "x" => [1, 4000],
  "m" => [1, 4000],
  "a" => [1, 4000],
  "s" => [1, 4000]
];

print $rules->map["in"]->evaluate_range($value, $rules);
