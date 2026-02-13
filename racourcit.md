# Nvim move 

## 1. Navigation & Files (Finding things fast)

|Plugin|Shortcut|Action|
|----|----|----|
|Telescope|<Space>ff|Find Files (by name)|
|Telescope|<Space>fg|Find Grep (search text inside files)|
|Telescope|<Space>fb|Find Buffers (open files)|
|Neo-tree|<Space>e|Toggle the file explorer sidebar|
|Harpoon|<Space>a|Add current file to "Quick Menu"|
|Harpoon|Ctrl + e|Open the "Quick Menu" to see pinned file|
|Harpoon|Ctrl + h / t / n / s |Jump to file 1, 2, 3, or 4 immediately|

## 2. Code Intelligence (LSP)

These work when your language server (Python, Rust, Lua) is active.

|Key|Action|
|--|--|
|K|Hover documentation (shows docstring/types)|
|gd|Go to Definition (jump to where function is defined)|
|gr|Go to References (see everywhere this is used)|
|<Space>rn|Rename symbol (changes it everywhere in project)|
|<Space>ca|Code Action (quick fix, import, etc.)|
|[d|Go to previous error/warning|
|]d|Go to next error/warning|


## 3. Python & Data Science (Slime & Venv)

|Plugin|Shortcut|Action|
|--|--|--|
|VenvSelector|<Space>vs|Select your Python Environment (Conda/Venv)|
|Vim-Slime|Ctrl+c Ctrl+c|Send the current paragraph or selection to the terminal|

    Workflow Tip: Open a terminal split (:vsp | term), start ipython, then go back to your code and hit Ctrl+c Ctrl+c to run snippets.

## 4. Editing Magic (Surround & Comments)

You have nvim-surround installed. It uses specific "motion" keys that aren't in your init.lua but are defaults.

    ys = You Surround (Add)

    ds = Delete Surround

    cs = Change Surround

|Command|Example Context|Result|
|--|--|--|
|ysiw"|hello (cursor on word)|"hello" (Surround Inner Word with ")|
|ysiw)|"hello"|("hello")|
|ds"|"hello"|hello (Delete surrounding quotes)|
|cs"'|"hello"|'hello' (Change surrounding " to ')|
|Todo|<Space>ft|Find Todo comments in your project|


## 5. Window Management (Native Vim)|

|Shortcut|Action|
|--|--|
|:vsp|Split Vertical (Side by side)|
|:sp|Split Horizontal (Top/Bottom)|
|Ctrl+w then w|Cycle focus between windows|
|Ctrl+w then h/j/k/l|Move focus Left/Down/Up/Right|
|Ctrl+w then q|Close the current window|
|:only|Close all other windows except the current one|


## 6. Autocompletion (Blink.cmp)

|Key|Action|
|--|--|
|Tab|Select next suggestion|
|Shift+Tab|Select previous suggestion|
|Enter|Confirm/Insert the suggestion|
|Ctrl+Space|Manually trigger the menu|


## 7. Git (Gitsigns)

You have gitsigns installed with default settings.

    Look at the left gutter (line numbers): You will see lines if you added (+), changed (~), or deleted (-) code.

    Preview Hunk: You can click on the line or use :Gitsigns preview_hunk to see what changed.

## Move classique 

### Short Range (On the Current Line)

Instead of holding l or h to scroll right/left, use these:

- w: Jump forward to the start of the next word.
- b: Jump backward to the  start of the previous word.
- e: Jump to the end of the current word.
- 0: Jump to the absolute start of the line.
- $: Jump to the absolute end of the line

### The Find Key

- f + character: "Find" the next occurrence of that character.
    - Example: To jump to the next colon :, press f:.
    - Tip: Press ; to go to the next one, or , to go back.

### Medium Range (Scrolling the Screen)

- Don't tap j or k twenty times.
    - Ctrl + d: Scroll Down (half a page).
    - Ctrl + u: Scroll Up (half a page).
    - }: Jump down one "paragraph" (blank line).
        - Why it's great for code: In Python/Lua, this usually skips entire functions or blocks of code.
    - {: Jump up one "paragraph".

### Long Range (The Whole File)

- gg: Go to the very top of the file.
- G (Shift+g): Go to the very bottom of the file.
- :<number>: Jump to a specific line number.
    - Example: :42 takes you to line 42.

### Teleportation (Search)

The fastest way to move is to search for where you want to go.

- / + text: Search forward.
    - Example: /def takes you to the next function definition.
    - Next: Press n for next match, N for previous match.
- $*$ (Shift+8): Search for the word currently under your cursor.
    - Scenario: You are on a variable named my_var. Press * to instantly jump to the next place my_var is used.

### The "Time Travel" Keys (Crucial!)

Vim remembers everywhere you've been.

- Ctrl + o: Go back to the Old position (Jump backward in history).
    - Scenario: You jumped to a definition (gd) to read a function. Press Ctrl+o to snap back to where you were working.
- Ctrl + i: Go forward (Jump forward in history).
