# Subword Navigation
###### An Atom Package - [Atom.io](https://atom.io/packages/subword-navigation) : [Github](https://github.com/dsandstrom/atom-subword-navigation) : [![Build Status](https://travis-ci.org/dsandstrom/atom-subword-navigation.svg?branch=master)](https://travis-ci.org/dsandstrom/atom-subword-navigation)

**Harness the power of ALT as you battle the mighty camelCase and treacherous snake_case.**

This package allows you to move the cursor(s) to beginning/end of words, but also it stops at subwords (camelCase and snake_case).  Holding `shift` will highlight as you move left and right.  Multiple cursors/selections are supported.  If I missed something, issues and pull requests are welcome.

### Instructions

|  Linux/Win  |            |            |
|-------------|----------------|-----------------|
| Move around | `alt-left`       | `alt-right `   |
| Highlight   | `alt-shift-left` | `alt-shift-right` |

|     Mac     |            |            |
|-------------|----------------|-----------------|
| Move around | `ctrl-alt-left`  | `alt-right`       |
| Highlight   | `ctrl-alt-shift-left` | `ctrl-alt-shift-right` |



### Commands
```coffee
'subword-navigation:move-right'
'subword-navigation:move-left'
'subword-navigation:select-right'
'subword-navigation:select-left'
```
