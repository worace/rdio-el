### Rdio.el -- Control Rdio Desktop App from Emacs

This package provides emacs functions for wrapping
common interactions with the Rdio music desktop app,
allowing you to control the app directly from your editor.

Currently only OSX is supported since this package uses AppleScript as a shell adapter between emacs and the Rdio app. If you're interested in adding linux or windows support, I'd love to hear from you.


### Provided functions:

* `rdio-launch` -- open the rdio application if not already open
* `rdio-quit` -- quit the rdio application
* `rdio-play` -- start playing (plays whatever is set as the current track)
* `rdio-pause` -- pauses the player
* `rdio-toggle` -- toggle play/pause mode
* `rdio-vol-up` -- increase volume by 10% of total
* `rdio-vol-down` -- decrease volume by 10% of total
