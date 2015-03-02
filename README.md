# Subword Navigation
###### An Atom Package - [Atom.io](https://atom.io/packages/subword-navigation) : [Github](https://github.com/dsandstrom/atom-subword-navigation) : [![Build Status](https://travis-ci.org/dsandstrom/atom-subword-navigation.svg?branch=master)](https://travis-ci.org/dsandstrom/atom-subword-navigation)

**Harness the power of ALT as you battle the mighty camelCase and treacherous snake_case.**

This package allows you to move the cursor(s) to beginning and end of words, but also it stops at subwords (camelCase and snake_case).

- Holding `shift` will highlight as you move left and right.
- Along with highlight, you can delete to the previous/next subword.
- Issues and pull requests are welcome.


### Instructions

| Linux/Win   | Left             | Right             |
|:------------|:-----------------|:------------------|
| Move around | `alt-left`       | `alt-right `      |
| Highlight   | `alt-shift-left` | `alt-shift-right` |
| Delete      | `alt-backspace`  | `alt-delete `     |

| Mac         | Left                  | Right                  |
|:------------|:----------------------|:-----------------------|
| Move around | `ctrl-alt-left`       | `alt-right`            |
| Highlight   | `ctrl-alt-shift-left` | `ctrl-alt-shift-right` |
| Delete      | `ctrl-alt-backspace`  | `ctrl-alt-delete `     |


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
