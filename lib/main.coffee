SubwordNavigation = require './subword-navigation'

module.exports =
  subwordNavigation: null

  activate: (state) ->
    atom.workspaceView.command "subword-navigation:move-right", =>
      @moveRight()
    atom.workspaceView.command "subword-navigation:move-left", =>
      @moveLeft()
    atom.workspaceView.command "subword-navigation:select-right", =>
      @selectRight()
    atom.workspaceView.command "subword-navigation:select-left", =>
      @selectLeft()

  deactivate: ->
    @subwordNavigation?.destroy()
    @subwordNavigation = null

  moveRight: ->
    @subwordNavigation = new SubwordNavigation
    @subwordNavigation.moveToNextSubwordBoundary()

  moveLeft: ->
    @subwordNavigation = new SubwordNavigation
    @subwordNavigation.moveToPreviousSubwordBoundary()

  selectRight: ->
    @subwordNavigation = new SubwordNavigation
    @subwordNavigation.selectToNextSubwordBoundary()

  selectLeft: ->
    @subwordNavigation = new SubwordNavigation
    @subwordNavigation.selectToPreviousSubwordBoundary()
