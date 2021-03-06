# Subword Navigation
###### An Atom Package - [Atom.io](https://atom.io/packages/subword-navigation) : [Github](https://github.com/dsandstrom/atom-subword-navigation)

> This package is no longer maintained.  The functionality has been merged into Atom starting at v1.0.1. It will not activate and should be uninstalled.

**Harness the power of ALT as you battle the mighty camelCase and treacherous snake_case.**

This package allows you to move the cursor(s) to beginning and end of words, but also it stops at subwords (camelCase and snake_case).

- Holding `shift` will highlight as you move left and right.
- Along with highlight, you can delete to the previous/next subword.
- If you have [vim-mode](https://atom.io/packages/vim-mode) enabled, `q` will be there to assist.  As of now, commands can't be called multiple times (eg. v2q doesn't work).
- Issues and pull requests are welcome.


### Instructions

| Linux/Win   | Left             | Right             |
|:------------|:-----------------|:------------------|
| Move around | `alt-left`       | `alt-right `      |
| Highlight   | `alt-shift-left` | `alt-shift-right` |
| Delete      | `alt-backspace`  | `alt-delete `     |

| Mac*        | Left                  | Right                  |
|:------------|:----------------------|:-----------------------|
| Move around | `ctrl-alt-left`       | `ctrl-alt-right`       |
| Highlight   | `ctrl-alt-shift-left` | `ctrl-alt-shift-right` |
| Delete      | `ctrl-alt-backspace`  | `ctrl-alt-delete `     |

| Vim-Mode    | Left  | Right |
|:------------|:------|:------|
| Move around | `Q`   | `q`   |
| Highlight   | `v Q` | `v q` |
| Delete      | `d Q` | `d q` |


### Dependencies
Requires Atom v0.168.0 and up


### Commands
```coffee
'subword-navigation:move-right'
'subword-navigation:move-left'
'subword-navigation:select-right'
'subword-navigation:select-left'
'subword-navigation:delete-right'
'subword-navigation:delete-left'
```

### Notes
\* The reason Mac keymaps use `ctrl-alt` instead of just `alt` is because Atom already has a keymap set for `alt-left` and `alt-right` (move-to-beginning-of-word and move-to-end-of-word).
