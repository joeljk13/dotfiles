Dotfiles
========

My dotfiles. Feel free to fork/improve them. There's a lot here, but here's
some of my favorite features:

.vimrc
------

 - `jk` is escape. It also does more though - it automatically saves the file,
     if the file hasn't already been saved. It also makes sure that vim knows
     that the file really hasn't been modified, since vim assumes the file gets
     modified every time you go in insert mode. It also clears any trailing
     whitespace from the current line if you're in insert mode.
 - `<space>` as `<leader>`. You can't make mneumonics with it, but it's really
     easy to type, so I like it.
 - Lots of plugin customization, with plugins like vim-airline, syntastic (with
     my gcc warnings for C)
 - Automatic tab setting that detects the indent of the current file. It also
     warns if spaces and tabs are mixed. It's not as fancy as the plugins ffor
     this, but it's a very simple agorithm that just almost all of the time.

.tmux.conf
----------

 - Use PREFIX + w + # to go to window #
 - Use PREFIX + # to go to pane #

Also, you can use CTRL+[hjkl] to move seamlessly between tmux and vim, thanks
to a plugin.

.gitconfig
----------

 - `diff3`. It shows the common ancestor as well as the main commits in a
     merge.
 - The pager is `less -XFR`, which makes it so that if the output it less than
     a screen long, it effectively just prints it to stdout, and it doesn't
     clear the the screen after the command. This means you can actually look
     at the log while typing the next command.
 - `credenntial.helper = cache`, which saves your password in memory for some
     time so you neither need to keep entering it in nor deal with ssh keys.
 - A crazy number of aliases
 - `git abbrev-head` to be able to use `h` instead of `HEAD`
 - Use `git commit -v` instead of `git commit` whever possible to show what
     changes are being commited while typing the commit message
 - `git wipe` is `git reset --hard` improved - it commits and then resets, so
     that you can get back through `git reflog`.
 - `git upa` updates all branches
 - `git hub <user> <repo>` to clone from github.
 - And most importantly, amazing logging:
     - All logs are grep friendly
     - `git lg` for a quick log, just showing the commit message, any
         referencing branches/tags, and just enough of the hash to check that
         commit out
     - Add `d`/`n` to get dates/names for the commits (ex. `git lgn` or `git
         lgd` or `git lgdn`).
     - Add `a`/`c` at the end to get the commits for all branches, and to force
         color output, respectively.
     - `git lge` to view edits in detail
     - `git last` and `git laste` to see the last commit and last edit
