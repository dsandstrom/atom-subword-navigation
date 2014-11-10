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

  describe 'move-left', ->
    it 'does not change an empty file', ->
      editorView.trigger 'subword-navigation:move-left'
      cursorPosition = editor.getCursorBufferPosition()
      expect(cursorPosition.row).toBe 0
      expect(cursorPosition.column).toBe 0

    it "on blank line, before '\n'", ->
      editor.insertText("\n")
      editor.moveUp 1
      editorView.trigger 'subword-navigation:move-left'
      cursorPosition = editor.getCursorBufferPosition()
      expect(cursorPosition.row).toBe 0
      expect(cursorPosition.column).toBe 0

    describe "on '.word.'", ->
      it "when cursor is in the middle", ->
        editor.insertText(".word.\n")
        editor.moveUp 1
        editor.moveRight() for n in [0...4]
        editorView.trigger 'subword-navigation:move-left'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 1

    describe "on ' getPreviousWord '", ->
      it "when cursor is at the end", ->
        editor.insertText(" getPreviousWord \n")
        editor.moveUp 1
        editor.moveToEndOfLine()
        editorView.trigger 'subword-navigation:move-left'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 16

      it "when cursor is at the word", ->
        editor.insertText(" getPreviousWord \n")
        editor.moveUp 1
        editor.moveToEndOfLine()
        editor.moveLeft()
        editorView.trigger 'subword-navigation:move-left'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 12

      it "when cursor is at end of second subword", ->
        editor.insertText(" getPreviousWord \n")
        editor.moveUp 1
        editor.moveRight() for n in [0...12]
        editorView.trigger 'subword-navigation:move-left'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 4

      it "when cursor is at end of first subword", ->
        editor.insertText(" getPreviousWord \n")
        editor.moveUp 1
        editor.moveRight() for n in [0...4]
        editorView.trigger 'subword-navigation:move-left'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 1

    describe "on ' sub_word'", ->
      it "when cursor is at the end", ->
        editor.insertText(" sub_word\n")
        editor.moveUp 1
        editor.moveToEndOfLine()
        editorView.trigger 'subword-navigation:move-left'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 5

      it "when cursor is at beginning of second subword", ->
        editor.insertText(" sub_word\n")
        editor.moveUp 1
        editor.moveRight() for n in [0...5]
        editorView.trigger 'subword-navigation:move-left'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 4

      it "when cursor is at the beginnig of second subword", ->
        editor.insertText(" sub_word\n")
        editor.moveUp 1
        editor.moveRight() for n in [0...4]
        editorView.trigger 'subword-navigation:move-left'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 1

    describe "on ', =>'", ->
      it "when cursor is at the beginning", ->
        editor.insertText(", =>\n")
        editor.moveUp 1
        editor.moveToEndOfLine()
        editorView.trigger 'subword-navigation:move-left'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 2

      it "when cursor is at beginning of =", ->
        editor.insertText(", =>\n")
        editor.moveUp 1
        editor.moveRight()
        editor.moveRight()
        editorView.trigger 'subword-navigation:move-left'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 0

    describe "on '  @var'", ->
      it "when cursor is at the end", ->
        editor.insertText("  @var\n")
        editor.moveUp 1
        editor.moveToEndOfLine()
        editorView.trigger 'subword-navigation:move-left'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 3

      it "when cursor is at beginning of word", ->
        editor.insertText("  @var\n")
        editor.moveUp 1
        editor.moveRight() for n in [0...2]
        editorView.trigger 'subword-navigation:move-left'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 2

      it "when cursor is at beginning of @", ->
        editor.insertText("  @var\n")
        editor.moveUp 1
        editor.moveRight()
        editorView.trigger 'subword-navigation:move-left'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 0

    describe "on '\n  @var'", ->
      it "when cursor is at the end", ->
        editor.insertText("\n  @var\n")
        editor.moveUp 1
        editor.moveToEndOfLine()
        editorView.trigger 'subword-navigation:move-left'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 1
        expect(cursorPosition.column).toBe 3

      it "when cursor is at beginning of word", ->
        editor.insertText("\n  @var\n")
        editor.moveUp 1
        editor.moveRight() for n in [0...2]
        editorView.trigger 'subword-navigation:move-left'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 1
        expect(cursorPosition.column).toBe 2

      it "when cursor is at beginning of @", ->
        editor.insertText("\n  @var\n")
        editor.moveUp 1
        editor.moveRight() for n in [0...1]
        editorView.trigger 'subword-navigation:move-left'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 1
        expect(cursorPosition.column).toBe 0

    describe "on ' ()'", ->
      it "when cursor is at the end", ->
        editor.insertText(" ()\n")
        editor.moveUp 1
        editor.moveToEndOfLine()
        editorView.trigger 'subword-navigation:move-left'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 1

      it "when first characters of line", ->
        editor.insertText("()\n")
        editor.moveUp 1
        editor.moveToEndOfLine()
        editorView.trigger 'subword-navigation:move-left'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 0

    describe "on 'a - '", ->
      it "when cursor is at the end", ->
        editor.insertText("a - \n")
        editor.moveUp 1
        editor.moveToEndOfLine()
        editorView.trigger 'subword-navigation:move-left'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 2

      it "when cursor is at beginning of -", ->
        editor.insertText("a - \n")
        editor.moveUp 1
        editor.moveRight() for n in [0...2]
        editorView.trigger 'subword-navigation:move-left'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 1

    describe "when 2 cursors", ->
      it "when cursor is at the end", ->
        editor.insertText("cursorOptions\ncursorOptions\n")
        editor.moveUp 1
        editor.moveToEndOfLine()
        editor.addCursorAtBufferPosition([0,13])
        editorView.trigger 'subword-navigation:move-left'
        cursorPositions = (c.getScreenPosition() for c in editor.getCursors())
        expect(cursorPositions[0].row).toBe 1
        expect(cursorPositions[0].column).toBe 6
        expect(cursorPositions[1].row).toBe 0
        expect(cursorPositions[1].column).toBe 6
        describe "on 'ALPHA", ->
      it "when cursor is at the end", ->
        editor.insertText(" ALPHA\n")
        editor.moveUp 1
        editor.moveToEndOfLine()
        editorView.trigger 'subword-navigation:move-left'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 1

    describe "on 'AAADF ", ->
      it "when cursor is at the end", ->
        editor.insertText(" ALPHA \n")
        editor.moveUp 1
        editor.moveToEndOfLine()
        editorView.trigger 'subword-navigation:move-left'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 6

      it "when cursor is at end of word", ->
        editor.insertText(" AAADF \n")
        editor.moveUp 1
        editor.moveToEndOfLine()
        editor.moveLeft()
        editorView.trigger 'subword-navigation:move-left'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 1

    describe "on 'ALPhA", ->
      it "when cursor is at the end", ->
        editor.insertText("ALPhA\n")
        editor.moveUp 1
        editor.moveToEndOfLine()
        editorView.trigger 'subword-navigation:move-left'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 4

      it "when cursor is at end of subword", ->
        editor.insertText("ALPhA\n")
        editor.moveUp 1
        editor.moveRight() for n in [0...4]
        editorView.trigger 'subword-navigation:move-left'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 2

      it "when cursor is at beginning of subword", ->
        editor.insertText("ALPhA\n")
        editor.moveUp 1
        editor.moveRight()
        editor.moveRight()
        editorView.trigger 'subword-navigation:move-left'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 0

    describe "on ' 88.1 ", ->
      it "when cursor is at the end", ->
        editor.insertText(" 88.1 \n")
        editor.moveUp 1
        editor.moveToEndOfLine()
        editorView.trigger 'subword-navigation:move-left'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 5

      it "when cursor is at end of word", ->
        editor.insertText(" 88.1 \n")
        editor.moveUp 1
        editor.moveToEndOfLine()
        editor.moveLeft()
        editorView.trigger 'subword-navigation:move-left'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 4

      it "when cursor is at end of subword", ->
        editor.insertText(" 88.1 \n")
        editor.moveUp 1
        editor.moveRight() for n in [0...3]
        editorView.trigger 'subword-navigation:move-left'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 1
