
Object subclass: Solve [
  | totalArea boundedArea boundaryArea | 


  Solve >> getEnclosed: boundary [ 
    | output |
    " boundary do: [:point | point displayNl]. "
    output := 0.

    1 to: (boundary size) do: [ :index |
      | x y1 y2 |
      x := (boundary at: index) first.
      (index = 1) ifTrue: [ y1 := (boundary last) last. ].
      (index = 1) ifFalse: [ y1 := (boundary at: (index - 1)) last. ].

      (index = boundary size) ifTrue: [ y2 := (boundary first) last. ].
      (index = boundary size) ifFalse: [ y2 := (boundary at: (index + 1)) last. ].

      output := output + (x * (y2 - y1)).
    ].

    (output < 0) ifTrue: [ output := -1 * output ].

    totalArea := output/2.

    ^totalArea
  ]

  Solve >> solve: boundaryPoints [
    boundaryArea := boundaryPoints.
    boundedArea := (totalArea + 1) - (boundaryArea / 2).
    ^boundaryArea + boundedArea
  ]
]



| inputStream boundary boundaryPoints |

inputStream :=  FileStream stdin.

boundary := OrderedCollection new.

boundary add: {0. 0}.

boundaryPoints := 0.

[inputStream atEnd] whileFalse: [
  | current words old_x old_y direction stepSize |

  current := inputStream nextLine.
  words := current subStrings:  ' '.

  old_x := boundary last at: 1.
  old_y := boundary last at: 2.
  direction := words first.
  stepSize := words second asInteger.
  boundaryPoints := boundaryPoints + stepSize.
  ('R' = direction) ifTrue:  [ boundary add: {old_x + stepSize. old_y.} ].
  ('L' = direction) ifTrue:  [ boundary add: {old_x - stepSize. old_y.} ].
  ('U' = direction) ifTrue:  [ boundary add: {old_x. old_y - stepSize.} ].
  ('D' = direction) ifTrue:  [ boundary add: {old_x. old_y + stepSize.} ].

].

solution := Solve new.

solution getEnclosed: boundary.

(solution solve: boundaryPoints) printNl.
