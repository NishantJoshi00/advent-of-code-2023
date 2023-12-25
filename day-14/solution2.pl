#!/usr/bin/perl

sub transpose {
  my @input = @_;
  my @output = ();
  my $len = length($input[0]);

  for $i ( 0 .. $len-1 ) {
    my $traversal = "";
    for $current ( @input ) {
      $traversal .= substr($current, $i, 1);
    }
    push @output, $traversal;
  }
  return @output;
}

sub reverse_2d {
  my @input = @_;
  my @output = ();

  for $current ( @input ) {
    push @output, scalar reverse $current;
  }

  return @output;
}

sub concat {
  my $output = "";
  for $current ( @_ ) {
    $output .= $current;
  }
  return $output;
}



sub print_2d {
  for $current ( @_ ) {
    print $current . "\n";
  }
  print "\n";
}

sub move_west {
  my @input = @_;
  my @output = ();

  for $current ( @input ) {
    my $final = "";
    my $local = "";
    for $i ( 0 .. length($current) - 1 ) {
      if (substr($current, $i, 1) eq "#") {
        $final .= $local . "#";
        $local = ""
      } elsif (substr($current, $i, 1) eq ".") {
        $local .= ".";
      } elsif (substr($current, $i, 1) eq "O") {
        $local = "O" . $local;
      }
    }
    $final .= $local;
    push @output, $final;
  }

  return @output;
}

sub move_north {
  my @input = @_;
  return transpose(move_west(transpose(@input)));
}

sub move_east {
  my @input = @_;
  return reverse_2d(move_west(reverse_2d(@input)));
}

sub move_south {
  my @input = @_;
  return transpose(move_east(transpose(@input)));
}

sub solve_string {
  my $input = $_[0];
  my $start = length($input);
  my $total = 0;
  my $n = 0;

  for $i ( 0 .. (length($input) - 1) ) {
    if (substr($input, $i, 1) eq "O") {
        $total += $start - $i;
    }

  }
  return $total;
}

sub solve {
  my @input = @_;
  my @myout = transpose(@input);

  my $output = 0;
  
  for $current ( @myout ) {
    $output += solve_string($current) . "\n";
  }
  return $output;
}

sub final_solve {
  my @input = @_;
  my %mem;
  my $counter = 0;
  while (1) {
    if ($counter eq 1000000000) {
      last;
    }
    $mem{concat(@input)} = $counter;

    @input = move_east(move_south(move_west(move_north(@input))));
    $counter += 1;

    if ($mem{concat(@input)}) {
      my $mplier;
      {
        use integer;
        $mplier = (1000000000 - ($mem{concat(@input)} - 1)) / ($counter - $mem{concat(@input)});
      }
      $counter = ($mem{concat(@input)} - 1) + ($counter - $mem{concat(@input)}) * $mplier + 1; 
      %mem = {};
    }
  }

  return solve(@input);
}


my @input = ();
my %mem;

while (my $in = <>) {
  chomp($in);
  push @input, $in;
}

print final_solve(@input);
