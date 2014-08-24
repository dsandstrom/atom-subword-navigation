_ = require 'underscore-plus'

module.exports =
class SubwordNavigation
  editor: null

  constructor: ->
    @editor = atom.workspace.getActiveEditor()

  destroy: ->

  subwordRegExp: ->
    nonWordCharacters = atom.config.get('editor.nonWordCharacters')
    # remove characters that we want to skip over
    nonWordCharacters = nonWordCharacters.replace(/[\-\=\>\@]/g, '')

    segments = ["^[\t ]*$"]
    segments.push("[a-z]+")
    segments.push("[A-Z][a-z]+")
    segments.push("\\n")
    segments.push("^")
    # segments.push("^[\t ]*")
    segments.push("[#{_.escapeRegExp(nonWordCharacters)}]+")
    new RegExp(segments.join("|"), "g")

  cursorOptions: ->
    {wordRegex: @subwordRegExp()}

  moveToNextSubwordBoundary: ->
    for cursor in @editor.getCursors()
      if position = cursor.getMoveNextWordBoundaryBufferPosition(@cursorOptions())
        cursor.setBufferPosition(position)

  moveToPreviousSubwordBoundary: ->
    for cursor in @editor.getCursors()
      if position = cursor.getPreviousWordBoundaryBufferPosition(@cursorOptions())
        cursor.setBufferPosition(position)

  selectToNextSubwordBoundary: ->
    for cursor in @editor.getCursors()
      currentPosition = cursor.getBufferPosition()

      next unless currentPosition

      if position = cursor.getMoveNextWordBoundaryBufferPosition(@cursorOptions())
        @editor.getSelection().modifySelection ->
          cursor.setBufferPosition(position)

  selectToPreviousSubwordBoundary: ->
    for cursor in @editor.getCursors()
      currentPosition = cursor.getBufferPosition()

      next unless currentPosition

      if position = cursor.getPreviousWordBoundaryBufferPosition(@cursorOptions())
        @editor.getSelection().modifySelection ->
          cursor.setBufferPosition(position)
