fs = require 'fs-plus'
path = require 'path'
temp = require 'temp'
{WorkspaceView} = require 'atom'

# TODO: add tests for folded text above

describe 'SubwordNavigation', ->
  [editorView, editor, promise] = []

  beforeEach ->
    atom.workspaceView = new WorkspaceView()
    directory = temp.mkdirSync()
    atom.project.setPaths(directory)
    filePath = path.join(directory, 'example.rb')

    waitsForPromise ->
      atom.workspace.open(filePath)

    runs ->
      atom.workspaceView.attachToDom()
      editorView = atom.workspaceView.getActiveView()
      editor = editorView.getEditor()
      promise = atom.packages.activatePackage('subword-navigation')

    waitsForPromise ->
      promise

  describe 'select-left', ->
    it 'does not change an empty file', ->
      editorView.trigger 'subword-navigation:select-left'
      cursorPosition = editor.getCursorBufferPosition()
      expect(cursorPosition.row).toBe 0
      expect(cursorPosition.column).toBe 0

    it "on blank line, before '\n\n'", ->
      editor.insertText("\n\n")
      editor.moveUp 1
      editorView.trigger 'subword-navigation:select-left'
      cursorPosition = editor.getCursorBufferPosition()
      expect(cursorPosition.row).toBe 0
      expect(cursorPosition.column).toBe 0

    it "on blank line, before '\n\n'", ->
      editor.insertText("\n\n")
      editor.moveUp 1
      editorView.trigger 'subword-navigation:select-left'
      selectionRange = editor.getLastSelection().getBufferRange()
      expect(selectionRange.start.row).toBe 0
      expect(selectionRange.start.column).toBe 0
      expect(selectionRange.end.row).toBe 1
      expect(selectionRange.end.column).toBe 0

    describe "on '.word.'", ->
      it "when cursor is in the middle", ->
        editor.insertText(".word.\n")
        editor.moveUp 1
        editor.moveRight() for n in [0...4]
        editorView.trigger 'subword-navigation:select-left'
        selectionRange = editor.getLastSelection().getBufferRange()
        expect(selectionRange.start.row).toBe 0
        expect(selectionRange.start.column).toBe 1
        expect(selectionRange.end.row).toBe 0
        expect(selectionRange.end.column).toBe 4

    describe "on ' getPreviousWord '", ->
      it "when cursor is at the end", ->
        editor.insertText(" getPreviousWord \n")
        editor.moveUp 1
        editor.moveToEndOfLine()
        editorView.trigger 'subword-navigation:select-left'
        selectionRange = editor.getLastSelection().getBufferRange()
        expect(selectionRange.start.row).toBe 0
        expect(selectionRange.start.column).toBe 16
        expect(selectionRange.end.row).toBe 0
        expect(selectionRange.end.column).toBe 17

      it "when cursor is at the word", ->
        editor.insertText(" getPreviousWord \n")
        editor.moveUp 1
        editor.moveToEndOfLine()
        editor.moveLeft()
        editorView.trigger 'subword-navigation:select-left'
        selectionRange = editor.getLastSelection().getBufferRange()
        expect(selectionRange.start.row).toBe 0
        expect(selectionRange.start.column).toBe 12
        expect(selectionRange.end.row).toBe 0
        expect(selectionRange.end.column).toBe 16

      it "when cursor is at end of second subword", ->
        editor.insertText(" getPreviousWord \n")
        editor.moveUp 1
        editor.moveRight() for n in [0...12]
        editorView.trigger 'subword-navigation:select-left'
        selectionRange = editor.getLastSelection().getBufferRange()
        expect(selectionRange.start.row).toBe 0
        expect(selectionRange.start.column).toBe 4
        expect(selectionRange.end.row).toBe 0
        expect(selectionRange.end.column).toBe 12

      it "when cursor is at end of first subword", ->
        editor.insertText(" getPreviousWord \n")
        editor.moveUp 1
        editor.moveRight() for n in [0...4]
        editorView.trigger 'subword-navigation:select-left'
        selectionRange = editor.getLastSelection().getBufferRange()
        expect(selectionRange.start.row).toBe 0
        expect(selectionRange.start.column).toBe 1
        expect(selectionRange.end.row).toBe 0
        expect(selectionRange.end.column).toBe 4

    describe "on ' sub_word'", ->
      it "when cursor is at the end", ->
        editor.insertText(" sub_word\n")
        editor.moveUp 1
        editor.moveToEndOfLine()
        editorView.trigger 'subword-navigation:select-left'
        selectionRange = editor.getLastSelection().getBufferRange()
        expect(selectionRange.start.row).toBe 0
        expect(selectionRange.start.column).toBe 5
        expect(selectionRange.end.row).toBe 0
        expect(selectionRange.end.column).toBe 9

      it "when cursor is at beginning of second subword", ->
        editor.insertText(" sub_word\n")
        editor.moveUp 1
        editor.moveRight() for n in [0...5]
        editorView.trigger 'subword-navigation:select-left'
        selectionRange = editor.getLastSelection().getBufferRange()
        expect(selectionRange.start.row).toBe 0
        expect(selectionRange.start.column).toBe 4
        expect(selectionRange.end.row).toBe 0
        expect(selectionRange.end.column).toBe 5

      it "when cursor is at the beginnig of second subword", ->
        editor.insertText(" sub_word\n")
        editor.moveUp 1
        editor.moveRight() for n in [0...4]
        editorView.trigger 'subword-navigation:select-left'
        selectionRange = editor.getLastSelection().getBufferRange()
        expect(selectionRange.start.row).toBe 0
        expect(selectionRange.start.column).toBe 1
        expect(selectionRange.end.row).toBe 0
        expect(selectionRange.end.column).toBe 4

    describe "on ', =>'", ->
      it "when cursor is at the beginning", ->
        editor.insertText(", =>\n")
        editor.moveUp 1
        editor.moveToEndOfLine()
        editorView.trigger 'subword-navigation:select-left'
        selectionRange = editor.getLastSelection().getBufferRange()
        expect(selectionRange.start.row).toBe 0
        expect(selectionRange.start.column).toBe 2
        expect(selectionRange.end.row).toBe 0
        expect(selectionRange.end.column).toBe 4

      it "when cursor is at beginning of =", ->
        editor.insertText(", =>\n")
        editor.moveUp 1
        editor.moveRight()
        editor.moveRight()
        editorView.trigger 'subword-navigation:select-left'
        selectionRange = editor.getLastSelection().getBufferRange()
        expect(selectionRange.start.row).toBe 0
        expect(selectionRange.start.column).toBe 0
        expect(selectionRange.end.row).toBe 0
        expect(selectionRange.end.column).toBe 2

    describe "on '  @var'", ->
      it "when cursor is at the end", ->
        editor.insertText("  @var\n")
        editor.moveUp 1
        editor.moveToEndOfLine()
        editorView.trigger 'subword-navigation:select-left'
        selectionRange = editor.getLastSelection().getBufferRange()
        expect(selectionRange.start.row).toBe 0
        expect(selectionRange.start.column).toBe 3
        expect(selectionRange.end.row).toBe 0
        expect(selectionRange.end.column).toBe 6

      it "when cursor is at beginning of word", ->
        editor.insertText("  @var\n")
        editor.moveUp 1
        editor.moveRight() for n in [0...2]
        editorView.trigger 'subword-navigation:select-left'
        selectionRange = editor.getLastSelection().getBufferRange()
        expect(selectionRange.start.row).toBe 0
        expect(selectionRange.start.column).toBe 2
        expect(selectionRange.end.row).toBe 0
        expect(selectionRange.end.column).toBe 3

      it "when cursor is at beginning of @", ->
        editor.insertText("  @var\n")
        editor.moveUp 1
        editor.moveRight()
        editorView.trigger 'subword-navigation:select-left'
        selectionRange = editor.getLastSelection().getBufferRange()
        expect(selectionRange.start.row).toBe 0
        expect(selectionRange.start.column).toBe 0
        expect(selectionRange.end.row).toBe 0
        expect(selectionRange.end.column).toBe 2

    describe "on '\n  @var'", ->
      it "when cursor is at the end", ->
        editor.insertText("\n  @var\n")
        editor.moveUp 1
        editor.moveToEndOfLine()
        editorView.trigger 'subword-navigation:select-left'
        selectionRange = editor.getLastSelection().getBufferRange()
        expect(selectionRange.start.row).toBe 1
        expect(selectionRange.start.column).toBe 3
        expect(selectionRange.end.row).toBe 1
        expect(selectionRange.end.column).toBe 6

      it "when cursor is at beginning of word", ->
        editor.insertText("\n  @var\n")
        editor.moveUp 1
        editor.moveRight() for n in [0...2]
        editorView.trigger 'subword-navigation:select-left'
        selectionRange = editor.getLastSelection().getBufferRange()
        expect(selectionRange.start.row).toBe 1
        expect(selectionRange.start.column).toBe 2
        expect(selectionRange.end.row).toBe 1
        expect(selectionRange.end.column).toBe 3

      it "when cursor is at beginning of @", ->
        editor.insertText("\n  @var\n")
        editor.moveUp 1
        editor.moveRight() for n in [0...1]
        editorView.trigger 'subword-navigation:select-left'
        selectionRange = editor.getLastSelection().getBufferRange()
        expect(selectionRange.start.row).toBe 1
        expect(selectionRange.start.column).toBe 0
        expect(selectionRange.end.row).toBe 1
        expect(selectionRange.end.column).toBe 2

    describe "on ' ()'", ->
      it "when cursor is at the end", ->
        editor.insertText(" ()\n")
        editor.moveUp 1
        editor.moveToEndOfLine()
        editorView.trigger 'subword-navigation:select-left'
        selectionRange = editor.getLastSelection().getBufferRange()
        expect(selectionRange.start.row).toBe 0
        expect(selectionRange.start.column).toBe 1
        expect(selectionRange.end.row).toBe 0
        expect(selectionRange.end.column).toBe 3

      it "when first characters of line", ->
        editor.insertText("()\n")
        editor.moveUp 1
        editor.moveToEndOfLine()
        editorView.trigger 'subword-navigation:select-left'
        selectionRange = editor.getLastSelection().getBufferRange()
        expect(selectionRange.start.row).toBe 0
        expect(selectionRange.start.column).toBe 0
        expect(selectionRange.end.row).toBe 0
        expect(selectionRange.end.column).toBe 2

    describe "on 'a - '", ->
      it "when cursor is at the end", ->
        editor.insertText("a - \n")
        editor.moveUp 1
        editor.moveToEndOfLine()
        editorView.trigger 'subword-navigation:select-left'
        selectionRange = editor.getLastSelection().getBufferRange()
        expect(selectionRange.start.row).toBe 0
        expect(selectionRange.start.column).toBe 2
        expect(selectionRange.end.row).toBe 0
        expect(selectionRange.end.column).toBe 4

      it "when cursor is at beginning of -", ->
        editor.insertText("a - \n")
        editor.moveUp 1
        editor.moveRight() for n in [0...2]
        editorView.trigger 'subword-navigation:select-left'
        selectionRange = editor.getLastSelection().getBufferRange()
        expect(selectionRange.start.row).toBe 0
        expect(selectionRange.start.column).toBe 1
        expect(selectionRange.end.row).toBe 0
        expect(selectionRange.end.column).toBe 2

    describe "when 2 cursors", ->
      it "when cursor is at the end", ->
        editor.insertText("cursorOptions\ncursorOptions\n")
        editor.moveUp 1
        editor.moveToEndOfLine()
        editor.addCursorAtBufferPosition([0,13])
        editorView.trigger 'subword-navigation:select-left'
        selectionRanges = editor.getSelections().map (s) -> s.getBufferRange()
        expect(selectionRanges[0].start.row).toBe 1
        expect(selectionRanges[0].start.column).toBe 6
        expect(selectionRanges[0].end.row).toBe 1
        expect(selectionRanges[0].end.column).toBe 13
        expect(selectionRanges[1].start.row).toBe 0
        expect(selectionRanges[1].start.column).toBe 6
        expect(selectionRanges[1].end.row).toBe 0
        expect(selectionRanges[1].end.column).toBe 13

    describe "on 'ALPHA", ->
      it "when cursor is at the end", ->
        editor.insertText(" ALPHA\n")
        editor.moveUp 1
        editor.moveToEndOfLine()
        editorView.trigger 'subword-navigation:select-left'
        selectionRange = editor.getLastSelection().getBufferRange()
        expect(selectionRange.start.row).toBe 0
        expect(selectionRange.start.column).toBe 1
        expect(selectionRange.end.row).toBe 0
        expect(selectionRange.end.column).toBe 6

    describe "on 'AAADF ", ->
      it "when cursor is at the end", ->
        editor.insertText(" ALPHA \n")
        editor.moveUp 1
        editor.moveToEndOfLine()
        editorView.trigger 'subword-navigation:select-left'
        selectionRange = editor.getLastSelection().getBufferRange()
        expect(selectionRange.start.row).toBe 0
        expect(selectionRange.start.column).toBe 6
        expect(selectionRange.end.row).toBe 0
        expect(selectionRange.end.column).toBe 7

      it "when cursor is at end of word", ->
        editor.insertText(" AAADF \n")
        editor.moveUp 1
        editor.moveToEndOfLine()
        editor.moveLeft()
        editorView.trigger 'subword-navigation:select-left'
        selectionRange = editor.getLastSelection().getBufferRange()
        expect(selectionRange.start.row).toBe 0
        expect(selectionRange.start.column).toBe 1
        expect(selectionRange.end.row).toBe 0
        expect(selectionRange.end.column).toBe 6

    describe "on 'ALPhA", ->
      it "when cursor is at the end", ->
        editor.insertText("ALPhA\n")
        editor.moveUp 1
        editor.moveToEndOfLine()
        editorView.trigger 'subword-navigation:select-left'
        selectionRange = editor.getLastSelection().getBufferRange()
        expect(selectionRange.start.row).toBe 0
        expect(selectionRange.start.column).toBe 4
        expect(selectionRange.end.row).toBe 0
        expect(selectionRange.end.column).toBe 5

      it "when cursor is at end of subword", ->
        editor.insertText("ALPhA\n")
        editor.moveUp 1
        editor.moveRight() for n in [0...4]
        editorView.trigger 'subword-navigation:select-left'
        selectionRange = editor.getLastSelection().getBufferRange()
        expect(selectionRange.start.row).toBe 0
        expect(selectionRange.start.column).toBe 2
        expect(selectionRange.end.row).toBe 0
        expect(selectionRange.end.column).toBe 4

      it "when cursor is at beginning of subword", ->
        editor.insertText("ALPhA\n")
        editor.moveUp 1
        editor.moveRight()
        editor.moveRight()
        editorView.trigger 'subword-navigation:select-left'
        selectionRange = editor.getLastSelection().getBufferRange()
        expect(selectionRange.start.row).toBe 0
        expect(selectionRange.start.column).toBe 0
        expect(selectionRange.end.row).toBe 0
        expect(selectionRange.end.column).toBe 2

    describe "on ' 88.1 ", ->
      it "when cursor is at the end", ->
        editor.insertText(" 88.1 \n")
        editor.moveUp 1
        editor.moveToEndOfLine()
        editorView.trigger 'subword-navigation:select-left'
        selectionRange = editor.getLastSelection().getBufferRange()
        expect(selectionRange.start.row).toBe 0
        expect(selectionRange.start.column).toBe 5
        expect(selectionRange.end.row).toBe 0
        expect(selectionRange.end.column).toBe 6

      it "when cursor is at end of word", ->
        editor.insertText(" 88.1 \n")
        editor.moveUp 1
        editor.moveToEndOfLine()
        editor.moveLeft()
        editorView.trigger 'subword-navigation:select-left'
        selectionRange = editor.getLastSelection().getBufferRange()
        expect(selectionRange.start.row).toBe 0
        expect(selectionRange.start.column).toBe 4
        expect(selectionRange.end.row).toBe 0
        expect(selectionRange.end.column).toBe 5

      it "when cursor is at end of subword", ->
        editor.insertText(" 88.1 \n")
        editor.moveUp 1
        editor.moveRight() for n in [0...3]
        editorView.trigger 'subword-navigation:select-left'
        selectionRange = editor.getLastSelection().getBufferRange()
        expect(selectionRange.start.row).toBe 0
        expect(selectionRange.start.column).toBe 1
        expect(selectionRange.end.row).toBe 0
        expect(selectionRange.end.column).toBe 3
