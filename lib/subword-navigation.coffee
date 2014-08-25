_ = require 'underscore-plus'
{Point} = require 'atom'

module.exports =
class SubwordNavigation
  constructor: ->
    @editor = atom.workspace.getActiveEditor()

  destroy: ->

  moveToNextSubwordBoundary: ->
    for cursor in @cursors()
      if position = @getMoveNextWordBoundaryBufferPosition(cursor, @cursorOptions())
        cursor.setBufferPosition(position)

  moveToPreviousSubwordBoundary: ->
    for cursor in @cursors()
      if position = cursor.getPreviousWordBoundaryBufferPosition(@cursorOptions())
        cursor.setBufferPosition(position)

  selectToNextSubwordBoundary: ->
    for selection in @selections()
      cursor = selection.cursor
      position = @getMoveNextWordBoundaryBufferPosition(cursor, @cursorOptions())
      if cursor and position
        selection.modifySelection ->
          cursor.setBufferPosition(position)

  selectToPreviousSubwordBoundary: ->
    for selection in @selections()
      cursor = selection.cursor
      position = cursor.getPreviousWordBoundaryBufferPosition(@cursorOptions())
      if cursor and position
        selection.modifySelection ->
          cursor.setBufferPosition(position)

  subwordRegExp: ->
    nonWordCharacters = atom.config.get('editor.nonWordCharacters')
    # remove characters that we want to skip over
    # specialNonWords = '-='
    # nonWordCharacters = nonWordCharacters.replace(/[\-\=\>\@]/g, '')

    # build regex
    segments = ["^[\t ]*$"]
    segments.push("[a-z]+")
    segments.push("[A-Z][a-z]+")
    # segments.push("\\r")
    segments.push("\\n")
    # segments.push("^")
    segments.push("\\s*[#{_.escapeRegExp(nonWordCharacters)}]+")
    # segments.push("[\=\-][^\>]+")
    # segments.push("[^\=\-][\>]+")
    new RegExp(segments.join("|"), "g")

  cursors: ->
    @editor.getCursors()

  selections: ->
    @editor.getSelections()

  cursorOptions: ->
    {wordRegex: @subwordRegExp()}

  getMoveNextWordBoundaryBufferPosition: (cursor, options = {}) ->
    currentBufferPosition = cursor.getBufferPosition()
    scanRange = [currentBufferPosition, @editor.getEofBufferPosition()]
    endOfWordPosition = null
    @editor.scanInBufferRange (options.wordRegex ? @wordRegExp()), scanRange, ({match, range, stop}) =>
      # console.log match
      if range.start.row > currentBufferPosition.row
        # force it to stop at the beginning of each line
        endOfWordPosition = new Point(range.start.row, 0)
      else if range.start.isGreaterThan(currentBufferPosition)
        endOfWordPosition = range.start
      else
        endOfWordPosition = range.end
      if not endOfWordPosition?.isEqual(currentBufferPosition)
        stop()
    endOfWordPosition or currentBufferPosition
