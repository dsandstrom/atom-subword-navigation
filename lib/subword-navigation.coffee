_ = require 'underscore-plus'

module.exports =
class SubwordNavigation
  editor: null

  constructor: ->
    @editor = atom.workspace.getActiveEditor()

  destroy: ->

  moveToNextSubwordBoundary: ->
    for cursor in @cursors()
      if position = cursor.getMoveNextWordBoundaryBufferPosition(@cursorOptions())
        cursor.setBufferPosition(position)

  moveToPreviousSubwordBoundary: ->
    for cursor in @cursors()
      if position = cursor.getPreviousWordBoundaryBufferPosition(@cursorOptions())
        cursor.setBufferPosition(position)

  selectToNextSubwordBoundary: ->
    for selection in @selections()
      cursor = selection.cursor
      if position = cursor.getMoveNextWordBoundaryBufferPosition(@cursorOptions())
        selection.modifySelection ->
          cursor.setBufferPosition(position)

  selectToPreviousSubwordBoundary: ->
    for selection in @selections()
      cursor = selection.cursor
      if position = cursor.getPreviousWordBoundaryBufferPosition(@cursorOptions())
        selection.modifySelection ->
          cursor.setBufferPosition(position)

  subwordRegExp: ->
    nonWordCharacters = atom.config.get('editor.nonWordCharacters')
    # remove characters that we want to skip over
    nonWordCharacters = nonWordCharacters.replace(/[\-\=\>\@]/g, '')

    segments = ["^[\t ]*$"]
    segments.push("[a-z]+")
    segments.push("[A-Z][a-z]+")
    segments.push("\\n")
    # segments.push("^")
    # segments.push("^[\t ]*")
    segments.push("[#{_.escapeRegExp(nonWordCharacters)}]+")
    new RegExp(segments.join("|"), "g")

  cursors: ->
    @editor.getCursors()

  selections: ->
    @editor.getSelections()

  cursorOptions: ->
    {wordRegex: @subwordRegExp()}
