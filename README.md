# split-and-move package


**This package is a renamed version of [move-pane](http://github.com/msshnt/move-pane) package.**

split-and-move overrides the default behavior of pane splitting in Atom editor.


## Features

### Split

If your active pane has two or more tabs, its active item will be moved into a new pane. Otherwise, a split pane will be added.

This package overrides the default split commands, but they are still avaiable via application/context menu.

Commands:
- Mac: <kbd>cmd + k</kbd> <kbd>Up/Down/Left/Right</kbd>
- Windows, Linux: <kbd>ctrl + k</kbd> <kbd>Up/Down/Left/Right</kbd>

### Move
You can also move tab from pane to pane without your mouse.
Press <kbd>cmd + k m</kbd> / <kbd>ctrl + k m</kbd> to enter Moving mode, and hit 'Pane Number' key of the pane you want to move your tab into.
'Pane Number' is displayed in the bottom of each pane.


## Keybindings

### Mac
| Keystroke | Command | Selector |
| --------- | ------- | -------- |
| cmd-k right | split-and-move:split-right | .platform-darwin |
| cmd-k left | split-and-move:split-left | .platform-darwin |
| cmd-k up | split-and-move:split-up | .platform-darwin |
| cmd-k down | split-and-move:split-down | .platform-darwin |
| cmd-k m | split-and-move:start-move | .platform-darwin |

### Windows, Linux
| Keystroke | Command | Selector |
| --------- | ------- | -------- |
| ctrl-k right | split-and-move:split-right | .platform-win32, .platform-linux |
| ctrl-k left | split-and-move:split-left | .platform-win32, .platform-linux |
| ctrl-k up | split-and-move:split-up | .platform-win32, .platform-linux |
| ctrl-k down | split-and-move:split-down | .platform-win32, .platform-linux |
| ctrl-k m | split-and-move:start-move | .platform-win32, .platform-linux |
