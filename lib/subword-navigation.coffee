_ = require 'underscore-plus'

module.exports =

  activate: (state) ->
    @editor = atom.workspace.getActiveEditor()

    atom.workspaceView.command "subword-navigation:move-right", =>
      @moveToNextSubWordBoundary()
    atom.workspaceView.command "subword-navigation:move-left", =>
      @moveToPreviousSubWordBoundary()
    atom.workspaceView.command "subword-navigation:select-right", =>
      @selectToNextSubWordBoundary()
    atom.workspaceView.command "subword-navigation:select-left", =>
      @selectToPreviousSubWordBoundary()

  moveToNextSubWordBoundary: (cursor) ->
    cursor = @editor.getCursor()
    if position = cursor.getMoveNextWordBoundaryBufferPosition(@cursorOptions())
      cursor.setBufferPosition(position)

  moveToPreviousSubWordBoundary: (cursor) ->
    cursor = @editor.getCursor()
    if position = cursor.getPreviousWordBoundaryBufferPosition(@cursorOptions())
      cursor.setBufferPosition(position)

  selectToNextSubWordBoundary: (cursor) ->
    cursor = @editor.getCursor()
    currentPosition = cursor.getBufferPosition()

    return unless currentPosition

    if position = cursor.getMoveNextWordBoundaryBufferPosition(@cursorOptions())
      @editor.getSelection().modifySelection ->
        cursor.setBufferPosition(position)

  selectToPreviousSubWordBoundary: (cursor) ->
    cursor = @editor.getCursor()
    currentPosition = cursor.getBufferPosition()

    return unless currentPosition

    if position = cursor.getPreviousWordBoundaryBufferPosition(@cursorOptions())
      @editor.getSelection().modifySelection ->
        cursor.setBufferPosition(position)

  subwordRegExp: ({includeNonWordCharacters}={}) ->
    includeNonWordCharacters ?= true
    nonWordCharacters = atom.config.get('editor.nonWordCharacters')
    # segments = ["^[\t ]*$"]
    segments = []
    segments.push("[a-z]+")
    segments.push("[A-Z][a-z]+")
    # segments.push("\\s")
    # segments.push("[#{_.escapeRegExp(nonWordCharacters)}]+")
    new RegExp(segments.join("|"), "g")

  cursorOptions: ->
    {wordRegex: @subwordRegExp()}
