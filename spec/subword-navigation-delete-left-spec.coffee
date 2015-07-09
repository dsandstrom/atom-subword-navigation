# describe 'SubwordNavigation', ->
#   [workspaceElement, editorView, editor, activationPromise] = []
#
#   beforeEach ->
#     workspaceElement = atom.views.getView(atom.workspace)
#     jasmine.attachToDOM(workspaceElement)
#
#     waitsForPromise ->
#       atom.workspace.open('sample.rb').then (o) ->
#         editor = o
#         editorView = atom.views.getView(editor)
#
#     waitsForPromise ->
#       atom.packages.activatePackage('subword-navigation')
#
#   describe 'delete-left', ->
#     it 'does not change an empty file', ->
#       atom.commands.dispatch editorView, 'subword-navigation:delete-left'
#       cursorPosition = editor.getCursorBufferPosition()
#       expect(cursorPosition.row).toBe 0
#       expect(cursorPosition.column).toBe 0
#
#     it "on blank line, before '\n'", ->
#       editor.insertText("\n")
#       editor.moveUp 1
#       atom.commands.dispatch editorView, 'subword-navigation:delete-left'
#       cursorPosition = editor.getCursorBufferPosition()
#       expect(cursorPosition.row).toBe 0
#       expect(cursorPosition.column).toBe 0
#       expect(editor.getText()).toBe "\n"
#
#     it "on blank line, before '\n\n'", ->
#       editor.insertText("\n\n")
#       editor.moveUp 1
#       atom.commands.dispatch editorView, 'subword-navigation:delete-left'
#       cursorPosition = editor.getCursorBufferPosition()
#       expect(cursorPosition.row).toBe 0
#       expect(cursorPosition.column).toBe 0
#       expect(editor.getText()).toBe "\n"
#
#     describe "on '.word.'", ->
#       it "when cursor is in the middle", ->
#         editor.insertText(".word.\n")
#         editor.moveUp 1
#         editor.moveRight() for n in [0...4]
#         atom.commands.dispatch editorView, 'subword-navigation:delete-left'
#         cursorPosition = editor.getCursorBufferPosition()
#         expect(cursorPosition.row).toBe 0
#         expect(cursorPosition.column).toBe 1
#         expect(editor.getText()).toBe ".d.\n"
#
#     describe "on ' getPreviousWord '", ->
#       it "when cursor is at the end", ->
#         editor.insertText(" getPreviousWord \n")
#         editor.moveUp 1
#         editor.moveToEndOfLine()
#         atom.commands.dispatch editorView, 'subword-navigation:delete-left'
#         cursorPosition = editor.getCursorBufferPosition()
#         expect(cursorPosition.row).toBe 0
#         expect(cursorPosition.column).toBe 16
#         expect(editor.getText()).toBe " getPreviousWord\n"
#
#       it "when cursor is at the word", ->
#         editor.insertText(" getPreviousWord \n")
#         editor.moveUp 1
#         editor.moveToEndOfLine()
#         editor.moveLeft()
#         atom.commands.dispatch editorView, 'subword-navigation:delete-left'
#         cursorPosition = editor.getCursorBufferPosition()
#         expect(cursorPosition.row).toBe 0
#         expect(cursorPosition.column).toBe 12
#         expect(editor.getText()).toBe " getPrevious \n"
#
#       it "when cursor is at end of second subword", ->
#         editor.insertText(" getPreviousWord \n")
#         editor.moveUp 1
#         editor.moveRight() for n in [0...12]
#         atom.commands.dispatch editorView, 'subword-navigation:delete-left'
#         cursorPosition = editor.getCursorBufferPosition()
#         expect(cursorPosition.row).toBe 0
#         expect(cursorPosition.column).toBe 4
#         expect(editor.getText()).toBe " getWord \n"
#
#       it "when cursor is at end of first subword", ->
#         editor.insertText(" getPreviousWord \n")
#         editor.moveUp 1
#         editor.moveRight() for n in [0...4]
#         atom.commands.dispatch editorView, 'subword-navigation:delete-left'
#         cursorPosition = editor.getCursorBufferPosition()
#         expect(cursorPosition.row).toBe 0
#         expect(cursorPosition.column).toBe 1
#         expect(editor.getText()).toBe " PreviousWord \n"
#
#     describe "on ' sub_word'", ->
#       it "when cursor is at the end", ->
#         editor.insertText(" sub_word\n")
#         editor.moveUp 1
#         editor.moveToEndOfLine()
#         atom.commands.dispatch editorView, 'subword-navigation:delete-left'
#         cursorPosition = editor.getCursorBufferPosition()
#         expect(cursorPosition.row).toBe 0
#         expect(cursorPosition.column).toBe 4
#         expect(editor.getText()).toBe " sub\n"
#
#       it "when cursor is at beginning of second subword", ->
#         editor.insertText(" sub_word\n")
#         editor.moveUp 1
#         editor.moveRight() for n in [0...4]
#         atom.commands.dispatch editorView, 'subword-navigation:delete-left'
#         cursorPosition = editor.getCursorBufferPosition()
#         expect(cursorPosition.row).toBe 0
#         expect(cursorPosition.column).toBe 1
#         expect(editor.getText()).toBe " _word\n"
#
#     describe "on ', =>'", ->
#       it "when cursor is at the beginning", ->
#         editor.insertText(", =>\n")
#         editor.moveUp 1
#         editor.moveToEndOfLine()
#         atom.commands.dispatch editorView, 'subword-navigation:delete-left'
#         cursorPosition = editor.getCursorBufferPosition()
#         expect(cursorPosition.row).toBe 0
#         expect(cursorPosition.column).toBe 2
#         expect(editor.getText()).toBe ", \n"
#
#       it "when cursor is at beginning of =", ->
#         editor.insertText(", =>\n")
#         editor.moveUp 1
#         editor.moveRight()
#         editor.moveRight()
#         atom.commands.dispatch editorView, 'subword-navigation:delete-left'
#         cursorPosition = editor.getCursorBufferPosition()
#         expect(cursorPosition.row).toBe 0
#         expect(cursorPosition.column).toBe 0
#         expect(editor.getText()).toBe "=>\n"
#
#     describe "on '  @var'", ->
#       it "when cursor is at the end", ->
#         editor.insertText("  @var\n")
#         editor.moveUp 1
#         editor.moveToEndOfLine()
#         atom.commands.dispatch editorView, 'subword-navigation:delete-left'
#         cursorPosition = editor.getCursorBufferPosition()
#         expect(cursorPosition.row).toBe 0
#         expect(cursorPosition.column).toBe 3
#         expect(editor.getText()).toBe "  @\n"
#
#       it "when cursor is at beginning of word", ->
#         editor.insertText("  @var\n")
#         editor.moveUp 1
#         editor.moveRight() for n in [0...2]
#         atom.commands.dispatch editorView, 'subword-navigation:delete-left'
#         cursorPosition = editor.getCursorBufferPosition()
#         expect(cursorPosition.row).toBe 0
#         expect(cursorPosition.column).toBe 2
#         expect(editor.getText()).toBe "  var\n"
#
#       it "when cursor is at beginning of @", ->
#         editor.insertText("  @var\n")
#         editor.moveUp 1
#         editor.moveRight()
#         atom.commands.dispatch editorView, 'subword-navigation:delete-left'
#         cursorPosition = editor.getCursorBufferPosition()
#         expect(cursorPosition.row).toBe 0
#         expect(cursorPosition.column).toBe 0
#         expect(editor.getText()).toBe "@var\n"
#
#     describe "on '\n  @var'", ->
#       it "when cursor is at the end", ->
#         editor.insertText("\n  @var\n")
#         editor.moveUp 1
#         editor.moveToEndOfLine()
#         atom.commands.dispatch editorView, 'subword-navigation:delete-left'
#         cursorPosition = editor.getCursorBufferPosition()
#         expect(cursorPosition.row).toBe 1
#         expect(cursorPosition.column).toBe 3
#         expect(editor.getText()).toBe "\n  @\n"
#
#       it "when cursor is at beginning of word", ->
#         editor.insertText("\n  @var\n")
#         editor.moveUp 1
#         editor.moveRight() for n in [0...2]
#         atom.commands.dispatch editorView, 'subword-navigation:delete-left'
#         cursorPosition = editor.getCursorBufferPosition()
#         expect(cursorPosition.row).toBe 1
#         expect(cursorPosition.column).toBe 2
#         expect(editor.getText()).toBe "\n  var\n"
#
#       it "when cursor is at beginning of @", ->
#         editor.insertText("\n  @var\n")
#         editor.moveUp 1
#         editor.moveRight() for n in [0...1]
#         atom.commands.dispatch editorView, 'subword-navigation:delete-left'
#         cursorPosition = editor.getCursorBufferPosition()
#         expect(cursorPosition.row).toBe 1
#         expect(cursorPosition.column).toBe 0
#         expect(editor.getText()).toBe "\n@var\n"
#
#     describe "on ' ()'", ->
#       it "when cursor is at the end", ->
#         editor.insertText(" ()\n")
#         editor.moveUp 1
#         editor.moveToEndOfLine()
#         atom.commands.dispatch editorView, 'subword-navigation:delete-left'
#         cursorPosition = editor.getCursorBufferPosition()
#         expect(cursorPosition.row).toBe 0
#         expect(cursorPosition.column).toBe 1
#         expect(editor.getText()).toBe " \n"
#
#       it "when first characters of line", ->
#         editor.insertText("()\n")
#         editor.moveUp 1
#         editor.moveToEndOfLine()
#         atom.commands.dispatch editorView, 'subword-navigation:delete-left'
#         cursorPosition = editor.getCursorBufferPosition()
#         expect(cursorPosition.row).toBe 0
#         expect(cursorPosition.column).toBe 0
#         expect(editor.getText()).toBe "\n"
#
#     describe "on 'a - '", ->
#       it "when cursor is at the end", ->
#         editor.insertText("a - \n")
#         editor.moveUp 1
#         editor.moveToEndOfLine()
#         atom.commands.dispatch editorView, 'subword-navigation:delete-left'
#         cursorPosition = editor.getCursorBufferPosition()
#         expect(cursorPosition.row).toBe 0
#         expect(cursorPosition.column).toBe 2
#         expect(editor.getText()).toBe "a \n"
#
#       it "when cursor is at beginning of -", ->
#         editor.insertText("a - \n")
#         editor.moveUp 1
#         editor.moveRight() for n in [0...2]
#         atom.commands.dispatch editorView, 'subword-navigation:delete-left'
#         cursorPosition = editor.getCursorBufferPosition()
#         expect(cursorPosition.row).toBe 0
#         expect(cursorPosition.column).toBe 1
#         expect(editor.getText()).toBe "a- \n"
#
#     describe "when 2 cursors", ->
#       it "when cursor is at the end", ->
#         editor.insertText("cursorOptions\ncursorOptions\n")
#         editor.moveUp 1
#         editor.moveToEndOfLine()
#         editor.addCursorAtBufferPosition([0,13])
#         atom.commands.dispatch editorView, 'subword-navigation:delete-left'
#         cursorPositions = (c.getScreenPosition() for c in editor.getCursors())
#         expect(cursorPositions[0].row).toBe 1
#         expect(cursorPositions[0].column).toBe 6
#         expect(cursorPositions[1].row).toBe 0
#         expect(cursorPositions[1].column).toBe 6
#         expect(editor.getText()).toBe "cursor\ncursor\n"
#
#       it "when undoing", ->
#         editor.insertText("cursorOptions\ncursorOptions\n")
#         editor.moveUp 1
#         editor.moveToEndOfLine()
#         editor.addCursorAtBufferPosition([0,13])
#         atom.commands.dispatch editorView, 'subword-navigation:delete-left'
#         editor.undo()
#         cursorPositions = (c.getScreenPosition() for c in editor.getCursors())
#         expect(cursorPositions[0].row).toBe 1
#         expect(cursorPositions[0].column).toBe 13
#         expect(cursorPositions[1].row).toBe 0
#         expect(cursorPositions[1].column).toBe 13
#         expect(editor.getText()).toBe "cursorOptions\ncursorOptions\n"
#
#     describe "on 'ALPHA", ->
#       it "when cursor is at the end", ->
#         editor.insertText(" ALPHA\n")
#         editor.moveUp 1
#         editor.moveToEndOfLine()
#         atom.commands.dispatch editorView, 'subword-navigation:delete-left'
#         cursorPosition = editor.getCursorBufferPosition()
#         expect(cursorPosition.row).toBe 0
#         expect(cursorPosition.column).toBe 1
#         expect(editor.getText()).toBe " \n"
#
#     describe "on 'AAADF ", ->
#       it "when cursor is at the end", ->
#         editor.insertText(" ALPHA \n")
#         editor.moveUp 1
#         editor.moveToEndOfLine()
#         atom.commands.dispatch editorView, 'subword-navigation:delete-left'
#         cursorPosition = editor.getCursorBufferPosition()
#         expect(cursorPosition.row).toBe 0
#         expect(cursorPosition.column).toBe 6
#         expect(editor.getText()).toBe " ALPHA\n"
#
#       it "when cursor is at end of word", ->
#         editor.insertText(" AAADF \n")
#         editor.moveUp 1
#         editor.moveToEndOfLine()
#         editor.moveLeft()
#         atom.commands.dispatch editorView, 'subword-navigation:delete-left'
#         cursorPosition = editor.getCursorBufferPosition()
#         expect(cursorPosition.row).toBe 0
#         expect(cursorPosition.column).toBe 1
#         expect(editor.getText()).toBe "  \n"
#
#     describe "on 'ALPhA", ->
#       it "when cursor is at the end", ->
#         editor.insertText("ALPhA\n")
#         editor.moveUp 1
#         editor.moveToEndOfLine()
#         atom.commands.dispatch editorView, 'subword-navigation:delete-left'
#         cursorPosition = editor.getCursorBufferPosition()
#         expect(cursorPosition.row).toBe 0
#         expect(cursorPosition.column).toBe 4
#         expect(editor.getText()).toBe "ALPh\n"
#
#       it "when cursor is at end of subword", ->
#         editor.insertText("ALPhA\n")
#         editor.moveUp 1
#         editor.moveRight() for n in [0...4]
#         atom.commands.dispatch editorView, 'subword-navigation:delete-left'
#         cursorPosition = editor.getCursorBufferPosition()
#         expect(cursorPosition.row).toBe 0
#         expect(cursorPosition.column).toBe 2
#         expect(editor.getText()).toBe "ALA\n"
#
#       it "when cursor is at beginning of subword", ->
#         editor.insertText("ALPhA\n")
#         editor.moveUp 1
#         editor.moveRight()
#         editor.moveRight()
#         atom.commands.dispatch editorView, 'subword-navigation:delete-left'
#         cursorPosition = editor.getCursorBufferPosition()
#         expect(cursorPosition.row).toBe 0
#         expect(cursorPosition.column).toBe 0
#         expect(editor.getText()).toBe "PhA\n"
#
#     describe "on ' 88.1 ", ->
#       it "when cursor is at the end", ->
#         editor.insertText(" 88.1 \n")
#         editor.moveUp 1
#         editor.moveToEndOfLine()
#         atom.commands.dispatch editorView, 'subword-navigation:delete-left'
#         cursorPosition = editor.getCursorBufferPosition()
#         expect(cursorPosition.row).toBe 0
#         expect(cursorPosition.column).toBe 5
#         expect(editor.getText()).toBe " 88.1\n"
#
#       it "when cursor is at end of word", ->
#         editor.insertText(" 88.1 \n")
#         editor.moveUp 1
#         editor.moveToEndOfLine()
#         editor.moveLeft()
#         atom.commands.dispatch editorView, 'subword-navigation:delete-left'
#         cursorPosition = editor.getCursorBufferPosition()
#         expect(cursorPosition.row).toBe 0
#         expect(cursorPosition.column).toBe 4
#         expect(editor.getText()).toBe " 88. \n"
#
#       it "when cursor is at end of subword", ->
#         editor.insertText(" 88.1 \n")
#         editor.moveUp 1
#         editor.moveRight() for n in [0...3]
#         atom.commands.dispatch editorView, 'subword-navigation:delete-left'
#         cursorPosition = editor.getCursorBufferPosition()
#         expect(cursorPosition.row).toBe 0
#         expect(cursorPosition.column).toBe 1
#         expect(editor.getText()).toBe " .1 \n"
