_ = require 'underscore-plus'
{Point} = require 'atom'

# XXX: Doesn't work well when going left on first line
# XXX: Select left broken

module.exports =
class SubwordNavigation
  constructor: ->
    @editor = atom.workspace.getActiveEditor()

  destroy: ->

  moveToNextSubwordBoundary: ->
    for cursor in @cursors()
      if position = cursor.getMoveNextWordBoundaryBufferPosition(@cursorOptions())
        cursor.setBufferPosition(position)

  moveToPreviousSubwordBoundary: ->
    for cursor in @cursors()
      if position = cursor.getPreviousWordBoundaryBufferPosition(@cursorOptions(backwards: true))
        cursor.setBufferPosition(position)

  selectToNextSubwordBoundary: ->
    for selection in @selections()
      cursor = selection.cursor
      position = cursor.getMoveNextWordBoundaryBufferPosition(@cursorOptions())
      if cursor and position
        selection.modifySelection ->
          cursor.setBufferPosition(position)

  selectToPreviousSubwordBoundary: ->
    for selection in @selections()
      cursor = selection.cursor
      position = cursor.getPreviousWordBoundaryBufferPosition(@cursorOptions(backwards: true))
      if cursor and position
        selection.modifySelection ->
          cursor.setBufferPosition(position)

  subwordRegExp: (options={}) ->
    nonWordCharacters = atom.config.get('editor.nonWordCharacters')
    segments = ["^[\t ]*$"]
    segments.push("[a-z]+")
    segments.push("[A-Z][a-z]+")
    segments.push("\\n")
    if options.backwards
      segments.push("[#{_.escapeRegExp(nonWordCharacters)}]+\\s*")
    else
      segments.push("\\s*[#{_.escapeRegExp(nonWordCharacters)}]+")
    new RegExp(segments.join("|"), "g")

  cursors: ->
    @editor.getCursors()

  selections: ->
    @editor.getSelections()

  cursorOptions: (options={}) ->
    {wordRegex: @subwordRegExp(options)}
