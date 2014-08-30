fs = require 'fs-plus'
path = require 'path'
temp = require 'temp'
{WorkspaceView} = require 'atom'

describe 'SubwordNavigation', ->
  [editorView, editor, promise] = []

  beforeEach ->
    atom.workspaceView = new WorkspaceView()
    directory = temp.mkdirSync()
    atom.project.setPath(directory)
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

  describe 'move-right', ->
    it 'does not change an empty file', ->
      editorView.trigger 'subword-navigation:move-right'
      cursorPosition = editor.getCursorBufferPosition()
      expect(cursorPosition.row).toBe 0
      expect(cursorPosition.column).toBe 0

    it "on blank line, before '\n'", ->
      editor.insertText("\n")
      editor.moveCursorUp 1
      editorView.trigger 'subword-navigation:move-right'
      cursorPosition = editor.getCursorBufferPosition()
      expect(cursorPosition.row).toBe 1
      expect(cursorPosition.column).toBe 0

    describe "on '.word.'", ->
      it "when cursor is in the middle", ->
        editor.insertText(".word.\n")
        editor.moveCursorUp 1
        editor.moveCursorRight() for n in [0...2]
        editorView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 5

    describe "on 'getPreviousWord '", ->
      it "when cursor is at the beginning", ->
        editor.insertText("getPreviousWord \n")
        editor.moveCursorUp 1
        editorView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 3

      it "when cursor is at end of first subword", ->
        editor.insertText("getPreviousWord \n")
        editor.moveCursorUp 1
        editor.moveCursorRight() for n in [0...3]
        editorView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 11

      it "when cursor is at end of second subword", ->
        editor.insertText("getPreviousWord \n")
        editor.moveCursorUp 1
        editor.moveCursorRight() for n in [0...11]
        editorView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 15

    describe "on 'sub_word '", ->
      it "when cursor is at the beginning", ->
        editor.insertText("sub_word \n")
        editor.moveCursorUp 1
        editorView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 3

      it "when cursor is at end of first subword", ->
        editor.insertText("sub_word \n")
        editor.moveCursorUp 1
        editor.moveCursorRight() for n in [0...3]
        editorView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 4

      it "when cursor is at the beginnig of second subword", ->
        editor.insertText("sub_word \n")
        editor.moveCursorUp 1
        editor.moveCursorRight() for n in [0...4]
        editorView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 8

    describe "on ', =>'", ->
      it "when cursor is at the beginning", ->
        editor.insertText(", =>\n")
        editor.moveCursorUp 1
        editorView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 1

      it "when cursor is at end of a comma", ->
        editor.insertText(", =>\n")
        editor.moveCursorUp 1
        editor.moveCursorRight()
        editorView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 4

      it "when cursor is at new line", ->
        editor.insertText(", =>\n")
        editor.moveCursorUp 1
        editor.moveCursorRight() for n in [0...4]
        editorView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 1
        expect(cursorPosition.column).toBe 0

    describe "on '  @var'", ->
      it "when cursor is at the beginning", ->
        editor.insertText("  @var\n")
        editor.moveCursorUp 1
        editorView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 3

    describe "on '()'", ->
      it "when cursor is at the beginning", ->
        editor.insertText("()\n")
        editor.moveCursorUp 1
        editorView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 2

    describe "on ' - b'", ->
      it "when cursor is at the beginning", ->
        editor.insertText(" - b\n")
        editor.moveCursorUp 1
        editorView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 2

      it "when cursor is at end of -", ->
        editor.insertText(" - b\n")
        editor.moveCursorUp 1
        editor.moveCursorRight() for n in [0...2]
        editorView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 3

    describe "when 2 cursors", ->
      it "when cursor is at the beginning", ->
        editor.insertText("cursorOptions\ncursorOptions\n")
        editor.moveCursorUp 1
        editor.addCursorAtBufferPosition([0,0])
        editorView.trigger 'subword-navigation:move-right'
        cursorPositions = (c.getScreenPosition() for c in editor.getCursors())
        expect(cursorPositions[0].row).toBe 1
        expect(cursorPositions[0].column).toBe 6
        expect(cursorPositions[1].row).toBe 0
        expect(cursorPositions[1].column).toBe 6

    describe "on 'ALPHA", ->
      it "when cursor is at the beginning", ->
        editor.insertText(" ALPHA\n")
        editor.moveCursorUp 1
        editorView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 1

      it "when cursor is at beginning of word", ->
        editor.insertText(" ALPHA\n")
        editor.moveCursorUp 1
        editor.moveCursorRight()
        editorView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 6

    describe "on 'AAADF ", ->
      it "when cursor is at beginning of word", ->
        editor.insertText(" AAADF \n")
        editor.moveCursorUp 1
        editor.moveCursorRight()
        editorView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 6

    describe "on 'ALPhA", ->
      it "when cursor is at the beginning", ->
        editor.insertText("ALPhA\n")
        editor.moveCursorUp 1
        editorView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 2

      it "when cursor is at beginning of word", ->
        editor.insertText("ALPhA\n")
        editor.moveCursorUp 1
        editor.moveCursorRight()
        editor.moveCursorRight()
        editorView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 4
