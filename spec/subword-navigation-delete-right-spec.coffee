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

  describe 'delete-right', ->
    it 'does not change an empty file', ->
      editorView.trigger 'subword-navigation:delete-right'
      cursorPosition = editor.getCursorBufferPosition()
      expect(cursorPosition.row).toBe 0
      expect(cursorPosition.column).toBe 0
      expect(editor.getText()).toBe ""

    it "on blank line, before '\n'", ->
      editor.insertText("\n")
      editor.moveUp 1
      editorView.trigger 'subword-navigation:delete-right'
      cursorPosition = editor.getCursorBufferPosition()
      expect(cursorPosition.row).toBe 0
      expect(cursorPosition.column).toBe 0
      expect(editor.getText()).toBe ""

    it "on blank line, before '\n\n'", ->
      editor.insertText("\n\n")
      editor.moveUp 1
      editorView.trigger 'subword-navigation:delete-right'
      cursorPosition = editor.getCursorBufferPosition()
      expect(cursorPosition.row).toBe 1
      expect(cursorPosition.column).toBe 0
      expect(editor.getText()).toBe "\n"

    describe "on '.word.'", ->
      it "when cursor is in the middle", ->
        editor.insertText(".word.\n")
        editor.moveUp 1
        editor.moveRight() for n in [0...2]
        editorView.trigger 'subword-navigation:delete-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 2
        expect(editor.getText()).toBe ".w.\n"

    describe "on 'getPreviousWord '", ->
      it "when cursor is at the beginning", ->
        editor.insertText("getPreviousWord \n")
        editor.moveUp 1
        editorView.trigger 'subword-navigation:delete-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 0
        expect(editor.getText()).toBe "PreviousWord \n"

      it "when cursor is at end of first subword", ->
        editor.insertText("getPreviousWord \n")
        editor.moveUp 1
        editor.moveRight() for n in [0...3]
        editorView.trigger 'subword-navigation:delete-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 3
        expect(editor.getText()).toBe "getWord \n"

      it "when cursor is at end of second subword", ->
        editor.insertText("getPreviousWord \n")
        editor.moveUp 1
        editor.moveRight() for n in [0...11]
        editorView.trigger 'subword-navigation:delete-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 11
        expect(editor.getText()).toBe "getPrevious \n"

    describe "on 'sub_word '", ->
      it "when cursor is at the beginning", ->
        editor.insertText("sub_word \n")
        editor.moveUp 1
        editorView.trigger 'subword-navigation:delete-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 0
        expect(editor.getText()).toBe "_word \n"

      it "when cursor is at end of first subword", ->
        editor.insertText("sub_word \n")
        editor.moveUp 1
        editor.moveRight() for n in [0...3]
        editorView.trigger 'subword-navigation:delete-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 3
        expect(editor.getText()).toBe "subword \n"

      it "when cursor is at the beginnig of second subword", ->
        editor.insertText("sub_word \n")
        editor.moveUp 1
        editor.moveRight() for n in [0...4]
        editorView.trigger 'subword-navigation:delete-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 4
        expect(editor.getText()).toBe "sub_ \n"

    describe "on ', =>'", ->
      it "when cursor is at the beginning", ->
        editor.insertText(", =>\n")
        editor.moveUp 1
        editorView.trigger 'subword-navigation:delete-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 0
        expect(editor.getText()).toBe " =>\n"

      it "when cursor is at end of a comma", ->
        editor.insertText(", =>\n")
        editor.moveUp 1
        editor.moveRight()
        editorView.trigger 'subword-navigation:delete-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 1
        expect(editor.getText()).toBe ",\n"

      it "when cursor is at new line", ->
        editor.insertText(", =>\n")
        editor.moveUp 1
        editor.moveRight() for n in [0...4]
        editorView.trigger 'subword-navigation:delete-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 4
        expect(editor.getText()).toBe ", =>"

    describe "on '  @var'", ->
      it "when cursor is at the beginning", ->
        editor.insertText("  @var\n")
        editor.moveUp 1
        editorView.trigger 'subword-navigation:delete-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 0
        expect(editor.getText()).toBe "var\n"

    describe "on '()'", ->
      it "when cursor is at the beginning", ->
        editor.insertText("()\n")
        editor.moveUp 1
        editorView.trigger 'subword-navigation:delete-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 0
        expect(editor.getText()).toBe "\n"

    describe "on ' - b'", ->
      it "when cursor is at the beginning", ->
        editor.insertText(" - b\n")
        editor.moveUp 1
        editorView.trigger 'subword-navigation:delete-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 0
        expect(editor.getText()).toBe " b\n"

      it "when cursor is at end of -", ->
        editor.insertText(" - b\n")
        editor.moveUp 1
        editor.moveRight() for n in [0...2]
        editorView.trigger 'subword-navigation:delete-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 2
        expect(editor.getText()).toBe " -b\n"

    describe "when 2 cursors", ->
      it "when cursor is at the beginning", ->
        editor.insertText("cursorOptions\ncursorOptions\n")
        editor.moveUp 1
        editor.addCursorAtBufferPosition([0,0])
        editorView.trigger 'subword-navigation:delete-right'
        cursorPositions = (c.getScreenPosition() for c in editor.getCursors())
        expect(cursorPositions[0].row).toBe 1
        expect(cursorPositions[0].column).toBe 0
        expect(cursorPositions[1].row).toBe 0
        expect(cursorPositions[1].column).toBe 0
        expect(editor.getText()).toBe "Options\nOptions\n"

      it "when undoing", ->
        editor.insertText("cursorOptions\ncursorOptions\n")
        editor.moveUp 1
        editor.addCursorAtBufferPosition([0,0])
        editorView.trigger 'subword-navigation:delete-right'
        editor.undo()
        cursorPositions = (c.getScreenPosition() for c in editor.getCursors())
        expect(cursorPositions[0].row).toBe 1
        expect(cursorPositions[0].column).toBe 0
        expect(cursorPositions[1].row).toBe 0
        expect(cursorPositions[1].column).toBe 0
        expect(editor.getText()).toBe "cursorOptions\ncursorOptions\n"

    describe "on 'ALPHA", ->
      it "when cursor is at the beginning", ->
        editor.insertText(" ALPHA\n")
        editor.moveUp 1
        editorView.trigger 'subword-navigation:delete-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 0
        expect(editor.getText()).toBe "ALPHA\n"

      it "when cursor is at beginning of word", ->
        editor.insertText(" ALPHA\n")
        editor.moveUp 1
        editor.moveRight()
        editorView.trigger 'subword-navigation:delete-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 1
        expect(editor.getText()).toBe " \n"

    describe "on 'AAADF ", ->
      it "when cursor is at beginning of word", ->
        editor.insertText(" AAADF \n")
        editor.moveUp 1
        editor.moveRight()
        editorView.trigger 'subword-navigation:delete-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 1
        expect(editor.getText()).toBe "  \n"

    describe "on 'ALPhA", ->
      it "when cursor is at the beginning", ->
        editor.insertText("ALPhA\n")
        editor.moveUp 1
        editorView.trigger 'subword-navigation:delete-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 0
        expect(editor.getText()).toBe "PhA\n"

      it "when cursor is at beginning of word", ->
        editor.insertText("ALPhA\n")
        editor.moveUp 1
        editor.moveRight()
        editor.moveRight()
        editorView.trigger 'subword-navigation:delete-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 2
        expect(editor.getText()).toBe "ALA\n"

    describe "on ' 88.1 ", ->
      it "when cursor is at the beginning", ->
        editor.insertText(" 88.1 \n")
        editor.moveUp 1
        editor.moveToBeginningOfLine()
        editorView.trigger 'subword-navigation:delete-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 0
        expect(editor.getText()).toBe "88.1 \n"

      it "when cursor is at start of word", ->
        editor.insertText(" 88.1 \n")
        editor.moveUp 1
        editor.moveToBeginningOfLine()
        editor.moveRight()
        editorView.trigger 'subword-navigation:delete-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 1
        expect(editor.getText()).toBe " .1 \n"

      it "when cursor is at start of second subword", ->
        editor.insertText(" 88.1 \n")
        editor.moveUp 1
        editor.moveRight() for n in [0...4]
        editorView.trigger 'subword-navigation:delete-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 4
        expect(editor.getText()).toBe " 88. \n"
