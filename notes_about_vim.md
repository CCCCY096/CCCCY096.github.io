# Notes about Vim

## How to learn Vim ~~according to me~~

**Step 1**: Run `vimtutor` and step through the tutorial. Take less than half an hour during the first try. Repeat a few times if you will.

**Step 2**: Practice the basic motions and commands taught in the tutorial. **VS Code + Vim key-binding plugin** is a good playground because you can always work around by using the normie editing when you forget Vim syntax.

**Step 3**: Learn more advanced usages, like registers, options ( `hlsearch, ic, ...` ), more complex motions and commands and so on.

**Step 4**: Maybe it's time to use `vim` or `Neovim` with plugins as a productivity tool. I'm still stuck in this stage so I don't know what to tell you. I heard it's damn messy to use those plugins. VS Code might be good enough!

**Step 5**: Profits.

**A little tip**: Use Vim-like plugins like `vimium` in your browser! Use `h, j, k, l` to navigate, use `o, O` to open a new tab... You name it! They really boost up your efficiency in browsing. And you get to practice some Vim motion and commands!

## My fav commands

|      Command | Description                                                  | Note        |
| -----------: | ------------------------------------------------------------ | ----------- |
|            ^ | to first non-blank character in the line                     |             |
|          🔢 - | up N lines, on the first non-blank character                 |             |
|          🔢 + | down N lines, on the first non-blank character (also: CTRL-M and CR) |             |
|    m{a-zA-Z} | mark current position with mark {a-zA-Z}                     |             |
|       `{a-z} | go to mark {a-z} within current file                         |             |
|       `{A-Z} | go to mark {A-Z} in any file                                 |             |
|       :marks | print the active marks                                       |             |
|           zt | redraw, current line at top of window                        |             |
|           zz | redraw, current line at center of window                     |             |
|           zb | redraw, current line at bottom of window                     |             |
|       CTRL-T | insert one shiftwidth of indent in front of the current line | insert mode |
|       CTRL-D | delete one shiftwidth of indent in front of the current line | insert mode |
|            J | join N-1 lines (delete EOLs)                                 |             |
|      "{char} | use register {char} for the next delete, yank, or put        |             |
|           "* | use register `*` to access system clipboard                  |             |
|         :reg | show the contents of all registers                           |             |
| 🔢 ]p or 🔢 [p | like p, but adjust indent to current line                    |             |
|          🔢 R | enter Replace mode (repeat the entered text N times)         |             |
|    {visual}u | make highlighted text lowercase                              |             |
|    {visual}U | make highlighted text uppercase                              |             |
|  🔢 <{motion} | move the lines that are moved over with {motion} one shiftwidth left |             |
|         🔢 << | move N lines one shiftwidth left                             |             |
|  🔢 >{motion} | move the lines that are moved over with {motion} one shiftwidth right |             |
|         🔢 >> | move N lines one shiftwidth right                            |             |
|            V | start highlighting linewise or stop highlighting             |             |
|          🔢 . | repeat last change                                           |             |
|       q{a-z} | record typed characters into register {a-z}                  |             |
|            q | stop recording                                               |             |
|     🔢 @{a-z} | execute the contents of register {a-z} (N times)             |             |
|         🔢 @@ | repeat previous @{a-z} (N times)                             |             |

