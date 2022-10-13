# bell-conductor

Bell Conductor helps children play songs with bells. Kidsplay sells bells for children that use color to distinguish between different notes. [Click here](http://www.grothmusic.com/p-41-kidsplay-8-note-diatonic-handbell-set.aspx) to see a basic 8 note diatonic set.

Bell Conductor works by reading a text file that describes the notes to play and how long each note lasts. Colored circles animate across the screen from left to right and pop on a bar. The bell matching that color should be played when the note pops on the bar.


![Bell Conductor Example](https://github.com/trevordevore/bell-conductor/wiki/assets/images/bells-example.png)

# Song files

A song file is ASCII text and has one note per line. Empty lines are ignored and a line with `REPEAT` on it will repeat all notes within a section. A section stars at the beginning of the song or a previous `REPEAT` line.

Each line contains a comma-deimited list. Item 1 is the note which is created by combining a letter and number. The letter is the note (e.g. C) and the number is represents where the note is relative to middle C. `C1` is middle C. `G5` is G above middle C.

Item 2 on each line is a decimal representing how long the note lasts. `.25` is a 1/4 note. `.125` is an 1/8th note.

Below is the song file for **Away in a Manager**. Bell Conductor will display all of the notes twice due to the `REPEAT` line at the end.

```
G5,.25

G5,.375
F4,.125
E3,.25
G5,.375
F4,.125
E3,.25
D2,.25
C1,.25
D2,.25
E3,.5

E3,.25
F4,.375
E3,.125
D2,.25
E3,.25
C1,.25
E3,.25
G5,.25
F4,.25
E3,.25
D2,.5

G5,.25
G5,.375
F4,.125
E3,.25
G5,.375
F4,.125
E3,.25
D2,.25
C1,.25
D2,.25
E3,.5

E3,.25
F4,.375
G5,.125
A6,.25
G5,.375
F4,.125
E3,.25
D2,.25
E3,.375
D2,.125
C1,.5

G5,.25
G5,.5
BLow,.25
D2,.5
G5,.25
G5,.5
C1,.25
E3,.5
C8,.25
B7,.5
G5,.25
B7,.5
A6,.25
A6,.5
E3,.25
G5,.5

G5,.25
G5,.5
BLow,.25
D2,.5
G5,.25
G5,.5
C1,.25
E3,.5
C8,.25
B7,.5
G5,.25
B7,.5
G5,.25
C8,1.5

REPEAT
```


# Platform support

Bell Conductor has been tested on iOS and macOS. If you can test it on any other platforms let me know by creating an Issue with your results.
