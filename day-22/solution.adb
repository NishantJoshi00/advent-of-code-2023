with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Strings;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Containers.Vectors;
with Ada.Containers.Ordered_Sets;

procedure Solution is
  package IntegerVector is new Ada.Containers.Vectors
   (Index_Type => Natural, Element_Type => Integer);

  package IntegerSet is new Ada.Containers.Ordered_Sets
   (Element_Type => Integer);

  type Points is record
    start : IntegerVector.Vector;
    stop  : IntegerVector.Vector;
  end record;

  package PointsVector is new Ada.Containers.Vectors
   (Index_Type => Natural, Element_Type => Points);

  type Brick is record
    location     : Points;
    supported_by : IntegerVector.Vector;
    above        : IntegerVector.Vector;
  end record;

  package BricksVector is new Ada.Containers.Vectors
   (Index_Type => Natural, Element_Type => Brick);

  function getMax (Cur : Brick) return Integer is
  begin
    if (Cur.location.stop (2) > Cur.location.start (2)) then
      return Cur.location.stop (2);
    else
      return Cur.location.start (2);
    end if;
  end getMax;


  function getMin (Cur : Brick) return Integer is
  begin
    if (Cur.location.stop (2) < Cur.location.start (2)) then
      return Cur.location.stop (2);
    else
      return Cur.location.start (2);
    end if;
  end getMin;

  package IntegerSorting is new IntegerVector.Generic_Sorting ("<");

  function max (a, b : Integer) return Integer is
  begin
    if (a > b) then
      return a;
    else
      return b;
    end if;
  end max;

  function min (a, b : Integer) return Integer is
  begin
    if (a > b) then
      return b;
    else
      return a;
    end if;
  end min;

  function checkOverlap (Bottom, Top : Brick) return Boolean is

  begin
    return
     max (Bottom.location.start (0), Top.location.start (0)) <=
     min (Bottom.location.stop (0), Top.location.stop (0)) and
     max (Bottom.location.start (1), Top.location.start (1)) <=
      min (Bottom.location.stop (1), Top.location.stop (1));

  end checkOverlap;

  function "<" (Left, Right : Brick) return Boolean is
    ll : Integer;
    rr : Integer;
  begin
    if (Left.location.start (2) < Left.location.stop (2)) then
      ll := Left.location.start (2);
    else
      ll := Left.location.stop (2);
    end if;

    if (Right.location.start (2) < Right.location.stop (2)) then
      rr := Right.location.start (2);
    else
      rr := Right.location.stop (2);
    end if;

    return ll < rr;

  end "<";

  package BrickSorting is new BricksVector.Generic_Sorting ("<");

  function newPoint (Line : String) return IntegerVector.Vector is
    flying : Unbounded_String     := To_Unbounded_String ("");
    output : IntegerVector.Vector := IntegerVector.Empty_Vector;
  begin
    for Cur in Line'Range loop
      if (Line (Cur) = ',') then
        output.Append (Integer'Value (To_String (flying)));
        flying := To_Unbounded_String ("");
      else
        flying := To_Unbounded_String (To_String (flying) & (Line (Cur)));
      end if;
    end loop;
    output.Append (Integer'Value (To_String (flying)));

    return output;
  end newPoint;

  procedure changeElev (Cur : in out Brick; Elev : Integer) is
    del : Integer;
  begin
    if (Cur.location.start (2) < Cur.location.stop (2)) then
      del                    := Cur.location.stop (2) - Cur.location.start (2);
      Cur.location.start (2) := Elev;
      Cur.location.stop (2)  := Elev + del;
    else
      del                    := Cur.location.start (2) - Cur.location.stop (2);
      Cur.location.start (2) := Elev + del;
      Cur.location.stop (2)  := Elev;
    end if;

  end changeElev;

  function newBrick (Line : String) return Brick is
    flying : Unbounded_String;
    output : Brick;
  begin
    for Cur in Line'Range loop
      if (Line (Cur) = '~') then
        output.location.start := newPoint (To_String (flying));
        flying                := To_Unbounded_String ("");
      else
        flying := To_Unbounded_String (To_String (flying) & (Line (Cur)));
      end if;
    end loop;
    output.location.stop := newPoint (To_String (flying));
    output.supported_by  := IntegerVector.Empty_Vector;
    output.above         := IntegerVector.Empty_Vector;
    return output;
  end newBrick;

  bricks  : BricksVector.Vector := BricksVector.Empty_Vector;
  crucial : IntegerSet.Set      := IntegerSet.Empty_Set;
  current : Unbounded_String;
  idx     : Integer;
  length  : Integer;
  c_max   : Integer;
  output  : Integer;

begin
  while not End_Of_File loop
    current := To_Unbounded_String (Get_Line);
    bricks.Append (newBrick (To_String (current)));
  end loop;

  BrickSorting.Sort (bricks);

  length := Integer (BricksVector.Length (bricks));

  for Cur in 0 .. length - 1 loop
    idx := 1;
    for ICur in 0 .. Cur - 1 loop
      if (checkOverlap (bricks (Cur), bricks (ICur))) then
        idx := max (idx, 1 + getMax (bricks (ICur)));
      end if;
    end loop;
    changeElev (bricks (Cur), idx);
  end loop;

  BrickSorting.Sort (bricks);

  for Cur in 0 .. length - 1 loop
    for ICur in 0 .. Cur - 1 loop
      if
       (checkOverlap (bricks (Cur), bricks (ICur)) and
        getMin (bricks (Cur)) = (getMax (bricks (ICur)) + 1))
      then
        bricks (Cur).supported_by.Append (ICur);
        bricks (ICur).above.Append (Cur);
      end if;
    end loop;
  end loop;


  for Cur in 0 .. length - 1 loop
    if (Integer (bricks (Cur).supported_by.Length) = 1) then
      crucial.Include (bricks (Cur).supported_by (0));
    end if;
  end loop;

  output := Integer (bricks.Length) - Integer (crucial.Length);

  Put_Line (output'Image);

end Solution;
