#!/usr/bin/perl

sub transpose {
  $input = $_[0];
  @output = ();
  $len = length($input[0]);



  for $i ( 0 .. $len-1 ) {
    $traversal = "";
    for $current ( @input ) {
      $traversal .= substr($current, $i, 1);
    }
    push @output, $traversal;
    $traversal = "";
  }


  # for $x ( @output ) {
  #   print $x . "\n";
  # }

  return @output;
}

sub ap_sum {
  $n = $_[0];
  $start = $_[1];

  return ($n / 2) * (2 * $start - ($n - 1));
}

sub solve_string {
  $input = $_[0];
  $start = length($input);
  $total = 0;
  $n = 0;

  for $i ( 0 .. (length($input) - 1) ) {
    # print substr($input, $i, 1) . " <- " . (length($input) - $i) . "\n";
    if (substr($input, $i, 1) eq "#") {
        $total += ap_sum($n, $start);
        $n = 0;
        $start = length($input) - ($i + 1);
    } elsif (substr($input, $i, 1) eq "O") {
        $n += 1;
    }

  }
  
  $total += ap_sum($n, $start);
  $n = 0;
  $start = length($input) - ($i + 1);

  return $total;
}


@input = ();

while (my $in = <>) {
  chomp($in);
  push @input, $in;
}

@myout = transpose($input);

$output = 0;

for $current ( @myout ) {
  $output += solve_string($current) . "\n";
}

print $output;






