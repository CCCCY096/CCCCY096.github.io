# Notes about Vim

## My fav commands

|     Command | Description                                                  | Note        |
| ----------: | ------------------------------------------------------------ | ----------- |
|           ^ | to first non-blank character in the line                     |             |
|         🔢 - | up N lines, on the first non-blank character                 |             |
|         🔢 + | down N lines, on the first non-blank character (also: CTRL-M and CR) |             |
|   m{a-zA-Z} | mark current position with mark {a-zA-Z}                     |             |
|      `{a-z} | go to mark {a-z} within current file                         |             |
|      `{A-Z} | go to mark {A-Z} in any file                                 |             |
|      :marks | print the active marks                                       |             |
|          zt | redraw, current line at top of window                        |             |
|          zz | redraw, current line at center of window                     |             |
|          zb | redraw, current line at bottom of window                     |             |
|      CTRL-T | insert one shiftwidth of indent in front of the current line | insert mode |
|      CTRL-D | delete one shiftwidth of indent in front of the current line | insert mode |
|           J | join N-1 lines (delete EOLs)                                 |             |
|     "{char} | use register {char} for the next delete, yank, or put        |             |
|          "* | use register `*` to access system clipboard                  |             |
|        :reg | show the contents of all registers                           |             |
|        🔢 ]p | like p, but adjust indent to current line                    |             |
|         🔢 R | enter Replace mode (repeat the entered text N times)         |             |
|   {visual}u | make highlighted text lowercase                              |             |
| 🔢 <{motion} | move the lines that are moved over with {motion} one shiftwidth left |             |
|        🔢 << | move N lines one shiftwidth left                             |             |
| 🔢 >{motion} | move the lines that are moved over with {motion} one shiftwidth right |             |
|        🔢 >> | move N lines one shiftwidth right                            |             |
|           V | start highlighting linewise or stop highlighting             |             |
|         🔢 . | repeat last change                                           |             |
|      q{a-z} | record typed characters into register {a-z}                  |             |
|           q | stop recording                                               |             |
|    🔢 @{a-z} | execute the contents of register {a-z} (N times)             |             |
|        🔢 @@ | repeat previous @{a-z} (N times)                             |             |

