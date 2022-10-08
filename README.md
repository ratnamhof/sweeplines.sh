
# Description

Teminal screensaver implemented in bash.

This is a clone of [this](https://github.com/lbgists/sweeplines.sh) original version with some minor changes:

* Hide the cursor at startup and restore upon exit.
* Exit when terminal is resized.
* Add color support: Cycle through set of colors. Switch to next color when the sweep colides with a previously encoutered state. When all colors have passed reset at random edge location.
* Add some basic key bindings. Exit when using an unknown key.

# Key bindings

| Key | Action         |
|:---:|:--------------:|
| p   | Restart        |
| f   | Increase speed |
| d   | Decrease speed |
| =   | Reset speed    |

