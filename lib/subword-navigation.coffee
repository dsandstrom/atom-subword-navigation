module.exports =

  subwordRegex: (cursor) ->
    cursor.wordRegExp(includeNonWordCharacters: true)

  activate: (state) ->
    @editor = atom.workspace.getActiveEditor()

    atom.workspaceView.command "subword-navigation:move-right", =>
      @moveRight()
    atom.workspaceView.command "subword-navigation:move-left", =>
      @moveLeft()
    atom.workspaceView.command "subword-navigation:select-right", =>
      @selectRight()
    atom.workspaceView.command "subword-navigation:select-left", =>
      @selectLeft()

  deactivate: ->

  moveRight: ->
    cursor = @editor.getCursor()
    @moveToNextSubWordBoundary(cursor, @subwordRegex(cursor))

  moveLeft: ->
    cursor = @editor.getCursor()
    @moveToPreviousSubWordBoundary(cursor, @subwordRegex(cursor))

  selectRight: ->
    cursor = @editor.getCursor()
    @selectToNextSubWordBoundary(cursor, @subwordRegex(cursor))

  selectLeft: ->
    cursor = @editor.getCursor()
    @selectToPreviousSubWordBoundary(cursor, @subwordRegex(cursor))

  moveToNextSubWordBoundary: (cursor, regex) ->
    if position = cursor.getMoveNextWordBoundaryBufferPosition(regex)
      cursor.setBufferPosition(position)

  moveToPreviousSubWordBoundary: (cursor, regex) ->
    if position = cursor.getPreviousWordBoundaryBufferPosition(regex)
      cursor.setBufferPosition(position)

  selectToNextSubWordBoundary: (cursor, regex) ->
    currentPosition = cursor.getBufferPosition()
    return unless currentPosition

    if nextPosition = cursor.getMoveNextWordBoundaryBufferPosition(regex)
      @editor.addSelectionForBufferRange([currentPosition, nextPosition])

  selectToPreviousSubWordBoundary: (cursor, regex) ->
    currentPosition = cursor.getBufferPosition()
    return unless currentPosition

    if nextPosition = cursor.getPreviousWordBoundaryBufferPosition(regex)
      @editor.addSelectionForBufferRange([currentPosition, nextPosition], reversed: false)

  # subwordRegExp: ({includeNonWordCharacters}={})->
  #   includeNonWordCharacters ?= true
  #   nonWordCharacters = atom.config.get('editor.nonWordCharacters')
  #   segments = ["^[\t ]*$"]
  #   segments.push("[^\\s#{_.escapeRegExp(nonWordCharacters)}]+")
  #   if includeNonWordCharacters
  #     segments.push("[#{_.escapeRegExp(nonWordCharacters)}]+")
  #   new RegExp(segments.join("|"), "g")
