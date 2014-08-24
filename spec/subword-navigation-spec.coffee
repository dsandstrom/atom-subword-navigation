fs = require 'fs-plus'
path = require 'path'
temp = require 'temp'
{WorkspaceView} = require 'atom'

# TODO: add tests for folded text above

describe 'SubwordNavigation', ->
  [editor, buffer] = []

  beforeEach ->
    directory = temp.mkdirSync()
    atom.project.setPath(directory)
    atom.workspaceView = new WorkspaceView()
    atom.workspace = atom.workspaceView.model
    filePath = path.join(directory, 'example.rb')

    waitsForPromise ->
      atom.workspace.open(filePath).then (e) ->
        editor = e
        buffer = editor.getBuffer()

    waitsForPromise ->
      atom.packages.activatePackage('language-ruby')

    waitsForPromise ->
      atom.packages.activatePackage('subword-navigation')

  describe '::moveRight', ->
    it 'does not change an empty file', ->
      atom.workspaceView.trigger 'subword-navigation:move-right'
      expect(editor.getText()).toBe ''

    describe "on '.word.'", ->
      it "when cursor is in the middle", ->
        editor.insertText(".word.\n")
        editor.moveCursorUp 1
        editor.moveCursorRight() for n in [0...2]
        atom.workspaceView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 5

    describe "on 'getPreviousWord '", ->
      it "when cursor is at the beginning", ->
        editor.insertText("getPreviousWord \n")
        editor.moveCursorUp 1
        atom.workspaceView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 3

      it "when cursor is at end of first subword", ->
        editor.insertText("getPreviousWord \n")
        editor.moveCursorUp 1
        editor.moveCursorRight() for n in [0...3]
        atom.workspaceView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 11

      it "when cursor is at end of second subword", ->
        editor.insertText("getPreviousWord \n")
        editor.moveCursorUp 1
        editor.moveCursorRight() for n in [0...11]
        atom.workspaceView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 15

    describe "on 'sub_word '", ->
      it "when cursor is at the beginning", ->
        editor.insertText("sub_word \n")
        editor.moveCursorUp 1
        atom.workspaceView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 3

      it "when cursor is at end of first subword", ->
        editor.insertText("sub_word \n")
        editor.moveCursorUp 1
        editor.moveCursorRight() for n in [0...3]
        atom.workspaceView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 4

      it "when cursor is at the beginnig of second subword", ->
        editor.insertText("sub_word \n")
        editor.moveCursorUp 1
        editor.moveCursorRight() for n in [0...4]
        atom.workspaceView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 8

    describe "on 'left, =>'", ->
      it "when cursor is at the beginning", ->
        editor.insertText("left, =>\n")
        editor.moveCursorUp 1
        atom.workspaceView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 3

      it "when cursor is at end of first subword", ->
        editor.insertText("left, =>\n")
        editor.moveCursorUp 1
        editor.moveCursorRight() for n in [0...3]
        atom.workspaceView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 11

      it "when cursor is at end of second subword", ->
        editor.insertText("left, =>\n")
        editor.moveCursorUp 1
        editor.moveCursorRight() for n in [0...11]
        atom.workspaceView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 15

  describe '::moveLeft', ->
    it 'does not change an empty file', ->
      atom.workspaceView.trigger 'subword-navigation:move-left'
      expect(editor.getText()).toBe ''

    describe "on '.word.'", ->
      it "when cursor is in the middle", ->
        editor.insertText(".word.\n")
        editor.moveCursorUp 1
        editor.moveCursorRight() for n in [0...4]
        atom.workspaceView.trigger 'subword-navigation:move-left'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 1

  describe '::selectRight', ->
    it 'does not change an empty file', ->
      atom.workspaceView.trigger 'subword-navigation:select-right'
      expect(editor.getText()).toBe ''

    describe "on '.word.'", ->
      it "when cursor is in the middle", ->
        editor.insertText(".word.\n")
        editor.moveCursorUp 1
        editor.moveCursorRight() for n in [0...2]
        atom.workspaceView.trigger 'subword-navigation:select-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 5

      it "when cursor is in the middle", ->
        editor.insertText(".word.\n")
        editor.moveCursorUp 1
        editor.moveCursorRight() for n in [0...2]
        atom.workspaceView.trigger 'subword-navigation:select-right'
        expect(editor.getSelection().getText()).toBe 'ord'

  describe '::selectLeft', ->
    it 'does not change an empty file', ->
      atom.workspaceView.trigger 'subword-navigation:select-left'
      expect(editor.getText()).toBe ''

    describe "on '.word.'", ->
      it "when cursor is in the middle", ->
        editor.insertText(".word.\n")
        editor.moveCursorUp 1
        editor.moveCursorRight() for n in [0...4]
        atom.workspaceView.trigger 'subword-navigation:select-left'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 1

      it "when cursor is in the middle", ->
        editor.insertText(".word.\n")
        editor.moveCursorUp 1
        editor.moveCursorRight() for n in [0...4]
        atom.workspaceView.trigger 'subword-navigation:select-left'
        expect(editor.getSelection().getText()).toBe 'wor'
