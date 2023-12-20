Output output.mp4

Set Shell "fish --private"
Set FontSize 64
Set Width 1920
Set Height 1080

# Type "echo 'Welcome to VHS!'" Sleep 500ms  Enter
Type "make run < sample.in" Sleep 500ms Enter
Sleep 3s
Type "vim solution/solution.ml" Sleep 500ms Enter
Sleep 1s
Type@300ms ":33" Sleep 500ms Enter
Sleep 1s
Type@300ms "fL" Sleep 500ms
Sleep 1s
Type@300ms "vtL" Sleep 500ms
Sleep 1s
Type@300ms "x" Sleep 500ms
Sleep 1s
Type@300ms "f+" Sleep 500ms
Sleep 1s
Type@300ms "r-" Sleep 500ms
Sleep 1s
Type@300ms ":wq" Sleep 500ms Enter
Sleep 2s
Type "make run < sample.in" Sleep 500ms Enter
Sleep 5s
