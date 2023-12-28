<?php

class Data
{
  public $map;

  function __construct($data)
  {
    $inner = explode(",", substr($data, 1, -1));
    $this->map = [];
    foreach ($inner as $el) {
      $iel = explode("=", $el);
      $this->map[$iel[0]] = intval($iel[1]);
    }
  }

  function evaluate($rules)
  {
    return $rules->map["in"]->evaluate($this, $rules);
  }

  function resolve()
  {
    return array_sum($this->map);
  }
}

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

  function evaluate($data)
  {
    $value = $data->map[$this->var];
    switch ($this->op) {
      case ('>'):
        return $value > $this->val;
      case ('<'):
        return $value < $this->val;
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
  function evaluate($data, $rules)
  {
    foreach ($this->conditions as $condition) {
      if ($condition[0]->evaluate($data)) {
        if ($condition[1] == "A") {
          return true;
        } elseif ($condition[1] == "R") {
          return false;
        }
        return $rules->map[$condition[1]]->evaluate($data, $rules);
      }
    }


    if ($this->last == "A") {
      return true;
    } elseif ($this->last == "R") {
      return false;
    }
    return $rules->map[$this->last]->evaluate($data, $rules);
  }
}

$current = rtrim(fgets(STDIN));


$rules = new Rules();

$datas = [];

while ($current != "") {
  $rules->add($current);
  $current = rtrim(fgets(STDIN));
}

$current = rtrim(fgets(STDIN));

while ($current != "") {
  array_push($datas, new Data($current));
  $current = rtrim(fgets(STDIN));
}

$datas = array_filter($datas, function ($data) use ($rules) {
  return $data->evaluate($rules);
});

print array_sum(array_map(function ($data) {
  return $data->resolve();
}, $datas));
